#!/usr/bin/env bash

# runs tests for a package that has tests
# does not run integration tests
runTests () {
  cd $1;
  if [ -f "pubspec.yaml" ] && [ -d "test" ]; then
    echo "running tests in $1"
    # check if build_runner needs to be run
    # todo: fix build in ./example/built_redux (not regenerating *.g.dart files in dart 2.0)
    if grep build_runner pubspec.yaml > /dev/null  && [ "$1" != "./example/built_redux" ]; then
      flutter packages get
      flutter packages pub run build_runner build --delete-conflicting-outputs
    fi
    # run tests with coverage
    if grep flutter pubspec.yaml > /dev/null; then
      echo "run flutter tests"
      rm -rf "coverage"
      if [ -f "test/all_tests.dart" ]; then
        flutter test --coverage test/all_tests.dart
      else
        flutter test --coverage
      fi
    else
      # pure dart
      echo "run dart tests"
      pub get
      testFile="test/all_tests.dart"
      dart --pause-isolates-on-exit --enable-vm-service=8111 $testFile &
      sleep 5
      pub global run coverage:collect_coverage --uri=http://localhost:8111 -o coverage.json --resume-isolates
      pub global run coverage:format_coverage --packages=.packages -i coverage.json --report-on lib --lcov > lcov.info
      rm -f coverage.json
    fi
  fi
}

export -f runTests

# expects to find most packages at second directory level
find . -maxdepth 2 -type d -exec bash -c 'runTests "$0"' {} \;
# find exits with 0
