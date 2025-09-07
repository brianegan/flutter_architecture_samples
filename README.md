# flutter_architecture_samples

[![Build Status](https://github.com/brianegan/flutter_architecture_samples/actions/workflows/analyze_test_build.yml/badge.svg?branch=main)](https://github.com/brianegan/flutter_architecture_samples/actions/workflows/analyze_test_build.ymll)
[![codecov](https://codecov.io/gh/brianegan/flutter_architecture_samples/branch/main/graph/badge.svg)](https://codecov.io/gh/brianegan/flutter_architecture_samples)

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

You can use the samples in this project as a learning reference, as a roughly
apples-to-apples comparison of different approaches, or as a starting point for
creating your own apps. The focus of this project is on demonstrating how to
structure your code, design your architecture, and the eventual impact of
adopting these patterns on testing and maintaining your app. You can use the
techniques demonstrated here in many different ways to build apps. Your own
particular priorities will impact how you implement the concepts in these
projects, so you should not consider these samples to be canonical examples. To
ensure the focus is kept on the aims described above, the app uses a simple UI.

### Current Samples

- [Vanilla Lifting State Up Example](vanilla) ([Web Demo](https://fas-vanilla.netlify.app)) - Uses the tools Flutter provides out of the box to manage app state.
- [InheritedWidget Example](inherited_widget) ([Web Demo](https://fas-inherited-widget.netlify.app)) - Uses an InheritedWidget to pass app state down the widget hierarchy.
- [Change Notifier + Provider Example](change_notifier_provider) ([Web Demo](https://fas-change-notifier-provider.netlify.app)) - Uses the [ChangeNotifier](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html) class from Flutter with [provider](https://pub.dev/packages/provider) package now recommended by the Flutter team.
- [Freezed + Provider + Value Notifier](freezed_provider_value_notifier) ([Web Demo](https://fas-freezed-provider-value-notifier.netlify.app)) - Uses the [ValueNotifier](https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html) class from Flutter with [provider](https://pub.dev/packages/provider) package.
- [BLoC Example](bloc_flutter) ([Web Demo](https://fas-bloc-flutter.netlify.app/)) - An implementation of the original [BLoC pattern](https://www.youtube.com/watch?v=PLHln7wHgPE&list=PLOU2XLYxmsIIJr3vjxggY7yGcGO7i9BK5&index=13) described by Paolo Soares at DartConf 2018, which uses Sinks for Inputs and Streams for Outputs
- [Bloc Library Example](bloc_library) ([Web Demo](https://fas-bloc-library.netlify.app)) - Uses the [bloc](https://pub.dartlang.org/packages/bloc) and [flutter_bloc](https://pub.dartlang.org/packages/flutter_bloc) libraries to manage app state and update Widgets.
- [MobX Example](mobx) ([Web Demo](https://fas-mobx.netlify.app)) - Uses the [MobX](https://pub.dev/packages/mobx) library to manage app state and update widgets using `Observables`, `Actions` and `Reactions`.
- [Redux Example](redux) ([Web Demo](https://fas-redux.netlify.app)) - Uses the [Redux](https://pub.dartlang.org/packages/redux) library to manage app state and update Widgets
- ["Simple" BLoC Example](simple_bloc_flutter) ([Web Demo](https://fas-simple-bloc.netlify.app/)) - Similar to the BLoC pattern, but uses Functions for Inputs and Streams for Outputs. Results in far less code compared to original BLoC pattern if code sharing with AngularDart apps isn't an important use case for your app.
- [Signals Example](signals) ([Web Demo](https://fas-signals.netlify.app)) - Uses the [Signals](https://pub.dev/packages/signals) package by [Rody Davis](https://pub.dev/publishers/rodydavis.com/packages).
- [MVI Example](mvi_flutter) ([Web Demo](https://fas-mvi.netlify.app)) - Uses the concepts from [Cycle.JS](https://cycle.js.org/) and applies them to Flutter.
- [scoped_model Example](scoped_model) ([Web Demo](https://fas-scoped-model.netlify.app)) - Uses the [scoped_model](https://pub.dartlang.org/packages/scoped_model) library to hold app state and notify Widgets of Updates

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

### Running the samples

```
cd <sample_directory>
flutter run 
```

### Why a todo app?

The app in this project aims to be as simple as possible while still showcasing
different design decisions and testing scenarios. For more information, see the
[app's specification](app_spec.md).

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
