# ReduRx

An example Todo app created with [built_value](https://pub.dartlang.org/packages/built_value), [redurx](https://pub.dartlang.org/packages/redurx), and [flutter_redurx](https://pub.dartlang.org/packages/flutter_redurx).

## Key Concepts

  * `built_value` is **not required** you're free to represent your State by other ways.
  * It is Redux-based, not a attempt to be a Redux port.
  * Unnecessary rebuilds are intolerable, that is why `where` is explicitly set by who knows about the State: you!
  * **Actions** holds it's own **reducers** and can be Asynchronous through **AsyncActions** 
  * **Middlewares** can act *before* and *after* Actions, note that for `AsyncActions` it calls `beforeAction` twice, one for before async execution and other for completed async execution, but before State rebuilding ([#3](https://github.com/leocavalcante/Flutter-ReduRx/issues/3))
  * **Connect** is composable as any other Widget, not some class you should extend.
  
Note: Redurx isn't a Redux implementation! It borrows some naming conventions, but you'll see a very distinct approach to Actions and Middlewares. For a Redux port on Dart, please visit: [flutter_redux](https://github.com/brianegan/flutter_architecture_samples/tree/master/example/redux).

## Testing

There is no special treatment to test your Widgets, they are composed inside the `Connect` like it would be on any `WidgetBuilder`, but with it's sub-state instead of a `context`, this sub-state can be freely mocked as simple plain-old Dart code.

## Differences to Redux

These two libraries are very similar since they're both based on ReduxJS. These are the differences:

  * Actions
    - `redurx` - Actions describe how the state should change
    - `Redux` - Actions are plain ol' Dart values, Classes or Enums. Could optionally create an Action type that describes how the state should change.
  * Reducers
    - `redurx` - No reducers! Handled inside the actions.
    - `redux` - A function that takes in the current app state and the latest action and return a new app state.
  * Async code / side effects
    - Use `AsyncActions` and `Middleware` to perform async work / side-effects
    - Use `Middleware`, `redux_epics`, or `redux_thunk` (very similar to `AsyncActions`)
  * Middleware
    - Slight API differences
    - Both allow you to listen for specific actions and perform work based on those actions
  * Flutter integration
    - Both 
        - Convert the latest state of the Store into a Widget
        - Allow you to filter which state changes result in a Widget rebuild
    - `flutter_redux` - currently offers a few additional utilities, such as `onInit`, `onDispose` and `onWillChange` callbacks for `StoreConverters`.
  * Dependency Injection
    - `redurx` - You can use Middlewares to inject dependencies on Actions. A good call is to use [mixins](https://www.dartlang.org/articles/language/mixins) so you can type-safely call [setter injectors](https://en.wikipedia.org/wiki/Dependency_injection#Setter_injection_comparison). That is how we make `FetchTodos` action aware about `TodosRepository`.
    - `redux` - Instantiate all Middleware with their dependencies when they're created