import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_library/blocs/todos/todos.dart';
import 'package:bloc_library/models/models.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  final TodosRepository todosRepository;

  TodosBloc({required this.todosRepository}) : super(const TodosLoading()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<UpdateTodo>(_onUpdateTodo);
    on<DeleteTodo>(_onDeleteTodo);
    on<ToggleAll>(_onToggleAll);
    on<ClearCompleted>(_onClearCompleted);
  }

  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodosState> emit) async {
    try {
      final todos = await todosRepository.loadTodos();
      emit(TodosLoaded(todos.map(Todo.fromEntity).toList()));
    } catch (_) {
      emit(TodosNotLoaded());
    }
  }

  Future<void> _onAddTodo(AddTodo event, Emitter<TodosState> emit) async {
    if (state is TodosLoaded) {
      final updatedTodos = List<Todo>.from((state as TodosLoaded).todos)
        ..add(event.todo);
      emit(TodosLoaded(updatedTodos));
      await _saveTodos(updatedTodos);
    }
  }

  Future<void> _onUpdateTodo(UpdateTodo event, Emitter<TodosState> emit) async {
    if (state is TodosLoaded) {
      final updatedTodos = (state as TodosLoaded).todos.map((todo) {
        return todo.id == event.updatedTodo.id ? event.updatedTodo : todo;
      }).toList();
      emit(TodosLoaded(updatedTodos));
      await _saveTodos(updatedTodos);
    }
  }

  Future<void> _onDeleteTodo(DeleteTodo event, Emitter<TodosState> emit) async {
    if (state is TodosLoaded) {
      final updatedTodos = (state as TodosLoaded).todos
          .where((todo) => todo.id != event.todo.id)
          .toList();
      emit(TodosLoaded(updatedTodos));
      await _saveTodos(updatedTodos);
    }
  }

  Future<void> _onToggleAll(ToggleAll event, Emitter<TodosState> emit) async {
    if (state is TodosLoaded) {
      final allComplete = (state as TodosLoaded).todos.every(
        (todo) => todo.complete,
      );
      final updatedTodos = (state as TodosLoaded).todos
          .map((todo) => todo.copyWith(complete: !allComplete))
          .toList();
      emit(TodosLoaded(updatedTodos));
      await _saveTodos(updatedTodos);
    }
  }

  Future<void> _onClearCompleted(
    ClearCompleted event,
    Emitter<TodosState> emit,
  ) async {
    if (state is TodosLoaded) {
      final updatedTodos = (state as TodosLoaded).todos
          .where((todo) => !todo.complete)
          .toList();
      emit(TodosLoaded(updatedTodos));
      await _saveTodos(updatedTodos);
    }
  }

  Future<void> _saveTodos(List<Todo> todos) {
    return todosRepository.saveTodos(
      todos.map((todo) => todo.toEntity()).toList(),
    );
  }
}
