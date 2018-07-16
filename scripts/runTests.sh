#!/usr/bin/env bash

# runs tests for a package that has tests
# does not run integration tests
runTests () {
  cd $1;
  if [ -f "pubspec.yaml" ] && [ -d "test" ]; then
    echo "running tests in $1"
    # check if build_runner needs to be run
    if grep build_runner pubspec.yaml > /dev/null; then
      flutter packages get
      flutter packages pub run build_runner build --delete-conflicting-outputs
    fi
    # run tests with coverage
    flutter test --coverage
    if [ -d "coverage" ]; then
      # combine line coverage info from package tests to a common file
      escapedPath="$(echo ${1:2} | sed 's/\//\\\//g')"
      sed "s/^SF:lib/SF:$escapedPath\/lib/g" coverage/lcov.info >> $2/lcov.info
    fi
  fi
}
export -f runTests
# if running locally
if [ -f "lcov.info" ]; then
  rm lcov.info
fi
# expects to find most packages at second directory level
find . -maxdepth 2 -type d -exec bash -c 'runTests "$0" `pwd`' {} \;
# find exits with 0
