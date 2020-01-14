# flutter_architecture_samples

[![Build Status](https://travis-ci.org/brianegan/flutter_architecture_samples.svg?branch=master)](https://travis-ci.org/brianegan/flutter_architecture_samples)
[![Build Status](https://api.cirrus-ci.com/github/brianegan/flutter_architecture_samples.svg)](https://cirrus-ci.com/github/brianegan/flutter_architecture_samples)
[![codecov](https://codecov.io/gh/brianegan/flutter_architecture_samples/branch/master/graph/badge.svg)](https://codecov.io/gh/brianegan/flutter_architecture_samples)

<img align="right" src="assets/todo-list.png" alt="List of Todos Screen">

[TodoMVC](http://todomvc.com) for Flutter!

Flutter provides a lot of flexibility in deciding how to organize and architect
your apps. While this freedom is very valuable, it can also lead to apps with
large classes, inconsistent naming schemes, as well as mismatching or missing
architectures. These types of issues can make testing, maintaining and extending
your apps difficult.

The Flutter Architecture Samples project demonstrates strategies to help solve
or avoid these common problems. This project implements the same app using
different architectural concepts and tools.

You can use the samples in this project as a learning reference, or as a
starting point for creating your own apps. The focus of this project is on
demonstrating how to structure your code, design your architecture, and the
eventual impact of adopting these patterns on testing and maintaining your app.
You can use the techniques demonstrated here in many different ways to build
apps. Your own particular priorities will impact how you implement the concepts
in these projects, so you should not consider these samples to be canonical
examples. To ensure the focus is kept on the aims described above, the app uses
a simple UI.

### Current Samples

- [Vanilla Lifting State Up Example](vanilla) ([Web Demo](https://fas_vanilla.codemagic.app)) - Uses the tools Flutter provides out of the box to manage app state.
- [InheritedWidget Example](inherited_widget) ([Web Demo](https://fas_inherited_widget.codemagic.app)) - Uses an InheritedWidget to pass app state down the widget hierarchy.
- [Change Notifier + Provider Example](change_notifier_provider) ([Web Demo](https://fas_change_notifier_provider.codemagic.app)) - Uses the [ChangeNotifier](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html) class from Flutter with [provider](https://pub.dev/packages/provider) package now recommended by the Flutter team.
- [BLoC Example](bloc_flutter) ([Web Demo](https://fas_bloc_flutter.codemagic.app)) - An implementation of the BLoC pattern, which uses Sinks for Inputs and Streams for Outputs
- [Bloc Library Example](bloc_library) ([Web Demo](https://fas_bloc_library.codemagic.app)) - Uses the [bloc](https://pub.dartlang.org/packages/bloc) and [flutter_bloc](https://pub.dartlang.org/packages/flutter_bloc) libraries to manage app state and update Widgets.
- [MobX Example](mobx) ([Web Demo](https://fas_mobx.codemagic.app)) - Uses the [MobX](https://pub.dev/packages/mobx) library to manage app state and update widgets using `Observables`, `Actions` and `Reactions`.
- [Redux Example](redux) ([Web Demo](https://fas_redux.codemagic.app)) - Uses the [Redux](https://pub.dartlang.org/packages/redux) library to manage app state and update Widgets
- ["Simple" BLoC Example](simple_bloc_flutter) ([Web Demo](https://fas_simple_bloc.codemagic.app)) - Similar to the BLoC pattern, but uses Functions for Inputs and Streams for Outputs. Results in far less code compared to standard BLoC.
- [MVI Example](mvi_flutter) ([Web Demo](https://fas_mvi.codemagic.app)) - Uses the concepts from Cycle.JS and applies them to Flutter.
- [states_rebuilder Example](states_rebuilder) ([Web Demo](https://fas_states_rebuilder.codemagic.app)) - Uses the [states_rebuilder](https://pub.dev/packages/states_rebuilder) library to manage app state and update Widgets.
- [built_redux Example](built_redux) - Uses the [built_redux](https://pub.dartlang.org/packages/built_redux) library to enforce immutability and manage app state
- [scoped_model Example](scoped_model) - Uses the [scoped_model](https://pub.dartlang.org/packages/scoped_model) library to hold app state and notify Widgets of Updates
- [Firestore Redux Example](firestore_redux) - Uses the [Redux](https://pub.dartlang.org/packages/redux) library to manage app state and update Widgets and
  adds [Cloud_Firestore](https://firebase.google.com/docs/firestore/) as the Todos database.
- [MVU Example](mvu) - Uses the [dartea](https://pub.dartlang.org/packages/dartea) library to manage app state and update Widgets.
- [MVC Example](mvc) - Uses the [MVC](https://pub.dartlang.org/packages/mvc_pattern) library to implement the traditional MVC design pattern.
- [Frideos Example](frideos_library) - Uses the [Frideos](https://pub.dartlang.org/packages/frideos) library to manage app state and update widgets using streams.

### Supporting Code

- [integration_tests](integration_tests) - Demonstrates how to write
selenium-style integration (aka end to end) tests using the Page Object Model.
This test suite is run against all samples.
- [todos_repository_core](todos_repository_core) - Defines the core abstract
classes for loading and saving data so that storage can be implemented in
various ways, such as file storage or firebase for mobile projects, or
window.localStorage for web projects.
- [todos_repository_local_storage](todos_repository_local_storage) - Implements
the todos repository using the file system, window.localStorage, and
SharedPreferences as the data source.
- [firebase_flutter_repository](firebase_flutter_repository) - Implements 
the todos repository using firestore as the data source.
- [firebase_rtdb_flutter_repository](firebase_rtdb_flutter_repository) -
Implements the todos repository using firebase real-time database as the data
source.

### Running the samples

#### iOS / Android

```
cd <sample_directory>
flutter run 
```

#### Web

Make sure you're on Flutter version "Flutter 1.12.13+hotfix.6 • channel beta" or
newer. Not all samples support web at this time, so please check the sample
directory for a `lib/main_web.dart` file.

```
cd <sample_directory>
flutter run -d chrome -t lib/main_web.dart
```

### Why a todo app?

The app in this project aims to be simple enough that you can understand it
quickly, but complex enough to showcase difficult design decisions and testing
scenarios. For more information, see the [app's specification](app_spec.md).

### Be excellent to each other

This Repo is meant as a discussion platform for various architectures. Let us
debate these ideas vigorously, but let us be excellent to each other in the
process!

While healthy debate and contributions are very welcome, trolls are not. Read
the [code of conduct](code-of-conduct.md) for detailed information.

### Contributing

Feel free to join in the discussion, file issues, and we'd love to have more
samples added! Please read the [CONTRIBUTING](CONTRIBUTING.md) file for guidance
:)

### License

All code in this repo is MIT licensed.

## Attribution

All of these ideas and even some of the language are directly influenced by two
projects:

- [TodoMVC](http://todomvc.com) - A Todo App implemented in various JS frameworks
- [Android Architecture Blueprints](https://github.com/googlesamples/android-architecture) - A similar concept, but for Android! The UI and app spec was highly inspired by their example.

## Contributors

- [Brian Egan](https://github.com/brianegan)
- [Maurice McCabe](https://github.com/mmcc007)
- [David Marne](https://github.com/davidmarne)
- [Pascal Welsch](https://github.com/passsy)
- [Larry King](https://github.com/kinggolf)
- [Frank Harper](https://github.com/franklinharper)
- [Pavel Shilyagov](https://github.com/p69)
- [Leo Cavalcante](https://github.com/leocavalcante)
- [Greg Perry](https://github.com/AndriousSolutions)
- [Felix Angelov](https://github.com/felangel)
- [Francesco Mineo](https://github.com/frideosapps)
- [Pavan Podila](https://github.com/pavanpodila)
- [Kushagra Saxena](https://github.com/kush3107)
- [Shakib Hossain](https://github.com/shakib609)
- [Mellati Fatah](https://github.com/GIfatahTH)

I'd like to thank all of the folks who have helped write new samples, improve
the current implementations, and added documentation! You're amazing! :)
