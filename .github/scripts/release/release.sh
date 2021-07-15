#!/bin/bash

set -e 

RELEASE_VERSION=`npm run release -- --ci --release-version | tail -n 1`
if ! command -v cider &> /dev/null
then
    pub global activate cider
fi

pushd ../../../
cider version $RELEASE_VERSION
popd

npm run release -- --ci

pushd ../../../
dart pub publish -f
popd