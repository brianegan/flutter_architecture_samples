# built_redux

An example Todo app created with [built_value](https://pub.dartlang.org/packages/built_value), [built_redux](https://pub.dartlang.org/packages/built_redux), and [flutter_built_redux](https://pub.dartlang.org/packages/flutter_built_redux).

## Key Concepts

  * Most of the Key Concepts from the [Redux Example](../redux) apply to this example as well, but the implementations are slightly different.
  * To enforce immutability, `built_redux` apps require you to use a `built_value` Value Object.
  * To increase discoverability, all actions are created using `built_redux` and attached to the `Store`.
  * To use `built_value` and `built_redux`, you must add a `build.yaml` file to your project.
  * To help with Type Safety, Reducers and Middleware can be created with `ReducerBuilder` and `MiddlewareBuilder` classes.
  
## Enforcing Immutability

The `State` objects in your app need to be created with `built_value`. `built_value` is a library that generate "Value Classes" from a Class template that you write.

The Value classes can not be directly modified, but instead must be updated by creating a new version of the object.

## Actions Discoverability

One benefit of `built_redux` is that it attaches all possible actions to your store. This makes it very easy to see which actions are available for dispatch within your IDE using autocompletion.

## Build.yaml

In order to use `built_redux` and `built_value`, you need to create a `build.yaml` file in your project. Whenever you update your Value Classes or Redux Actions you'll need to run the build command: `flutter pub pub run build_runner build`. Instead of running the `build` command, you can run the `watch` command: `flutter pub pub run build_runner watch`. This will watch for changes and trigger a rebuild every time you make updates. This tends to be much faster overall.

## Type Safety in Reducers and Middleware

As your app grows, you'll want to break reducers and middleware down into smaller functions.

## Differences to Redux

These two libraries are incredibly similar. These are the minor differences:

  * Actions
    - `built_redux` - Actions are generated for you by `built_redux` based on a definition. They are then attached to the Store upon creation. Each action has a unique name and a generic payload type. Each action can have at most one reducer.
    - `Redux`, Actions are plain ol' Dart values, Classes or Enums.
  * Reducers
    - `built_redux` - Reducers are void functions that mutate a `StateBuilder`. The `StateBuilder` is then built after all reducers have run. Enforces immutability.
    - `redux` - Reducers are functions in app state and latest action and return a new app state. Since immutability is not enforced, a user could simply mutate the state object instead of returning an updated copy.
    - Both - Testing is easy, and both libraries have utilities for binding Reducers to Actions of a specific type. 
  * Middleware
    - Very little difference here. Both libraries have utilities for binding actions of a specific type to a given Middleware.
  * Nesting Large State Trees
    - `built_redux` - Provides helpers for composing large Action trees that you can attach to your Store upon creation. Reducers can be combined via functional composition and by using utilities from the library.
    - `redux` - No need for nesting actions, nesting reducers can be done via functional composition and by using utilities from the library.
    - Both - allow you to break down your app into smaller units.
  * Flutter integration
    - `built_redux` - Maps from a `State` to `Prop`, which is passed to your `build` method along with your `Actions`. You combine the `Prop` wih the actions in the `build` method.
    - `redux` - Maps from a `Store` to a `ViewModel`. The `ViewModel` should include both "Props" and callback functions that dispatch actions.
    - Both - Store a Widget at the top of your tree containing your State. 
