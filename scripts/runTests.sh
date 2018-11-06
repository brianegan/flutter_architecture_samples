#!/usr/bin/env bash

# remember some failed commands and report on exit
error=false

show_help() {
    printf "usage: $0 [--help] [--report] [<path to package>]

Tool for running all unit and widget tests with code coverage.
(run from root of repo)

where:
    <path to package>
        run tests for package at path only
        (otherwise runs all tests)
    --report
        run a coverage report
        (requires lcov installed)
    --help
        print this message

requires code_coverage package
(install with 'pub global activate coverage')
"
    exit 1
}

# run unit and widget tests
runTests () {
  cd $1;
  if [ -f "pubspec.yaml" ] && [ -d "test" ]; then
    echo "running tests in $1"
#    flutter packages get || echo "Ignore exit(1)"
    flutter packages get
   # check if build_runner needs to be run
    # todo: fix build in ./example/built_redux (not regenerating *.g.dart files in dart 2.0)
    if grep build_runner pubspec.yaml > /dev/null  && [ "$1" != "./example/built_redux" ]; then
      flutter packages pub run build_runner build --delete-conflicting-outputs
    fi

    escapedPath="$(echo $1 | sed 's/\//\\\//g')"

    # run tests with coverage
    if grep flutter pubspec.yaml > /dev/null; then
      echo "run flutter tests"
      if [ -f "test/all_tests.dart" ]; then
        flutter test --coverage test/all_tests.dart || error=true
      else
        flutter test --coverage || error=true
      fi
      if [ -d "coverage" ]; then
        # combine line coverage info from package tests to a common file
        sed "s/^SF:lib/SF:$escapedPath\/lib/g" coverage/lcov.info >> $2/lcov.info
        rm -rf "coverage"
      fi
    else
      # pure dart
      echo "run dart tests"
      pub get
      pub global run coverage:collect_coverage --port=8111 -o coverage.json --resume-isolates --wait-paused &
      dart --pause-isolates-on-exit --enable-vm-service=8111 "test/all_tests.dart" || error=true
      pub global run coverage:format_coverage --packages=.packages -i coverage.json --report-on lib --lcov --out lcov.info
      if [ -f "lcov.info" ]; then
        # combine line coverage info from package tests to a common file
        sed "s/^SF:.*lib/SF:$escapedPath\/lib/g" lcov.info >> $2/lcov.info
        rm lcov.info
      fi
      rm -f coverage.json
    fi
  fi
  cd - > /dev/null
}

runReport() {
    if [ -f "lcov.info" ] && ! [ "$TRAVIS" ]; then
        genhtml lcov.info -o coverage --no-function-coverage -s -p `pwd`
        open coverage/index.html
    fi
}

if ! [ -d .git ]; then printf "\nError: not in root of repo"; show_help; fi

case $1 in
    --help)
        show_help
        ;;
    --report)
        if ! [ -z ${2+x} ]; then
            printf "\nError: no extra parameters required: $2"
            show_help
        fi
        runReport
        ;;
    *)
        currentDir=`pwd`
        # if no parameter passed
        if [ -z $1 ]; then
            rm -f lcov.info
            dirs=(`find . -maxdepth 2 -type d`)
            for dir in "${dirs[@]}"; do
                runTests $dir $currentDir
            done
        else
            if [[ -d "$1" ]]; then
                runTests $1 $currentDir
            else
                printf "\nError: not a directory: $1"
                show_help
            fi
        fi
        ;;
esac

#Fail the build if there was an error
if [ "$error" = true ] ;
then
    exit -1
fi