#!/usr/bin/env bash

# generate an ios and android travis job for each app
projects=( bloc_flutter built_redux firestore_redux inherited_widget mvi_flutter mvu redurx redux scoped_model simple_bloc_flutter vanilla )

read -r -d '' header << EOM
env:
  global:
    - EMULATOR_API_LEVEL=22
    - ANDROID_ABI="default;armeabi-v7a"
matrix:
  # This causes the build to complete immediately upon failure or success
  # of all required jobs, allowing all non-required jobs to continue
  fast_finish: true

  # todo: MVU project currently fails on add/edit screen so MVU jobs are allowed to fail
  allow_failures:
    - env: MVU-ANDROID
    - env: MVU-IOS

  include:
    # Run unit tests without emulators.
    - env: UNIT-TEST
      os: linux
      language: generic
      sudo: false
      addons:
        apt:
          # Flutter depends on /usr/lib/x86_64-linux-gnu/libstdc++.so.6 version GLIBCXX_3.4.18
          sources:
            - ubuntu-toolchain-r-test # if we don't specify this, the libstdc++6 we get is the wrong version
          packages:
            - libstdc++6
            - fonts-droid
      before_script:
        - git clone https://github.com/flutter/flutter.git -b beta
        - export PATH="\$PATH":"\$HOME/.pub-cache/bin"
        - export PATH=\`pwd\`/flutter/bin:\`pwd\`/flutter/bin/cache/dart-sdk/bin:\$PATH
        - flutter precache
        - flutter doctor
        - pub global activate coverage
      script:
        - ./script/runTests.sh
      after_success:
        - bash <(curl -s https://codecov.io/bash) -f lcov.info
EOM

echo "$header"
echo

for project in "${projects[@]}"
do
    PROJECT=$(echo $project | awk '{print toupper($0)}')

	read -r -d '' androidTemplate << EOM
    # Run integration tests on android
    - env: $PROJECT-ANDROID
      os: linux
      language: android
      android:
        components:
          - tools
          - platform-tools
          - tools
          - build-tools-26.0.2
          - build-tools-26.0.3
          - build-tools-27.0.3
      sudo: false
      licenses:
          - 'android-sdk-license-.+'
      before_install:
        - sdkmanager --list
        - yes | sdkmanager "platforms;android-26" > /dev/null
        - yes | sdkmanager "platforms;android-27" > /dev/null
        # Install the rest of tools (e.g., avdmanager)
        - sdkmanager tools
        # Create and start emulator.
        - sdkmanager "system-images;android-\$EMULATOR_API_LEVEL;\$ANDROID_ABI" >/dev/null
        - sdkmanager --list
        - echo no | avdmanager create avd --force -n test -k "system-images;android-\$EMULATOR_API_LEVEL;\$ANDROID_ABI"
        - \$ANDROID_HOME/emulator/emulator -avd test -no-audio -no-window -gpu swiftshader &
      addons:
        apt:
          # Flutter depends on /usr/lib/x86_64-linux-gnu/libstdc++.so.6 version GLIBCXX_3.4.18
          sources:
            - ubuntu-toolchain-r-test # if we don't specify this, the libstdc++6 we get is the wrong version
          packages:
            - libstdc++6
            - fonts-droid
      before_script:
        # Wait for emulator to startup.
        - android-wait-for-emulator
        - adb shell input keyevent 82

        - git clone https://github.com/flutter/flutter.git -b beta
        - export PATH="\$PATH":"\$HOME/.pub-cache/bin"
        - export PATH=\`pwd\`/flutter/bin:\`pwd\`/flutter/bin/cache/dart-sdk/bin:\$PATH
        - flutter precache
        - flutter doctor -v
        - flutter devices
        - pub global activate coverage
      script:
        - travis_retry ./script/ci.sh ./example/$project
EOM
	echo "    $androidTemplate"
	echo
	read -r -d '' iosTemplate << EOM
    # Run integration tests on ios.
    - env: $PROJECT-IOS
      os: osx
      language: generic
      osx_image: xcode9.0
      before_script:
        - open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app
        - brew update
        - brew install libimobiledevice || echo 'ignore exit(1)'
        - brew install ideviceinstaller
        - brew install ios-deploy
        - brew install cocoapods || echo 'ignore exit(1)'
        - brew link --overwrite cocoapods
        - git clone https://github.com/flutter/flutter.git -b beta
        - export PATH="\$PATH":"\$HOME/.pub-cache/bin"
        - export PATH=\`pwd\`/flutter/bin:\`pwd\`/flutter/bin/cache/dart-sdk/bin:\$PATH
        - flutter precache
        - flutter doctor -v
        - flutter devices
      script:
        - travis_retry ./script/ci.sh ./example/$project
EOM
	echo "    $iosTemplate"
	echo
done

read -r -d '' footer << EOM
cache:
  directories:
    - \$HOME/.pub-cache
EOM

echo -n "$footer"
