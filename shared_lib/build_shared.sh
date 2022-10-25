#!/bin/sh
set -e

CONFIG=debug
SINGLE=
for var in "$@"; do
    if [[ $var = "release" ]]; then
        CONFIG=release
    fi
done

pushd ../
./update_dependencies.sh
popd

if [[ ! -f "bin/premake5" ]]; then
    mkdir -p bin
    pushd bin
    echo Downloading Premake5
    curl https://github.com/premake/premake-core/releases/download/v5.0.0-beta1/premake-5.0.0-beta1-macosx.tar.gz -L -o premake_macosx.tar.gz
    # Export premake5 into bin
    tar -xvf premake_macosx.tar.gz 2>/dev/null
    # Delete downloaded archive
    rm premake_macosx.tar.gz
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
