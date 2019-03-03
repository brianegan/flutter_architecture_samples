import 'package:todos_repository_core/todos_repository_core.dart';

import 'package:frideos/frideos_dart.dart';

import 'package:frideos_library/models/models.dart';

class TodosBloc {
  final TodosRepository repository;

  TodosBloc({this.repository}) {
    print('-------TODOS BLOC INIT--------');
    _init();
  }

  _init() async {
    // Load the todos from the repository
    await loadTodos();

    // Listening for changes in the todos list, updated the streams and save
    // to the repository. It is the same as:
    //
    // todosItems.outStream.listen((todos) => onTodosChange(...)
    //
    todosItems.onChange((todos) => onTodosChange(
        allComplete, hasCompletedTodos, todos, onDataLoaded, todosSender));

    // Listening for changes in the VisibilityFilter and filter the visible
    // todos depending on the current filter.:
    activeFilter
        .onChange((filter) => onFilterChange(todosItems, visibleTodos, filter));
  }

  // When the data is loaded this function will save the todos, update the visible
  // todos, and send to the statsBloc the todos list.
  Function onDataLoaded;

  // STREAMS
  //
  final todosItems = StreamedList<Todo>();
  final visibleTodos = StreamedList<Todo>();
  final activeFilter =
      StreamedValue<VisibilityFilter>(initialData: VisibilityFilter.all);
  final currentTodo = StreamedValue<Todo>(initialData: Todo('Initializing'));
  final allComplete = StreamedValue<bool>(initialData: false);
  final hasCompletedTodos = StreamedValue<bool>(initialData: false);

  // SENDER (to send the todosItems list to the StatsBloc)
  //
  final todosSender = ListSender<Todo>();

  // METHODS
  //
  void loadTodos() async {
    var todos = await repository.loadTodos();
    todosItems.value = todos?.map(Todo.fromEntity).toList() ?? [];
    todosSender.send(todosItems.value);

    onDataLoaded = () {
      saveTodos();
      updateVisibleItems();
      todosSender.send(todosItems.value);
    };
  }

  void updateVisibleItems() =>
      visibleTodos.value = filterTodos(todosItems.value, activeFilter.value);

  void saveTodos() => repository
      .saveTodos(todosItems.value.map((item) => item.toEntity()).toList());

  void addTodo(Todo todo) => todosItems.addElement(todo);

  void updateTodo(Todo todo) {
    todosItems.replace(currentTodo.value, todo);
    currentTodo.value = todo;
  }

  void addedit(bool isEditing, String task, String note) {
    if (isEditing) {
      updateTodo(currentTodo.value.copyWith(task: task, note: note));
    } else {
      addTodo(Todo(
        task,
        note: note,
      ));
    }
  }

  void deleteTodo(Todo todo) => todosItems.removeElement(todo);

  void onCheckboxChanged(Todo todo) {
    var updatedTodo = todo.copyWith(complete: !todo.complete);
    todosItems?.replace(todo, updatedTodo);    
    currentTodo.value = updatedTodo;
  }

  void clearCompleted() {
    todosItems.value.removeWhere((todo) => todo.complete);

    /// Call the refresh method to update the stream when
    /// there is no implementation of the respective method
    /// on the StreamedList class, read the docs for details.
    todosItems.refresh();
  }

  void toggleAll() {
    var areAllComplete = todosItems.value.every((todo) => todo.complete);
    todosItems.value = todosItems.value
        .map((todo) => todo.copyWith(complete: !areAllComplete))
        .toList();
  }

  void extraAction(ExtraAction action) {
    if (action == ExtraAction.toggleAllComplete) {
      toggleAll();
    } else if (action == ExtraAction.clearCompleted) {
      clearCompleted();
    }
  }

  static onTodosChange(
      StreamedValue<bool> _allComplete,
      StreamedValue<bool> _hasCompletedTodos,
      List<Todo> todos,
      Function _dataLoaded,
      ListSender<Todo> _todosSender) {
    _allComplete.value = todos.every((todo) => todo.complete);
    _hasCompletedTodos.value = todos.any((todo) => todo.complete);

    // Saving items and updating visible items.
    _dataLoaded();

    //Sending the todos list to StatsBloc
    _todosSender.send(todos);
  }

  static onFilterChange(StreamedList<Todo> _todosItems,
      StreamedList<Todo> _visibleTodos, VisibilityFilter _filter) {
    if (_todosItems.value != null) {
      _visibleTodos.value = filterTodos(_todosItems.value, _filter);
    }
  }

  static List<Todo> filterTodos(List<Todo> todos, VisibilityFilter filter) {
    return todos.where((todo) {
      switch (filter) {
        case VisibilityFilter.all:
          return true;
        case VisibilityFilter.active:
          return !todo.complete;
        case VisibilityFilter.completed:
          return todo.complete;
      }
    }).toList();
  }

  /// To close all the streams
  void dispose() {
    print('-------TODOS BLOC DISPOSE--------');
    todosItems.dispose();
    currentTodo.dispose();
    activeFilter.dispose();
    allComplete.dispose();
    hasCompletedTodos.dispose();
    visibleTodos.dispose();
  }
}
