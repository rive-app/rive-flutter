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
    if [ $FORCE == "true" ] || [ ! -d rive-cpp ]; then
        rm -fR rive-cpp
        if [ -d ../../runtime ]; then
            echo "Getting rive-cpp from current repo."
            export INSTALL_TO=$PWD
            mkdir -p rive-cpp
            # cp -fR ../../runtime rive-cpp
            # git clone machine1:/path/to/project machine2:/target/path
            pushd ../../runtime

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
        # TODO: Fix this so we build the rive.podspec file based on paths determined
        # here (for harfbuzz and sheenbidi)
        #
        # install dependencies from rive-cpp
        # pushd rive-cpp/dependencies/macosx
        # source config_directories.sh
        # popd
        # pushd rive-cpp
        # ./build.sh
        # popd
    fi

    # For now just manually install the deps.
    if [ $FORCE == "true" ] || [ ! -d harfbuzz ]; then
        rm -fR harfbuzz
        echo "Cloning Harfbuzz."
        git clone https://github.com/harfbuzz/harfbuzz
        pushd harfbuzz
        git checkout "6.0.0" .
        popd
    fi
    if [ $FORCE == "true" ] || [ ! -d SheenBidi ]; then
        rm -fR SheenBidi
        echo "Cloning SheenBidi."
        git clone https://github.com/Tehreer/SheenBidi.git
        pushd SheenBidi
        git checkout v2.6 .
        popd
    fi
}

pushd macos
installRiveCpp
popd

pushd ios
installRiveCpp
popd
