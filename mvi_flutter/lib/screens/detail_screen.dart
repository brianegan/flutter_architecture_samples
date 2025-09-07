import 'package:flutter/material.dart';
import 'package:mvi_base/mvi_base.dart';
import 'package:mvi_flutter_sample/dependency_injection.dart';
import 'package:mvi_flutter_sample/screens/add_edit_screen.dart';
import 'package:mvi_flutter_sample/widgets/loading.dart';
import 'package:todos_app_core/todos_app_core.dart';

class DetailScreen extends StatefulWidget {
  final String todoId;
  final MviPresenter<Todo> Function(DetailView)? initPresenter;

  const DetailScreen({
    super.key = ArchSampleKeys.todoDetailsScreen,
    required this.todoId,
    this.initPresenter,
  });

  @override
  DetailScreenState createState() {
    return DetailScreenState();
  }
}

class DetailScreenState extends State<DetailScreen> with DetailView {
  late final MviPresenter<Todo> presenter;

  @override
  void didChangeDependencies() {
    presenter = widget.initPresenter != null
        ? widget.initPresenter!(this)
        : DetailPresenter(
            id: widget.todoId,
            view: this,
            interactor: Injector.of(context).todosInteractor,
          );

    presenter.setUp();

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    tearDown();
    presenter.tearDown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Todo>(
      stream: presenter,
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
                  deleteTodo.add(todo.id);
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
                          updateTodo.add(
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
                      updateTodo: updateTodo.add,
                      key: ArchSampleKeys.editTodoScreen,
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
