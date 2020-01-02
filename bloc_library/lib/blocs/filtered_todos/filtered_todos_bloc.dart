// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:bloc_library/blocs/filtered_todos/filtered_todos.dart';
import 'package:bloc_library/blocs/todos/todos.dart';
import 'package:bloc_library/models/models.dart';

class FilteredTodosBloc extends Bloc<FilteredTodosEvent, FilteredTodosState> {
  final TodosBloc todosBloc;
  StreamSubscription todosSubscription;

  FilteredTodosBloc({@required this.todosBloc}) {
    todosSubscription = todosBloc.listen((state) {
      if (state is TodosLoaded) {
        add(UpdateTodos(state.todos));
      }
    });
  }

  @override
  FilteredTodosState get initialState {
    return todosBloc.state is TodosLoaded
        ? FilteredTodosLoaded(
            (todosBloc.state as TodosLoaded).todos,
            VisibilityFilter.all,
          )
        : FilteredTodosLoading();
  }

  @override
  Stream<FilteredTodosState> mapEventToState(FilteredTodosEvent event) async* {
    if (event is UpdateFilter) {
      yield* _mapUpdateFilterToState(event);
    } else if (event is UpdateTodos) {
      yield* _mapTodosUpdatedToState(event);
    }
  }

  Stream<FilteredTodosState> _mapUpdateFilterToState(
    UpdateFilter event,
  ) async* {
    if (todosBloc.state is TodosLoaded) {
      yield FilteredTodosLoaded(
        _mapTodosToFilteredTodos(
          (todosBloc.state as TodosLoaded).todos,
          event.filter,
        ),
        event.filter,
      );
    }
  }

  Stream<FilteredTodosState> _mapTodosUpdatedToState(
    UpdateTodos event,
  ) async* {
    final visibilityFilter = state is FilteredTodosLoaded
        ? (state as FilteredTodosLoaded).activeFilter
        : VisibilityFilter.all;
    yield FilteredTodosLoaded(
      _mapTodosToFilteredTodos(
        (todosBloc.state as TodosLoaded).todos,
        visibilityFilter,
      ),
      visibilityFilter,
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
    todosSubscription?.cancel();
    return super.close();
  }
}
