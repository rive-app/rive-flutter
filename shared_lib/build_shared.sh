#!/bin/bash
set -e

CONFIG=debug
SINGLE=
for var in "$@"; do
    if [[ $var = "release" ]]; then
        CONFIG=release
    fi
done

unameOut="$(uname -s)"
case "${unameOut}" in
Linux*) MACHINE=linux ;;
Darwin*) MACHINE=mac ;;
CYGWIN*) MACHINE=cygwin ;;
MINGW*) MACHINE=mingw ;;
*) MACHINE="UNKNOWN:${unameOut}" ;;
esac

pushd ../
./update_dependencies.sh
popd

if [[ ! -f "bin/premake5" ]]; then
    mkdir -p bin
    pushd bin
    echo Downloading Premake5
    if [ "$MACHINE" = 'mac' ]; then
        PREMAKE_URL=https://github.com/premake/premake-core/releases/download/v5.0.0-beta2/premake-5.0.0-beta2-macosx.tar.gz
    else
        PREMAKE_URL=https://github.com/premake/premake-core/releases/download/v5.0.0-beta2/premake-5.0.0-beta2-linux.tar.gz
    fi
    curl $PREMAKE_URL -L -o premake.tar.gz
    # Export premake5 into bin
    tar -xvf premake.tar.gz 2>/dev/null
    # Delete downloaded archive
    rm premake.tar.gz
    popd
fi

export PREMAKE=bin/premake5

$PREMAKE --scripts=../macos/rive-cpp/build --file=../premake5_rive_plugin.lua gmake2 --arch=x86_64

cd ..
for var in "$@"; do
    if [[ $var = "clean" ]]; then
        make clean
        make config=release clean
    fi
done

make config=$CONFIG -j$(($(sysctl -n hw.physicalcpu) + 1))
if [ "$MACHINE" = 'mac' ]; then
    du -hs shared_lib/build/bin/debug/librive_text.dylib
else
    du -hs shared_lib/build/bin/debug/librive_text.so
fi
