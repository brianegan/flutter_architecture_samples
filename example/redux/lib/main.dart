import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_sample/actions/actions.dart';
import 'package:redux_sample/containers/add_todo.dart';
import 'package:redux_sample/localization.dart';
import 'package:redux_sample/models/models.dart';
import 'package:redux_sample/reducers/app_state_reducer.dart';
import 'package:redux_sample/middleware/store_todos_middleware.dart';
import 'package:redux_sample/presentation/home_screen.dart';

void main() {
  runApp(new ReduxApp());
}

class ReduxApp extends StatelessWidget {
  final store = new Store<AppState>(
    appReducer,
    initialState: new AppState.loading(),
    middleware: createStoreTodosMiddleware(),
  );

  ReduxApp();

  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
      store: store,
      child: new MaterialApp(
        title: new ReduxLocalizations().appTitle,
        theme: ArchSampleTheme.theme,
        localizationsDelegates: [
          new ArchSampleLocalizationsDelegate(),
          new ReduxLocalizationsDelegate(),
        ],
        routes: {
          ArchSampleRoutes.home: (context) {
            return new StoreBuilder<AppState>(
              onInit: (store) => store.dispatch(new LoadTodosAction()),
              builder: (context, store) {
                return new HomeScreen();
              },
            );
          },
          ArchSampleRoutes.addTodo: (context) {
            return new AddTodo();
          },
        },
      ),
    );
  }
}
