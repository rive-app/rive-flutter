#!/bin/bash
set -e

pushd macos

rm -fR harfbuzz
echo "Cloning Harfbuzz."
git clone https://github.com/harfbuzz/harfbuzz
pushd harfbuzz
git checkout 858570b1d9912a1b746ab39fbe62a646c4f7a5b1 .
popd

rm -fR rive-cpp
echo "Cloning rive-cpp."
git clone https://github.com/rive-app/rive-cpp

popd

pushd ios

rm -fR harfbuzz
echo "Cloning Harfbuzz."
git clone https://github.com/harfbuzz/harfbuzz
pushd harfbuzz
git checkout 858570b1d9912a1b746ab39fbe62a646c4f7a5b1 .
popd

rm -fR rive-cpp
echo "Cloning rive-cpp."
git clone https://github.com/rive-app/rive-cpp

popd
