import 'package:flutter/material.dart';
import 'package:mvi_base/mvi_base.dart';
import 'package:mvi_flutter_sample/dependency_injection.dart';
import 'package:mvi_flutter_sample/localization.dart';
import 'package:mvi_flutter_sample/screens/add_edit_screen.dart';
import 'package:mvi_flutter_sample/screens/home_screen.dart';
import 'package:todos_app_core/todos_app_core.dart';

class MviApp extends StatelessWidget {
  final TodoListInteractor todoListInteractor;
  final UserInteractor userInteractor;

  const MviApp({
    super.key,
    required this.todoListInteractor,
    required this.userInteractor,
  });

  @override
  Widget build(BuildContext context) {
    return Injector(
      todosInteractor: todoListInteractor,
      userInteractor: userInteractor,
      child: MaterialApp(
        onGenerateTitle: (context) => BlocLocalizations.of(context).appTitle,
        theme: ArchSampleTheme.theme,
        localizationsDelegates: [
          ArchSampleLocalizationsDelegate(),
          InheritedWidgetLocalizationsDelegate(),
        ],
        routes: {
          ArchSampleRoutes.home: (context) {
            return HomeScreen();
          },
          ArchSampleRoutes.addTodo: (context) {
            return AddEditScreen(
              addTodo: Injector.of(context).todosInteractor.addNewTodo,
            );
          },
        },
      ),
    );
  }
}
