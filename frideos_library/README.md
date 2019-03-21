# frideos_library sample

An example Todo app created with the [frideos](https://pub.dartlang.org/packages/frideos) library. 

## Key Concepts

- This example aims to implement the BLoC pattern in a slightly different way, trying to reduce the amount of code and complexity of the original implementation, making it a little bit easier to adopt by beginners.
- A singleton instance of the `AppState` class implementing the `AppStateModel` interface, holds the state of the app, here is where the only two BLoCs `TodosBloc` and `StatsBloc` are instantiated. 
- The state of the app is provided to the widgets tree by the `AppStateProvider`, a StatefulWidget that uses an InheritedWidget to make possible for the widgets of the subtree to access the data.
- Instead of one BLoC per screen, in this sample a single BLoC, `TodosBloc`, contains the business logic of the screens that share similar needs (`HomeScreen`, `DetailScreen` and `AddEditScreen`).
- To send data from the `TodosBloc` to the `StatsBloc`, in order to calculate the number of active and completed todos, it is used the `send` method of the `ListSender` class. First, in the `TodosBloc` is created an instance of the `ListSender` class, then by its method `setReceiver`, in the `AppState` class is set a reference to the stream on the `StatsBloc` that will receive the todos list whenever the method `send` is called. In this case, there is no need for the two BLoCs to share the same source of data, or having to pass the `TodosBloc` as a parameter to the `StatsBloc` to get the todos list.

## UI and Streams

- As per the classic BLoC implementation, the widgets, most of which in this sample are Stateless, are automatically rebuilt whenever the streams emit a new event. 
- Every time a new value is set, the `ValueBuilder` widget, which takes as a parameter an object implementing the StreamedObject interface of the library, rebuilds providing the updated data. This is just a widget that extends the `StreamBuilder` and adds some callbacks to handle the stream state and return a `Container` if no widget is passed to the `NoDataChild` parameter, in order to avoid to check for the `snapshot.hasData` property to not return a null widget, ultimately, resulting in a less and cleaner code.

## Testing
There are no particular tricks for testing the app with this library. The sample was tested with unit tests that check for every feature of the apps, and by the integration test with flutter drive.