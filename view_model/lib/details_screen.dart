import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';
import 'package:todos_repository_core/todos_repository_core.dart';
import 'package:view_model/view_model.dart';

import 'edit_todo_screen.dart';
import 'todo.dart';
import 'todo_list_state.dart';
import 'todo_list_view_model.dart';

class DetailsScreen extends StatefulWidget {
  final void Function(Todo todo) onRemove;
  final TodosRepository repository;
  final String todoId;

  const DetailsScreen({
    required this.onRemove,
    required this.repository,
    required this.todoId,
  }) : super(key: ArchSampleKeys.todoDetailsScreen);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen>
    with ViewModelStateMixin<DetailsScreen> {
  TodoListViewModel get todoListViewModel =>
      viewModelBinding.read(todoListViewModelSpec(widget.repository));

  @override
  Widget build(BuildContext context) {
    return StateViewModelSelector<TodoListState, Todo?>(
      viewModel: todoListViewModel,
      selector: (state) => state.todoById(widget.todoId),
      builder: (context, todo) {
        if (todo == null) return const SizedBox.shrink();

        return Scaffold(
          appBar: AppBar(
            title: Text(ArchSampleLocalizations.of(context).todoDetails),
            actions: [
              IconButton(
                key: ArchSampleKeys.deleteTodoButton,
                tooltip: ArchSampleLocalizations.of(context).deleteTodo,
                icon: const Icon(Icons.delete),
                onPressed: () => widget.onRemove(todo),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            key: ArchSampleKeys.editTodoFab,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => EditTodoScreen(
                    todoId: todo.id,
                    repository: widget.repository,
                    onEdit: () => Navigator.pop(context),
                  ),
                ),
              );
            },
            child: const Icon(Icons.edit),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Checkbox(
                        key: ArchSampleKeys.detailsTodoItemCheckbox,
                        value: todo.complete,
                        onChanged: (complete) {
                          unawaited(
                            todoListViewModel.setTodoComplete(
                              todo.id,
                              complete ?? false,
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 16),
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
        );
      },
    );
  }
}
