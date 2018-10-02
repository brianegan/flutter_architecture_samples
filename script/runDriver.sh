#!/usr/bin/env bash

# runs integration tests for a package that has a lib/main.dart
runDriver () {
  cd $1
  if [ -f "lib/main.dart" ]; then
    echo "running driver in $1"
    # check if build_runner needs to be run
    # todo: fix build_runner in ./example/built_redux
    if grep build_runner pubspec.yaml > /dev/null  && [ "$1" != "./example/built_redux" ]; then
      flutter packages get
      flutter packages pub run build_runner build --delete-conflicting-outputs
    fi
    flutter driver test_driver/todo_app.dart
  fi
}

export -f runDriver

# expects to find most packages at second directory level
# find . -maxdepth 2 -type d -exec bash -c 'runDriver "$0" "$device_id"' {} \;

runDriver "./example/redux" "$device_id"