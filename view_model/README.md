# ViewModel Example

This sample implements the shared TodoMVC application with the
[`view_model`](https://pub.dev/packages/view_model) package.

## Architecture

- `TodoListViewModel` is a managed `StateViewModel<TodoListState>` that owns
  loading, filtering, statistics, editing, and persistence behavior.
- `todoListViewModelSpec` uses the injected `TodosRepository` as an explicit
  key. The same repository therefore resolves to one instance across bindings,
  while a different app or test repository remains isolated.
- `ViewModelApp` resolves the ViewModel through
  `ViewModelBinding.read(spec)`. It binds the lifecycle without rebuilding the
  entire `MaterialApp` for state changes.
- Stateful screens receive the repository dependency and resolve the shared
  ViewModel through their own `ViewModelBinding`; managed ViewModel instances
  are never passed between widgets.
- Screens use `StateViewModelSelector` to rebuild from immutable state changes,
  while presentation widgets receive only state values and callbacks.
- Unit tests resolve ViewModels through a test binding and dispose the binding
  after each test. The shared integration suite verifies the complete app flow.

## Run

```sh
flutter pub get
flutter run
```

## Test

```sh
flutter test --concurrency=1
flutter test integration_test/app_test.dart -d linux
```
