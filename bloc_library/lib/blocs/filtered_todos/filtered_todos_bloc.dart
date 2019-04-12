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
    todosSubscription = todosBloc.state.listen((state) {
      if (state is TodosLoaded) {
        dispatch(UpdateTodos((todosBloc.currentState as TodosLoaded).todos));
      }
    });
  }

  @override
  FilteredTodosState get initialState {
    return todosBloc.currentState is TodosLoaded
        ? FilteredTodosLoaded(
            (todosBloc.currentState as TodosLoaded).todos,
            VisibilityFilter.all,
          )
        : FilteredTodosLoading();
  }

  @override
  Stream<FilteredTodosState> mapEventToState(FilteredTodosEvent event) async* {
    if (event is UpdateFilter) {
      yield* _mapUpdateFilterToState(currentState, event);
    } else if (event is UpdateTodos) {
      yield* _mapTodosUpdatedToState(currentState, event);
    }
  }

  Stream<FilteredTodosState> _mapUpdateFilterToState(
    FilteredTodosState currentState,
    UpdateFilter event,
  ) async* {
    if (todosBloc.currentState is TodosLoaded) {
      yield FilteredTodosLoaded(
        _mapTodosToFilteredTodos(
          (todosBloc.currentState as TodosLoaded).todos,
          event.filter,
        ),
        event.filter,
      );
    }
  }

  Stream<FilteredTodosState> _mapTodosUpdatedToState(
    FilteredTodosState currentState,
    UpdateTodos event,
  ) async* {
    final visibilityFilter = currentState is FilteredTodosLoaded
        ? currentState.activeFilter
        : VisibilityFilter.all;
    yield FilteredTodosLoaded(
      _mapTodosToFilteredTodos(
        (todosBloc.currentState as TodosLoaded).todos,
        visibilityFilter,
      ),
      visibilityFilter,
    );
  }

  List<Todo> _mapTodosToFilteredTodos(
      List<Todo> todos, VisibilityFilter filter) {
    return todos.where((todo) {
      if (filter == VisibilityFilter.all) {
        return true;
      } else if (filter == VisibilityFilter.active) {
        return !todo.complete;
      } else if (filter == VisibilityFilter.completed) {
        return todo.complete;
      }
    }).toList();
  }

  @override
  void dispose() {
    todosSubscription.cancel();
    super.dispose();
  }
}
