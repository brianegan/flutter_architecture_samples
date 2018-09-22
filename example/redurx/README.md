# ReduRx

An example Todo app created with [built_value](https://pub.dartlang.org/packages/built_value), [redurx](https://pub.dartlang.org/packages/redurx), and [flutter_redurx](https://pub.dartlang.org/packages/flutter_redurx).

## Key Concepts

  * `built_value` is **not required** you're free to represent your State by other ways.
  * It is Redux-based, not a attempt to be a Redux port.
  * Unnecessary rebuilds are intolerable, that is why `where` is explicitly set by who knows about the State: you!
  * **Actions** holds it's own **reducers** and can be Asynchronous through **AsyncActions** 
  * **Middlewares** can act *before* and *after* Actions, note that for `AsyncActions` it calls `beforeAction` twice, one for before async execution and other for completed async execution, but before State rebuilding ([#3](https://github.com/leocavalcante/Flutter-ReduRx/issues/3))
  * **Connect** is composable as any other Widget, not some class you should extend.
  
## Dependency injection
  
You can use Middlewares to inject dependencies on Actions. A good call is to use [mixins](https://www.dartlang.org/articles/language/mixins) so you can type-safely call [setter injectors](https://en.wikipedia.org/wiki/Dependency_injection#Setter_injection_comparison). That is how we make `FetchTodos` action aware about `TodosRepository`.
  
## Differences to other implementations

It's a little layer above the [StreamBuilder](https://docs.flutter.io/flutter/widgets/StreamBuilder-class.html) using [RxDart](https://github.com/ReactiveX/rxdart), there's not much magic going on without your knowledge in Flutter vanilla. This is a biased comment since I am the author of this implementation, but I believe it is the most pragmatic way among the other solutions without any loss of performance or maintainability.

With a few lines of code you already have reactive components, all your State anytime you have a `BuildContext` and full control over when they should be update avoiding any unnecessary rebuild.

## Testing

There is no special treatment to test your Widgets, they are composed inside the `Connect` like it would be on any `WidgetBuilder`, but with it's sub-state instead of a `context`, this sub-state can be freely mocked as simple plain-old Dart code.
