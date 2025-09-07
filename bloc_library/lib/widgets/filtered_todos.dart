import 'package:bloc_library/bloc_library_keys.dart';
import 'package:bloc_library/blocs/blocs.dart';
import 'package:bloc_library/models/models.dart';
import 'package:bloc_library/screens/screens.dart';
import 'package:bloc_library/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos_app_core/todos_app_core.dart';

class FilteredTodos extends StatelessWidget {
  const FilteredTodos({super.key});

  @override
  Widget build(BuildContext context) {
    final todosBloc = BlocProvider.of<TodosBloc>(context);
    final localizations = ArchSampleLocalizations.of(context);

    return BlocBuilder<FilteredTodosBloc, FilteredTodosState>(
      builder: (BuildContext context, FilteredTodosState state) {
        if (state is FilteredTodosLoading) {
          return LoadingIndicator(key: ArchSampleKeys.todosLoading);
        } else if (state is FilteredTodosLoaded) {
          final todos = state.filteredTodos;
          return ListView.builder(
            key: ArchSampleKeys.todoList,
            itemCount: todos.length,
            itemBuilder: (BuildContext context, int index) {
              final todo = todos[index];
              return TodoItem(
                todo: todo,
                onDismissed: (_) {
                  todosBloc.add(DeleteTodo(todo));
                  ScaffoldMessenger.of(context).showSnackBar(
                    DeleteTodoSnackBar(
                      key: ArchSampleKeys.snackbar,
                      todo: todo,
                      onUndo: () => todosBloc.add(AddTodo(todo)),
                      localizations: localizations,
                    ),
                  );
                },
                onTap: () async {
                  final removedTodo = await Navigator.of(context).push<Todo>(
                    MaterialPageRoute(
                      builder: (_) {
                        return DetailsScreen(id: todo.id);
                      },
                    ),
                  );
                  if (removedTodo != null && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      DeleteTodoSnackBar(
                        key: ArchSampleKeys.snackbar,
                        todo: todo,
                        onUndo: () => todosBloc.add(AddTodo(todo)),
                        localizations: localizations,
                      ),
                    );
                  }
                },
                onCheckboxChanged: (_) {
                  todosBloc.add(
                    UpdateTodo(todo.copyWith(complete: !todo.complete)),
                  );
                },
              );
            },
          );
        } else {
          return Container(key: BlocLibraryKeys.filteredTodosEmptyContainer);
        }
      },
    );
  }
}
