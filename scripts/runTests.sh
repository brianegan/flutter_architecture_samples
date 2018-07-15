#!/usr/bin/env bash
runTests () {
  unameOut="$(uname -s)"
  case "${unameOut}" in
      Linux*)     machine=Linux;;
      Darwin*)    machine=Mac;;
      CYGWIN*)    machine=Cygwin;;
      MINGW*)     machine=MinGw;;
      *)          machine="UNKNOWN:${unameOut}"
  esac

  cd $1;
  if [ -f "pubspec.yaml" ] && [ -d "test" ]
  then
    echo "testing in $1"
    flutter test --coverage
    escapedPath="$(echo ${1:2} | sed 's/\//\\\//g')"
    if [ -d "coverage" ]
    then
      if [ ${machine} == "Mac" ]
      then
        sed -i '' "s/lib/$escapedPath\/lib/g" coverage/lcov.info
      else
        # for linux use
        sed -i "s/lib/$escapedPath\/lib/g" coverage/lcov.info
        fi
      cat coverage/lcov.info >> ../../lcov.info
    fi
  fi
}
export -f runTests
rm lcov.info
find . -maxdepth 2 -type d -exec bash -c 'runTests "$0"' {} \;
