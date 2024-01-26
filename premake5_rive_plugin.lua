local dependency = require('dependency')

harfbuzz = dependency.github('harfbuzz/harfbuzz', '858570b1d9912a1b746ab39fbe62a646c4f7a5b1')
sheenbidi = dependency.github('Tehreer/SheenBidi', 'v2.6')

workspace('rive_text')
configurations({ 'debug', 'release' })

source = os.isdir('../../packages/runtime') and '../../packages/runtime' or 'macos/rive-cpp'

project('rive_sheenbidi')
do
    kind('StaticLib')
    language('C')
    toolset('clang')
    targetdir('shared_lib/build/bin/%{cfg.buildcfg}/')
    objdir('shared_lib/build/obj/%{cfg.buildcfg}/')

    includedirs({ sheenbidi .. '/Headers' })

    filter({ 'options:arch=wasm' })
    do
        targetdir('wasm/build/bin/%{cfg.buildcfg}/')
        objdir('wasm/build/obj/%{cfg.buildcfg}/')
    end

    filter('configurations:debug')
    do
        files({
            sheenbidi .. '/Source/BidiChain.c',
            sheenbidi .. '/Source/BidiTypeLookup.c',
            sheenbidi .. '/Source/BracketQueue.c',
            sheenbidi .. '/Source/GeneralCategoryLookup.c',
            sheenbidi .. '/Source/IsolatingRun.c',
            sheenbidi .. '/Source/LevelRun.c',
            sheenbidi .. '/Source/PairingLookup.c',
            sheenbidi .. '/Source/RunQueue.c',
            sheenbidi .. '/Source/SBAlgorithm.c',
            sheenbidi .. '/Source/SBBase.c',
            sheenbidi .. '/Source/SBCodepointSequence.c',
            sheenbidi .. '/Source/SBLine.c',
            sheenbidi .. '/Source/SBLog.c',
            sheenbidi .. '/Source/SBMirrorLocator.c',
            sheenbidi .. '/Source/SBParagraph.c',
            sheenbidi .. '/Source/SBScriptLocator.c',
            sheenbidi .. '/Source/ScriptLookup.c',
            sheenbidi .. '/Source/ScriptStack.c',
            sheenbidi .. '/Source/StatusStack.c',
        })
    end
    filter('configurations:release')
    do
        files({ sheenbidi .. '/Source/SheenBidi.c' })
    end

    buildoptions({ '-Wall', '-ansi', '-pedantic', '-DANSI_DECLARATORS' })

    buildoptions({
        '-Wno-c++17-extensions',
        '-fno-exceptions',
        '-fno-rtti',
        '-fno-unwind-tables',
        '-Wno-deprecated-builtins',
    })

    filter({ 'options:arch=wasm' })
    do
        buildoptions({
            '-s STRICT=1',
            '-s DISABLE_EXCEPTION_CATCHING=1',
            '-DEMSCRIPTEN_HAS_UNBOUND_TYPE_NAMES=0',
            '--no-entry',
        })
    end

    filter('configurations:debug')
    do
        defines({ 'DEBUG' })
        symbols('On')
    end

    filter('configurations:release')
    do
        defines({ 'RELEASE', 'NDEBUG', 'SB_CONFIG_UNITY' })
        optimize('On')
        buildoptions({ '-Oz', '-g0', '-flto' })

        linkoptions({ '-Oz', '-g0', '-flto' })
    end
    filter({ 'system:macosx', 'options:arch=arm64' })
    do
        buildoptions({ '-target arm64-apple-macos11' })
        linkoptions({ '-target arm64-apple-macos11' })
    end
    filter({ 'system:macosx', 'options:arch=x86_64' })
    do
        buildoptions({ '-target x86_64-apple-macos10.12' })
        linkoptions({ '-target x86_64-apple-macos10.12' })
    end
end

project('rive_text')
do
    kind('SharedLib')
    language('C++')
    cppdialect('C++17')
    toolset('clang')
    targetdir('shared_lib/build/bin/%{cfg.buildcfg}')
    objdir('shared_lib/build/obj/%{cfg.buildcfg}')

    dependson({ 'rive_sheenbidi' })

    defines({
        'WITH_RIVE_TEXT',
        'WITH_RIVE_AUDIO',
        'HAVE_OT',
        'HB_NO_FALLBACK_SHAPE',
        'HB_NO_WIN1256',
    })

    includedirs({
        source .. '/include',
        source .. '/skia/renderer/include',
        harfbuzz .. '/src/',
        sheenbidi .. '/Headers',
    })

    files({
        source .. '/src/renderer.cpp',
        source .. '/src/math/mat2d.cpp',
        source .. '/src/math/raw_path.cpp',
        source .. '/src/text/font_hb.cpp',
        source .. '/src/text/line_breaker.cpp',
        harfbuzz .. '/src/hb-aat-layout.cc',
        harfbuzz .. '/src/hb-aat-map.cc',
        harfbuzz .. '/src/hb-blob.cc',
        harfbuzz .. '/src/hb-buffer-serialize.cc',
        harfbuzz .. '/src/hb-buffer-verify.cc',
        harfbuzz .. '/src/hb-buffer.cc',
        harfbuzz .. '/src/hb-common.cc',
        harfbuzz .. '/src/hb-draw.cc',
        harfbuzz .. '/src/hb-face.cc',
        harfbuzz .. '/src/hb-font.cc',
        harfbuzz .. '/src/hb-map.cc',
        harfbuzz .. '/src/hb-number.cc',
        harfbuzz .. '/src/hb-ot-cff1-table.cc',
        harfbuzz .. '/src/hb-ot-cff2-table.cc',
        harfbuzz .. '/src/hb-ot-color.cc',
        harfbuzz .. '/src/hb-ot-face.cc',
        harfbuzz .. '/src/hb-ot-font.cc',
        harfbuzz .. '/src/hb-ot-layout.cc',
        harfbuzz .. '/src/hb-ot-map.cc',
        harfbuzz .. '/src/hb-ot-math.cc',
        harfbuzz .. '/src/hb-ot-meta.cc',
        harfbuzz .. '/src/hb-ot-metrics.cc',
        harfbuzz .. '/src/hb-ot-name.cc',
        harfbuzz .. '/src/hb-ot-shaper-arabic.cc',
        harfbuzz .. '/src/hb-ot-shaper-default.cc',
        harfbuzz .. '/src/hb-ot-shaper-hangul.cc',
        harfbuzz .. '/src/hb-ot-shaper-hebrew.cc',
        harfbuzz .. '/src/hb-ot-shaper-indic-table.cc',
        harfbuzz .. '/src/hb-ot-shaper-indic.cc',
        harfbuzz .. '/src/hb-ot-shaper-khmer.cc',
        harfbuzz .. '/src/hb-ot-shaper-myanmar.cc',
        harfbuzz .. '/src/hb-ot-shaper-syllabic.cc',
        harfbuzz .. '/src/hb-ot-shaper-thai.cc',
        harfbuzz .. '/src/hb-ot-shaper-use.cc',
        harfbuzz .. '/src/hb-ot-shaper-vowel-constraints.cc',
        harfbuzz .. '/src/hb-ot-shape-fallback.cc',
        harfbuzz .. '/src/hb-ot-shape-normalize.cc',
        harfbuzz .. '/src/hb-ot-shape.cc',
        harfbuzz .. '/src/hb-ot-tag.cc',
        harfbuzz .. '/src/hb-ot-var.cc',
        harfbuzz .. '/src/hb-set.cc',
        harfbuzz .. '/src/hb-shape-plan.cc',
        harfbuzz .. '/src/hb-shape.cc',
        harfbuzz .. '/src/hb-shaper.cc',
        harfbuzz .. '/src/hb-static.cc',
        harfbuzz .. '/src/hb-subset-cff-common.cc',
        harfbuzz .. '/src/hb-subset-cff1.cc',
        harfbuzz .. '/src/hb-subset-cff2.cc',
        harfbuzz .. '/src/hb-subset-input.cc',
        harfbuzz .. '/src/hb-subset-plan.cc',
        harfbuzz .. '/src/hb-subset-repacker.cc',
        harfbuzz .. '/src/hb-subset.cc',
        harfbuzz .. '/src/hb-ucd.cc',
        harfbuzz .. '/src/hb-unicode.cc',
    })

    links({ 'rive_sheenbidi' })

    buildoptions({
        '-Wno-c++17-extensions',
        '-fno-exceptions',
        '-fno-rtti',
        '-fno-unwind-tables',
        '-Wno-deprecated-builtins',
        '-DANSI_DECLARATORS',
    })

    filter({ 'not options:arch=wasm' })
    do
        files({ 'macos/rive_text/rive_text.cpp' })
    end

    filter({ 'options:arch=wasm' })
    do
        targetdir('wasm/build/bin/%{cfg.buildcfg}/')
        objdir('wasm/build/obj/%{cfg.buildcfg}/')
        kind('ConsoleApp')
        files({ 'wasm/rive_text_bindings.cpp' })
        buildoptions({
            '-s STRICT=1',
            '-s DISABLE_EXCEPTION_CATCHING=1',
            '-DEMSCRIPTEN_HAS_UNBOUND_TYPE_NAMES=0',
            '--no-entry',
        })
        linkoptions({
            '--closure 1',
            '--closure-args="--externs ./wasm/js/externs.js"',
            '--bind',
            '-s FORCE_FILESYSTEM=0',
            '-s MODULARIZE=1',
            '-s NO_EXIT_RUNTIME=1',
            '-s STRICT=1',
            '-s ALLOW_MEMORY_GROWTH=1',
            '-s DISABLE_EXCEPTION_CATCHING=1',
            '-s WASM=1',
            '-s USE_ES6_IMPORT_META=0',
            '-s EXPORT_NAME="RiveText"',
            '-DEMSCRIPTEN_HAS_UNBOUND_TYPE_NAMES=0',
            '--no-entry',
            '--pre-js ./wasm/js/rive_text.js',
        })
    end

    linkoptions({
        '-Wno-c++17-extensions',
        '-fno-exceptions',
        '-fno-rtti',
        '-fno-unwind-tables',
    })

    filter({ 'options:arch=wasm', 'options:single_file' })
    do
        linkoptions({
            '-o %{cfg.targetdir}/rive_text_single.js',
            '-s SINGLE_FILE=1',
        })
    end

    filter({ 'options:arch=wasm', 'options:not single_file' })
    do
        linkoptions({ '-o %{cfg.targetdir}/rive_text.js' })
    end

    filter('configurations:debug')
    do
        defines({ 'DEBUG' })
        symbols('On')
    end

    filter({ 'configurations:debug', 'options:arch=wasm' })
    do
        linkoptions({ '-s ASSERTIONS=1' })
    end

    filter('configurations:release')
    do
        defines({ 'RELEASE' })
        defines({ 'NDEBUG' })
        optimize('On')

        buildoptions({ '-Oz', '-g0', '-flto' })

        linkoptions({ '-Oz', '-g0', '-flto' })
    end

    filter({ 'configurations:release', 'options:arch=wasm' })
    do
        linkoptions({ '-s ASSERTIONS=0' })
    end

    filter({ 'system:macosx', 'options:arch=arm64' })
    do
        buildoptions({ '-target arm64-apple-macos11' })
        linkoptions({ '-target arm64-apple-macos11' })
    end
    filter({ 'system:macosx', 'options:arch=x86_64' })
    do
        buildoptions({ '-target x86_64-apple-macos10.12' })
        linkoptions({ '-target x86_64-apple-macos10.12' })
    end
end

newoption({
    trigger = 'single_file',
    description = 'Set when the wasm should be packed in with the js code.',
})

newoption({
    trigger = 'arch',
    description = 'Architectures we can target',
    allowed = { { 'x86_64' }, { 'arm64' }, { 'wasm' } },
})
