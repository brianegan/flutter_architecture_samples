import 'package:flutter/material.dart';

import 'package:todos_app_core/todos_app_core.dart';

import 'package:frideos/frideos.dart';

import 'package:frideos_library/app_state.dart';
import 'package:frideos_library/models/models.dart';
import 'package:frideos_library/screens/add_edit_screen.dart';
import 'package:frideos_library/widgets/loading.dart';

class DetailScreen extends StatelessWidget {
  DetailScreen() : super(key: ArchSampleKeys.todoDetailsScreen);

  @override
  Widget build(BuildContext context) {
    final bloc = AppStateProvider.of<AppState>(context).todosBloc;

    return ValueBuilder<Todo>(
      streamed: bloc.currentTodo,
      noDataChild: LoadingSpinner(key: ArchSampleKeys.todosLoading),
      builder: (context, snapshot) {
        final todo = snapshot.data;

        return Scaffold(
          appBar: AppBar(
            title: Text(ArchSampleLocalizations.of(context).todoDetails),
            actions: [
              IconButton(
                key: ArchSampleKeys.deleteTodoButton,
                tooltip: ArchSampleLocalizations.of(context).deleteTodo,
                icon: Icon(Icons.delete),
                onPressed: () {
                  bloc.deleteTodo(todo);
                  Navigator.pop(context, todo);
                },
              )
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Checkbox(
                        value: todo.complete,
                        key: ArchSampleKeys.detailsTodoItemCheckbox,
                        onChanged: (_) => bloc.onCheckboxChanged(todo),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: 8.0,
                              bottom: 16.0,
                            ),
                            child: Text(
                              todo.task,
                              key: ArchSampleKeys.detailsTodoItemTask,
                              style: Theme.of(context).textTheme.headline,
                            ),
                          ),
                          Text(
                            todo.note,
                            key: ArchSampleKeys.detailsTodoItemNote,
                            style: Theme.of(context).textTheme.subhead,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            tooltip: ArchSampleLocalizations.of(context).editTodo,
            child: Icon(Icons.edit),
            key: ArchSampleKeys.editTodoFab,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    // Set the isEditing flag to true to push the page
                    // in 'editing mode'.
                    return AddEditScreen(
                      isEditing: true,
                      key: ArchSampleKeys.editTodoScreen,
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
