#!/bin/bash
set -e

# silence push/pop
pushd() {
    command pushd "$@" >/dev/null
}

popd() {
    command popd "$@" >/dev/null
}

FORCE=false
for var in "$@"; do
    if [[ $var = "force" ]]; then
        FORCE=true
    fi
done

function installRiveCpp {
    if [ $FORCE != "true" ] && [ -d rive-cpp ]; then
        return
    fi
    rm -fR rive-cpp
    if [ -d ../../../packages/runtime ]; then
        echo "Getting rive-cpp from current repo."
        export INSTALL_TO=$PWD
        mkdir -p rive-cpp
        # cp -fR ../../../packages/runtime rive-cpp
        # git clone machine1:/path/to/project machine2:/target/path
        pushd ../../../packages/runtime

        function copyRepoFile {
            mkdir -p $(dirname $INSTALL_TO/rive-cpp/$1)
            cp $1 $INSTALL_TO/rive-cpp/$1
            echo -en "\r\033[K$1"
        }
        export -f copyRepoFile
        git ls-files | xargs -n1 bash -c 'copyRepoFile "$@"' _
        echo -en "\r\033[K"
        popd
    else
        echo "Cloning rive-cpp."
        git clone https://github.com/rive-app/rive-cpp
    fi
}

pushd macos
installRiveCpp
if [ $FORCE == "true" ] || [ ! -d harfbuzz ]; then
    rm -fR harfbuzz
    echo "Cloning Harfbuzz."
    git clone https://github.com/harfbuzz/harfbuzz
    pushd harfbuzz
    git checkout 858570b1d9912a1b746ab39fbe62a646c4f7a5b1 .
    popd
fi
installRiveCpp
popd

pushd ios
if [ $FORCE == "true" ] || [ ! -d harfbuzz ]; then
    rm -fR harfbuzz
    echo "Cloning Harfbuzz."
    git clone https://github.com/harfbuzz/harfbuzz
    pushd harfbuzz
    git checkout 858570b1d9912a1b746ab39fbe62a646c4f7a5b1 .
    popd
fi
installRiveCpp
popd
