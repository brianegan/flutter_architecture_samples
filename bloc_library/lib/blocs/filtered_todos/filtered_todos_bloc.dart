import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_library/blocs/filtered_todos/filtered_todos.dart';
import 'package:bloc_library/blocs/todos/todos.dart';
import 'package:bloc_library/models/models.dart';

class FilteredTodosBloc extends Bloc<FilteredTodosEvent, FilteredTodosState> {
  final TodosBloc todosBloc;
  late final StreamSubscription<TodosState> todosSubscription;

  FilteredTodosBloc({required this.todosBloc})
    : super(
        todosBloc.state is TodosLoaded
            ? FilteredTodosLoaded(
                (todosBloc.state as TodosLoaded).todos,
                VisibilityFilter.all,
              )
            : FilteredTodosLoading(),
      ) {
    todosSubscription = todosBloc.stream.listen((state) {
      if (state is TodosLoaded) {
        add(UpdateTodos(state.todos));
      }
    });

    on<UpdateFilter>(_onUpdateFilter);
    on<UpdateTodos>(_onUpdateTodos);
  }

  void _onUpdateFilter(UpdateFilter event, Emitter<FilteredTodosState> emit) {
    if (todosBloc.state is TodosLoaded) {
      emit(
        FilteredTodosLoaded(
          _mapTodosToFilteredTodos(
            (todosBloc.state as TodosLoaded).todos,
            event.filter,
          ),
          event.filter,
        ),
      );
    }
  }

  void _onUpdateTodos(UpdateTodos event, Emitter<FilteredTodosState> emit) {
    final visibilityFilter = state is FilteredTodosLoaded
        ? (state as FilteredTodosLoaded).activeFilter
        : VisibilityFilter.all;

    emit(
      FilteredTodosLoaded(
        _mapTodosToFilteredTodos(
          (todosBloc.state as TodosLoaded).todos,
          visibilityFilter,
        ),
        visibilityFilter,
      ),
    );
  }

  List<Todo> _mapTodosToFilteredTodos(
    List<Todo> todos,
    VisibilityFilter filter,
  ) {
    return todos.where((todo) {
      if (filter == VisibilityFilter.all) {
        return true;
      } else if (filter == VisibilityFilter.active) {
        return !todo.complete;
      } else {
        return todo.complete;
      }
    }).toList();
  }

  @override
  Future<void> close() {
    todosSubscription.cancel();
    return super.close();
  }
}
