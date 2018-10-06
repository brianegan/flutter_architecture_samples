#!/usr/bin/env bash

# runs integration tests for a package that has a lib/main.dart
runDriver () {
  cd $1
  if [ -f "lib/main.dart" ]; then
#    if isVarSet $localOpt; then
#       runLocalOption $1
#    else
      echo "running driver in $1"
      # check if build_runner needs to be run
      # todo: fix build_runner in ./example/built_redux
      if grep build_runner pubspec.yaml > /dev/null  && [ "$1" != "./example/built_redux" ]; then
        flutter packages get
        flutter packages pub run build_runner build --delete-conflicting-outputs
      fi
      # todo: get input on MVU project to run with driver for screen input
#      if [ $uname == "Darwin" ]; then
        flutter driver test_driver/todo_app.dart
#      else
        # android emulator not available in travis so just build apk
#        flutter build apk
#      fi
    fi
#  fi
}

# options if running locally
runLocalOption () {
  echo "running $localOpt in $1"
  case $localOpt in
  "ios")
    flutter build ios
    ;;
  "apk")
    flutter build apk
    ;;
  "driver")
    flutter driver test_driver/todo_app.dart
    ;;
  *)
    echo "unknown local option $1"
    ;;
  esac
}

isVarSet() {
  ! [ -z ${1+x} ]
}

export -f runDriver
export -f runLocalOption
export -f isVarSet
export uname=`uname`

# pass 'ios', 'apk' or 'driver' from command line for local options
if isVarSet $1; then
  export localOpt=$1
fi

# expects to find most apps at second directory level
#find . -maxdepth 2 -type d -exec bash -c 'runDriver "$0"' {} \;
runDriver $1