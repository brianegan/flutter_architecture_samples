#!/usr/bin/env bash

show_help() {
    printf "\n\nusage: $0 [--get] [--analyze] [--ios] [--apk] [--driver] [--clean] [<path to app package>]

Tool for managing CI builds.
(run from root of repo)

where:
    --get
        get all dependencies
    --analyze
        analyze dart code for all packages
    --ios
        build ios release for all apps
    --apk
        build android release for all apps
    --driver
        run integration tests for all apps
        (expects a single running emulator/simulator)
    --clean
        clean all builds
    <path to app package>
        run flutter driver for app at path
"
    exit 1
}

# run integration tests
runDriver () {
    cd $1
    if [ -f "lib/main.dart" ]; then
        echo "Running integration tests in $1..."
        flutter packages get
        flutter driver test_driver/todo_app.dart
    fi
    exitCode=$?
    cd - > /dev/null
    return $exitCode
}

# run function in all dirs
# expects a function name
allDirs() {
    dirs=(`find . -maxdepth 2 -type d`)
    for dir in "${dirs[@]}"; do
        $1 $dir
    done
}

runGet() {
    cd $1
    if [ -f "pubspec.yaml" ]; then
        flutter packages get
    fi
    cd - > /dev/null
}

runIos() {
    cd $1;
    if [ -f "lib/main.dart" ]; then
        flutter build ios
    fi
    cd - > /dev/null
}

runApk() {
    cd $1;
    if [ -f "lib/main.dart" ]; then
        echo "build apk in $1"
        flutter build apk
    fi
    cd - > /dev/null
}

runClean() {
    cd $1;
    if [ -f "pubspec.yaml" ]; then
        echo "run clean in $1"
        flutter clean > /dev/null
        rm -rf ios/Pods ios/Podfile.lock
        rm -rf android/.gradle
        rm -rf coverage
    fi
    cd - > /dev/null
}

# if no arguments passed
if [ -z $1 ]; then show_help; fi

if ! [ -d .git ]; then printf "\nError: not in root of repo"; show_help; fi

case $1 in
    --get)
        allDirs "runGet"
        ;;
    --analyze)
        flutter analyze
        ;;
    --ios)
        allDirs "runIos"
        ;;
    --apk)
        allDirs "runApk"
        ;;
    --driver)
        allDirs "runDriver"
        ;;
    --clean)
        allDirs "runClean"
        ;;
    *)
        if [[ -d "$1" ]]; then
            runDriver $1
        else
            printf "\nError: not a directory: $1"
            show_help
        fi
        ;;
esac
