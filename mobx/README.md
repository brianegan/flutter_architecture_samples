# mobx

TodoMVC built using MobX and Flutter

## What is MobX?

![mobx_logo](https://github.com/mobxjs/mobx.dart/raw/master/docs/src/images/mobx.png)

[MobX](https://mobx.pub) is a popular state management library for Dart and Flutter apps. It has also been recognized as a [Flutter Favorite package](https://flutter.dev/docs/development/packages-and-plugins/favorites).

MobX relies on 3 core concepts: **`Observables`**, **`Actions`** and **`Reactions`**. `Observables` represent the reactive state of your application. `Actions` are semantic operations that modify these observables and `Reactions` are the listeners that _"react"_ to the change in `Observables`, by updating UI or firing network operations. `Reactions` are considered as the side-effects in a MobX-based application.

You can learn more about these with the handy guides on [mobx.pub](https://mobx.pub).

## Code Structure

The code has been split into the `TodoStore` class (in `/stores`) that manages the list of todos, the reactive `Todo` model (in `/models`), and the Flutter Widgets found in the root, or nested in folders if the screen is more complex (such as the home screen). MobX relies on code-generation (provided by [![mobx_codegen pub package](https://img.shields.io/pub/v/mobx_codegen.svg?label=mobx_codegen&color=blue)](https://pub.dartlang.org/packages/mobx_codegen)) to keep your store classes clean and simple. This means you have to run the `build_runner` command to generate some code. The generated code is also checked in, so you don't have to do this by default. However, if you make any changes to the store classes, make sure to run:

```shell
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Connecting stores to the UI

To give a visible representation to the Store, we need the `Observer` widgets, part of the [![flutter_mobx pub package](https://img.shields.io/pub/v/flutter_mobx.svg?label=flutter_mobx&color=blue)](https://pub.dartlang.org/packages/flutter_mobx) package.

You will see that `Observers` can be sprinkled freely inside your Flutter Widget tree. Use them just at the places where you need the UI to update based on changes in Store. In case of TodoMVC, you will see their usage inside the list-view (and each item), add/edit todo pages and detail page. The `Observer` widget automatically listens to Observables that are references inside the provided `builder` function -- freely use what you need and rebuilds are kept to a minimum for only those observed values.
