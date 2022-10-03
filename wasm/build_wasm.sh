#!/bin/sh
set -e

CONFIG=debug
SINGLE=
for var in "$@"; do
    if [[ $var = "release" ]]; then
        CONFIG=release
    fi
    if [[ $var = "single" ]]; then
        SINGLE=--single_file
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

if [[ ! -f "bin/emsdk/emsdk_env.sh" ]]; then
    mkdir -p bin
    pushd bin
    git clone https://github.com/emscripten-core/emsdk.git
    pushd emsdk
    ./emsdk install latest
    ./emsdk activate latest
    popd
    popd
fi
source ./bin/emsdk/emsdk_env.sh

export PREMAKE=bin/premake5

$PREMAKE --file=./premake5_wasm.lua gmake2 $SINGLE

for var in "$@"; do
    if [[ $var = "clean" ]]; then
        make clean
        make config=release clean
    fi
done

AR=emar CC=emcc CXX=em++ make config=$CONFIG -j$(($(sysctl -n hw.physicalcpu) + 1))

du -hs build/bin/$CONFIG/render_font.wasm
