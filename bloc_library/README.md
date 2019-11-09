# bloc_library sample

This sample makes use of the [bloc](https://pub.dev/packages/bloc), [flutter_bloc](https://pub.dev/packages/flutter_bloc), and [bloc_test](https://pub.dev/packages/bloc_test) libraries to manage state.

Check out the [bloc library documentation](https://bloclibrary.dev) for more details and tutorials.

## Key Concepts

- Lift State Up
  - If a bloc is needed by multiple widgets provide it using `BlocProvider` at the greatest common ancestor
- `Events` are the input to a bloc.
  - They are commonly added in response to user interactions such as button presses or lifecycle events like page loads.
- `States` are the output of a bloc and represent a part of your application's state.
  - components can be notified of states and redraw portions of themselves based on the current state.
- The change from one state to another is called a `Transition`.
  - A `Transition` consists of the current state, the event, and the next state.
- A bloc converts a `Stream` of incoming `Events` into a `Stream` of outgoing `States`

## Updating App State

Every bloc has an `add` method. `Add` takes an event and triggers `mapEventToState`. Add notifies the bloc of a new event which will then trigger a state change.

## Sharing Data between Blocs

In this implementation, the `FilteredTodosBloc` depends on the `TodosBloc` and will update the list of filtered todos in response to changes in the `TodosBloc`.
This approach demonstrates how we can build a reactive application by composing blocs from other blocs. On app start, the `TodosBloc` is hydrated with todos from the repository and from that moment forward, all mutations to todos are executed through the `TodosBloc` which persists the changes asynchronously. The `FilteredTodosBloc` listens for changes in the `TodosBloc` state and will update it's list of filtered todos. The result is, a hierarchy of states with all todos being managed by the `TodosBloc` and a subset of those todos (filtered todos) being managed by the `FilteredTodosBloc`.

## Updating UI

`BlocBuilder` is a Flutter widget which requires a bloc and a builder function. `BlocBuilder` handles building the widget in response to new states. `BlocBuilder` is very similar to `StreamBuilder` but has a simplified API to reduce the amount of boilerplate code needed and is also optimized to avoid unnecessary rebuilds.

## Testing

Generally, this app conforms the "Testing Pyramid": Lots of Unit tests, fewer Widget tests, and fewer integration tests.

- Unit tests
  - `Blocs` can easily be tested by mocking dependencies with `Mockito`. `Events` can be added and we can assert that the blocs' state has changed correctly.
- Widget Tests
  - Widgets can be tested by passing in fake data and making assertions against the Widget rendered with that data.
- Integration Tests
  - Run the app and drive it using flutter_driver `flutter drive --target test_driver/todo_app.dart`.
