# firestore redux sample

This repo started with [flutter_architecture_redux sample](https://github.com/brianegan/flutter_architecture_samples/blob/master/redux/README.md),
and added [Cloud_Firestore](https://firebase.google.com/docs/firestore/) as the backend database. Cloud Firestore
provides realtime connection between the database and authenticated devices, as well as automatic offline
persistence for Android and iOS. Firebase authentication is included for anonymous authentication of users.

## Set-up

The steps below were primarily developed from [MemeChat repo](https://github.com/efortuna/memechat/blob/master/README.md).
There is a very useful [video tutorial](https://www.youtube.com/watch?v=w2TcYP8qiRI) associated with the MemeChat
repo from 2017 Google I/O that covers some basics related to connecting to Firebase. Additionally, refer to
[Firebase for Flutter Codelab](https://codelabs.developers.google.com/codelabs/flutter-firebase/index.html?index=..%2F..%2Findex#0)
In the present case, Firestore is being used but set up is similar.

1) Set up a Firestore instance at [Firebase Console](https://console.firebase.google.com/).

2) Enable anonymous authentication by going to 'Authentication' in left hand menu, selecting
'Sign-in Method', and enabling Anonymous at the bottom of the page.

3) For Android:

    - Create an app within your Firebase instance for Android, with package name com.yourcompany.fireredux.
    In the Firebase console, in the settings of your Android app, add your SHA-1 key by clicking "Add Fingerprint".
    Run the following command to get your SHA-1 key:

    `keytool -exportcert -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore`
    - Follow instructions to download google-services.json, and place it into fire_redux/android/app/.
    - Set the defaultConfig.applicationID in `android/app/build.gradle` to match
    android_client_info.package_name in `google-services.json`, e.g. `com.yourcompany.fireredux`.
    This is the name of your Android app in Firebase.
    Package values must match between files `android/app/src/main/AndroidManifest.xml` and
    `android/app/src/main/java/yourcompany/redux/MainActivity.java`, e.g. `com.yourcompany.fireredux`.

    - To connect to Firestore be sure your project is using Gradle 4.1 and Android Studio Gradle plugin 3.0.1.
    If you are creating a new Flutter project, then this should already be set up properly.
    If not, then follow these
    [upgrades steps](https://github.com/flutter/flutter/wiki/Updating-Flutter-projects-to-Gradle-4.1-and-Android-Studio-Gradle-plugin-3.0.1).
    You will need to edit these files: `android/gradle/wrapper/gradle-wrapper.properties`,
    `android/build.gradle`, and `android/app/build.gradle`.

    - Add google-service plugin to `android/build.gradle` under buildscript.dependencies:

    `classpath 'com.google.gms:google-services:3.1.0'`.

    - Apply this plugin to `android/app/build.gradle` by adding this to the end of the file:

    `apply plugin: 'com.google.gms.google-services'`

    - Add the following to `android/build.gradle` under allprojects.repositories:

    `        maven {
                 url "https://jitpack.io"
             }`

4) For iOS:

    - Create an app within your Firebase instance for iOS, with package name com.yourcompany.fireredux.
    - Follow instructions to download GoogleService-Info.plist, and place it into fire_redux/ios/Runner.
    - Open fire_redux/ios/Runner/Info.plist. Locate the CFBundleURLSchemes key.
    The second item in the array value of this key is specific to the Firebase instance.
    Replace it with the value for REVERSED_CLIENT_ID from GoogleService-Info.plist. It will look like this:
        ```$xslt
            <key>CFBundleURLTypes</key>
            <array>
                <dict>
                    <key>CFBundleTypeRole</key>
                    <string>Editor</string>
                    <key>CFBundleURLSchemes</key>
                    <array>
                        <string>com.yourcompany.firereduxios</string>
                        <string>com.googleusercontent.apps.631911544122-jtjdk7lmrqoiup15hofsceegpfn0dhj6</string>
                    </array>
                </dict>
            </array>
        ```
    - To successfully run on iOS, it may be necessary to manually copy GoogleService-Info.plist
    to your Xcode project. After you attempt a run/build of your project on iOS open Xcode by
    clicking on fire_redux/ios/Runner.xcworkspace. When your project is open in Xcode, then copy
    GoogleService-Info.plist to Runner/Runner folder. Then your project should run on iOS.


## Summary of changes made to the original redux sample repo.

  1. Added `firebase_flutter_repository` to the `pubspec.yaml`, removed `todos_repository_simple`.
  2. Limit the responsibility of the Reducers since Firestore is the source of truth.
  3. Change the Middleware to work with a `UserRepository` for auth and `ReactiveTodosRepository` to listen for changes to the Todos and push updates to Firestore.
  4. Add Actions for Login and to Start Listening to Firestore. It's not needed in this app, but we could also add an action to stop listening to Firestore.

## Testing

For integration testing, we need to pass through a Mock `UserRepository` and Mock `ReactiveTodosRepository`.

  1. `flutter test` will run all unit tests.
    * `flutter test test/selectors_test.dart` for selectors unit testing.
    * `flutter test test/reducer_test.dart` for reducers unit testing.
    * `flutter test test/middleware_test.dart` for middleware unit testing.
  2. `flutter drive --target=test_driver/todo_app.dart` to run integrations test. Integrations tests are unchanged from the original redux repo.
