import 'package:flutter/material.dart';
import 'package:simple_bloc_flutter_sample/dependency_injection.dart';
import 'package:simple_bloc_flutter_sample/screens/add_edit_screen.dart';
import 'package:simple_bloc_flutter_sample/widgets/loading.dart';
import 'package:simple_blocs/simple_blocs.dart';
import 'package:todos_app_core/todos_app_core.dart';

class DetailScreen extends StatefulWidget {
  final String todoId;

  const DetailScreen({required this.todoId})
    : super(key: ArchSampleKeys.todoDetailsScreen);

  @override
  DetailScreenState createState() {
    return DetailScreenState();
  }
}

class DetailScreenState extends State<DetailScreen> {
  late TodoBloc todoBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    todoBloc = TodoBloc(Injector.of(context).todosInteractor);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Todo>(
      stream: todoBloc.todo(widget.todoId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LoadingSpinner();

        final todo = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: Text(ArchSampleLocalizations.of(context).todoDetails),
            actions: [
              IconButton(
                key: ArchSampleKeys.deleteTodoButton,
                tooltip: ArchSampleLocalizations.of(context).deleteTodo,
                icon: Icon(Icons.delete),
                onPressed: () {
                  todoBloc.deleteTodo(todo.id);
                  Navigator.pop(context, todo);
                },
              ),
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
                        onChanged: (complete) {
                          todoBloc.updateTodo(
                            todo.copyWith(complete: !todo.complete),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
                            child: Text(
                              todo.task,
                              key: ArchSampleKeys.detailsTodoItemTask,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                          Text(
                            todo.note,
                            key: ArchSampleKeys.detailsTodoItemNote,
                            style: Theme.of(context).textTheme.titleMedium,
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
            tooltip: ArchSampleLocalizations.of(context).editTodo,
            key: ArchSampleKeys.editTodoFab,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) {
                    return AddEditScreen(
                      todo: todo,
                      updateTodo: todoBloc.updateTodo,
                      key: ArchSampleKeys.editTodoScreen,
                    );
                  },
                ),
              );
            },
            child: const Icon(Icons.edit),
          ),
        );
      },
    );
  }
}
