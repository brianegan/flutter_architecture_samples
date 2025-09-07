import 'package:bloc_library/bloc_library_keys.dart';
import 'package:bloc_library/blocs/todos/todos.dart';
import 'package:bloc_library/screens/screens.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos_app_core/todos_app_core.dart';

class DetailsScreen extends StatelessWidget {
  final String id;

  const DetailsScreen({
    super.key = ArchSampleKeys.todoDetailsScreen,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final todosBloc = BlocProvider.of<TodosBloc>(context);
    return BlocBuilder(
      bloc: todosBloc,
      builder: (BuildContext context, TodosState state) {
        final todo = (state as TodosLoaded).todos.firstWhereOrNull(
          (todo) => todo.id == id,
        );
        final localizations = ArchSampleLocalizations.of(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(localizations.todoDetails),
            actions: [
              IconButton(
                tooltip: localizations.deleteTodo,
                key: ArchSampleKeys.deleteTodoButton,
                icon: Icon(Icons.delete),
                onPressed: () {
                  todosBloc.add(DeleteTodo(todo!));
                  Navigator.pop(context, todo);
                },
              ),
            ],
          ),
          body: todo == null
              ? Container(key: BlocLibraryKeys.emptyDetailsContainer)
              : Padding(
                  padding: EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Checkbox(
                              key: BlocLibraryKeys.detailsScreenCheckBox,
                              value: todo.complete,
                              onChanged: (_) {
                                todosBloc.add(
                                  UpdateTodo(
                                    todo.copyWith(complete: !todo.complete),
                                  ),
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Hero(
                                  tag: '${todo.id}__heroTag',
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.only(
                                      top: 8.0,
                                      bottom: 16.0,
                                    ),
                                    child: Text(
                                      todo.task,
                                      key: ArchSampleKeys.detailsTodoItemTask,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.headlineSmall,
                                    ),
                                  ),
                                ),
                                Text(
                                  todo.note,
                                  key: ArchSampleKeys.detailsTodoItemNote,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
          floatingActionButton: FloatingActionButton(
            key: ArchSampleKeys.editTodoFab,
            tooltip: localizations.editTodo,
            onPressed: todo == null
                ? null
                : () {
                    Navigator.of(context).push<void>(
                      MaterialPageRoute(
                        builder: (context) {
                          return AddEditScreen(
                            key: ArchSampleKeys.editTodoScreen,
                            onSave: (task, note) {
                              todosBloc.add(
                                UpdateTodo(
                                  todo.copyWith(task: task, note: note),
                                ),
                              );
                            },
                            isEditing: true,
                            todo: todo,
                          );
                        },
                      ),
                    );
                  },
            child: Icon(Icons.edit),
          ),
        );
      },
    );
  }
}
