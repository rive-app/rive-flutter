"""Run the example app's renderer benchmark on BrowserStack App Automate.

Opens the benchmark page through its `riveexample://bench` deep link, once per
scenario and device, and reads back the per-second `[rive-bench]` lines the
page logs with `stats=1`. See packages/rive_native/ANDROID_DEVICE_TESTING.md
for what the numbers mean and what earlier runs found.

Build one APK per variant you want to compare, with every ABI (a device farm
picks its own):

    cd packages/rive_flutter/example && flutter build apk --profile

then, with credentials in the environment:

    export BROWSERSTACK_USERNAME=... BROWSERSTACK_ACCESS_KEY=...
    python3 tool/browserstack_bench.py \\
        --apk before=path/to/before.apk --apk after=path/to/after.apk

Standard library only. Uploads are cached by content hash, and every output
goes under build/browserstack/, which is ignored by git.
"""
import argparse
import base64
import concurrent.futures
import hashlib
import json
import os
import re
import statistics
import sys
import time
import urllib.request

API = 'https://api-cloud.browserstack.com/app-automate'
HUB = 'https://hub-cloud.browserstack.com/wd/hub'
PACKAGE = 'com.example.rive_example'

# Scenarios, as deep link query strings. Feather-free assets throughout: the
# Flutter renderer does not draw vector feathering, so a feathered file would
# make the two renderers do different work.
SCENARIOS = [
    ('small_x4', 'asset=little_machine.riv&count=4'),
    ('small_x8', 'asset=little_machine.riv&count=8'),
    ('complex_x4', 'asset=vehicles.riv&count=4'),
    ('flutter_small_x4', 'asset=little_machine.riv&count=4&renderer=flutter'),
]

# Chosen for spread of GPU vendor, GL implementation, refresh rate and tier
# rather than by model. BrowserStack's oldest Android is 10, and its Samsung
# flagships have run at 30 Hz, so neither very old drivers nor 120 Hz are
# covered here.
DEFAULT_DEVICES = [
    'Samsung Galaxy S20:10.0',  # oldest driver available
    'Vivo Y21:11.0',  # PowerVR GE8320, low end
    'Samsung Galaxy M32:11.0',  # Mali-G52, low end
    'Google Pixel 6:12.0',  # Mali-G78, 90 Hz
    'Samsung Galaxy S22:12.0',  # Xclipse 920: GL through ANGLE on Vulkan
    'Google Pixel 7:13.0',  # Mali-G710, 90 Hz
    'Samsung Galaxy S23:13.0',  # Adreno 740
    'Samsung Galaxy S24:14.0',  # Xclipse 940: GL through ANGLE on Vulkan
    'Samsung Galaxy Tab A9 Plus:14.0',  # Adreno, low-end tablet
]

BENCH_LINE = re.compile(
    r'I/flutter\s*\(\s*(\d+)\): \[rive-bench\] flutter ([\d.]+)fps .*? '
    r'rive ([\d.]+)/s total')
PRESENT_LINE = re.compile(r'\(\s*(\d+)\): Rive GL present: (.+)$')
ANGLE_LINE = re.compile(r'Renderer \((ANGLE \(.*?\) on [^)]*)\)')


def auth_header():
    user = os.environ.get('BROWSERSTACK_USERNAME')
    key = os.environ.get('BROWSERSTACK_ACCESS_KEY')
    if not user or not key:
        sys.exit('Set BROWSERSTACK_USERNAME and BROWSERSTACK_ACCESS_KEY.')
    return 'Basic ' + base64.b64encode(f'{user}:{key}'.encode()).decode()


def request(auth, method, url, body=None, raw=False, timeout=300):
    headers = {'Authorization': auth}
    data = None
    if body is not None:
        data = json.dumps(body).encode()
        headers['Content-Type'] = 'application/json'
    req = urllib.request.Request(url, data=data, headers=headers, method=method)
    with urllib.request.urlopen(req, timeout=timeout) as response:
        payload = response.read()
    return payload if raw else json.loads(payload or b'{}')


def upload(auth, path, cache_path):
    """Upload once per content hash; BrowserStack keeps apps for 30 days."""
    with open(path, 'rb') as f:
        blob = f.read()
    digest = hashlib.md5(blob).hexdigest()
    cache = {}
    if os.path.exists(cache_path):
        with open(cache_path) as f:
            cache = json.load(f)
    if digest in cache:
        return cache[digest]
    boundary = 'rivebench' + digest
    body = (f'--{boundary}\r\nContent-Disposition: form-data; name="file"; '
            f'filename="{os.path.basename(path)}"\r\n'
            'Content-Type: application/vnd.android.package-archive\r\n\r\n'
            ).encode() + blob + f'\r\n--{boundary}--\r\n'.encode()
    req = urllib.request.Request(
        f'{API}/upload', data=body, method='POST',
        headers={'Authorization': auth,
                 'Content-Type': f'multipart/form-data; boundary={boundary}'})
    with urllib.request.urlopen(req, timeout=600) as response:
        url = json.loads(response.read())['app_url']
    cache[digest] = url
    with open(cache_path, 'w') as f:
        json.dump(cache, f, indent=1)
    return url


def run_session(auth, device, os_version, variant, app_url, build, seconds,
                outdir):
    caps = {'capabilities': {'alwaysMatch': {
        'platformName': 'android',
        'appium:app': app_url,
        'appium:autoLaunch': False,
        'appium:automationName': 'UiAutomator2',
        'bstack:options': {
            'deviceName': device,
            'osVersion': os_version,
            'projectName': 'rive renderer benchmark',
            'buildName': build,
            'sessionName': f'{variant} {device}',
            'deviceLogs': True,
            'idleTimeout': 300,
        },
    }}}
    session = request(auth, 'POST', f'{HUB}/session', caps, timeout=900)
    sid = session['value']['sessionId']
    try:
        for name, query in SCENARIOS:
            # Intent extras do not survive BrowserStack's startActivity, so
            # restart the app through its deep link instead.
            request(auth, 'POST', f'{HUB}/session/{sid}/appium/device/terminate_app',
                    {'appId': PACKAGE})
            request(auth, 'POST', f'{HUB}/session/{sid}/execute/sync', {
                'script': 'mobile: deepLink',
                'args': [{'url': f'riveexample://bench?{query}&stats=1',
                          'package': PACKAGE}]})
            time.sleep(seconds)
            png = request(auth, 'GET', f'{HUB}/session/{sid}/screenshot')['value']
            with open(os.path.join(outdir, f'{variant}_{name}.png'), 'wb') as f:
                f.write(base64.b64decode(png))
    finally:
        request(auth, 'DELETE', f'{HUB}/session/{sid}')
    info = request(auth, 'GET', f'{API}/sessions/{sid}.json')['automation_session']
    logs = b''
    for _ in range(10):  # device logs can take a while to appear
        try:
            logs = request(auth, 'GET', f'{API}/builds/{info["build_hashed_id"]}'
                           f'/sessions/{sid}/devicelogs', raw=True)
            if logs:
                break
        except Exception:
            pass
        time.sleep(15)
    with open(os.path.join(outdir, f'{variant}.log'), 'wb') as f:
        f.write(logs)
    return logs.decode(errors='replace')


def summarize(log):
    """One process per scenario, in SCENARIOS order: split the per-second
    lines by pid and average each scenario's last ten seconds."""
    by_pid, order, present, angle = {}, [], {}, None
    for line in log.splitlines():
        if (m := ANGLE_LINE.search(line)):
            angle = m.group(1)
        if (m := PRESENT_LINE.search(line)):
            present[m.group(1)] = m.group(2).strip()
        if (m := BENCH_LINE.search(line)):
            pid = m.group(1)
            if pid not in by_pid:
                by_pid[pid] = []
                order.append(pid)
            by_pid[pid].append((float(m.group(2)), float(m.group(3))))
    out = {'gl': angle or 'native', 'scenarios': {}}
    for (name, query), pid in zip(SCENARIOS, order):
        samples = by_pid[pid][-10:]
        app = statistics.mean(s[0] for s in samples)
        rive = statistics.mean(s[1] for s in samples)
        count = int(re.search(r'count=(\d+)', query).group(1))
        flutter = 'renderer=flutter' in query
        out['scenarios'][name] = {
            'app_fps': round(app, 1),
            # With the Flutter renderer Rive draws inside the app's frames, so
            # its rate is the app's.
            'per_widget': round(app if flutter else rive / count, 1),
            'present': present.get(pid),
        }
    return out


def main():
    parser = argparse.ArgumentParser(description=__doc__.split('\n\n')[0])
    parser.add_argument('--apk', action='append', required=True,
                        metavar='NAME=PATH', help='a variant to run; repeat')
    parser.add_argument('--devices', nargs='*', default=DEFAULT_DEVICES,
                        metavar='DEVICE:OS')
    parser.add_argument('--parallel', type=int, default=2,
                        help="concurrent sessions; at most the plan's limit")
    parser.add_argument('--seconds', type=int, default=25,
                        help='time on each scenario before moving on')
    parser.add_argument('--out', default=os.path.join('build', 'browserstack'))
    args = parser.parse_args()

    auth = auth_header()
    os.makedirs(args.out, exist_ok=True)
    cache = os.path.join(args.out, 'uploads.json')
    variants = dict(spec.split('=', 1) for spec in args.apk)
    apps = {name: upload(auth, path, cache) for name, path in variants.items()}
    build = time.strftime('renderer benchmark %Y-%m-%d %H:%M')

    jobs = []
    for spec in args.devices:
        device, os_version = spec.split(':')
        outdir = os.path.join(args.out, device.replace(' ', '_'))
        os.makedirs(outdir, exist_ok=True)
        for name, url in apps.items():
            jobs.append((auth, device, os_version, name, url, build,
                         args.seconds, outdir))

    results = {}
    with concurrent.futures.ThreadPoolExecutor(args.parallel) as pool:
        futures = {pool.submit(run_session, *job): job for job in jobs}
        for future in concurrent.futures.as_completed(futures):
            device, name = futures[future][1], futures[future][3]
            try:
                results.setdefault(device, {})[name] = summarize(future.result())
                print(f'done {device} {name}', flush=True)
            except Exception as error:  # keep the other sessions going
                results.setdefault(device, {})[name] = {'error': str(error)}
                print(f'FAILED {device} {name}: {error}', flush=True)

    with open(os.path.join(args.out, 'results.json'), 'w') as f:
        json.dump(results, f, indent=1)

    names = list(variants)
    print('\n| device | GL | scenario | ' + ' | '.join(names) + ' |')
    print('| --- | --- | --- | ' + ' | '.join('---' for _ in names) + ' |')
    for device, by_variant in sorted(results.items()):
        gl = next((r.get('gl') for r in by_variant.values() if 'gl' in r), '?')
        for scenario, _ in SCENARIOS:
            cells = []
            for name in names:
                cell = by_variant.get(name, {}).get('scenarios', {}).get(scenario)
                cells.append(f"{cell['per_widget']}/s, app {cell['app_fps']}"
                             if cell else '-')
            print(f'| {device} | {gl} | {scenario} | ' + ' | '.join(cells) + ' |')


if __name__ == '__main__':
    main()
