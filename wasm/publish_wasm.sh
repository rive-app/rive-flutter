#!/bin/bash

set -ex

# Build the wasm and js files that will be released.
./build_wasm.sh clean release

# Make sure tests succeed.
npm test

# Bump version in package.json and referenced by dart code. This very
# intentionally bumps major version.
npm run bump-version

# Publish to npm
npm publish --access public
