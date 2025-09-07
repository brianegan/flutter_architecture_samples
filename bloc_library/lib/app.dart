import 'package:bloc_library/blocs/blocs.dart';
import 'package:bloc_library/localization.dart';
import 'package:bloc_library/models/models.dart';
import 'package:bloc_library/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos_app_core/todos_app_core.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

class TodosApp extends StatelessWidget {
  const TodosApp({super.key, required this.repository});

  final TodosRepository repository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TodosBloc>(
      create: (context) {
        return TodosBloc(todosRepository: repository)..add(LoadTodos());
      },
      child: MaterialApp(
        onGenerateTitle: (context) =>
            FlutterBlocLocalizations.of(context).appTitle,
        theme: ArchSampleTheme.lightTheme,
        darkTheme: ArchSampleTheme.darkTheme,
        localizationsDelegates: [
          ArchSampleLocalizationsDelegate(),
          FlutterBlocLocalizationsDelegate(),
        ],
        routes: {
          ArchSampleRoutes.home: (context) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<TabBloc>(create: (context) => TabBloc()),
                BlocProvider<FilteredTodosBloc>(
                  create: (context) => FilteredTodosBloc(
                    todosBloc: BlocProvider.of<TodosBloc>(context),
                  ),
                ),
                BlocProvider<StatsBloc>(
                  create: (context) =>
                      StatsBloc(todosBloc: BlocProvider.of<TodosBloc>(context)),
                ),
              ],
              child: HomeScreen(),
            );
          },
          ArchSampleRoutes.addTodo: (context) {
            return AddEditScreen(
              key: ArchSampleKeys.addTodoScreen,
              onSave: (task, note) {
                BlocProvider.of<TodosBloc>(
                  context,
                ).add(AddTodo(Todo(task, note: note)));
              },
              isEditing: false,
            );
          },
        },
      ),
    );
  }
}
