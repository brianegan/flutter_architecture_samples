import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inherited_widget_sample/app.dart';
import 'package:inherited_widget_sample/data/todos_service.dart';
import 'package:inherited_widget_sample/models.dart';

class StateContainerController extends StatefulWidget {
  final AppState state;
  final TodosService service;

  StateContainerController({
    this.service = const TodosService(),
    this.state,
  });

  @override
  State<StatefulWidget> createState() {
    return new StateContainerControllerState();
  }
}

class StateContainerControllerState extends State<StateContainerController> {
  AppState state;

  @override
  void initState() {
    if (widget.state != null) {
      state = widget.state;
    } else {
      state = new AppState.loading();
    }

    widget.service.loadTodos().then((loadedTodos) {
      setState(() {
        state = new AppState(todos: loadedTodos);
      });
    }).catchError((err) {
      setState(() {
        state.isLoading = false;
      });
    });

    super.initState();
  }

  void _toggleAll() {
    setState(() {
      state.toggleAll();
    });
  }

  void _clearCompleted() {
    setState(() {
      state.clearCompleted();
    });
  }

  void _addTodo(Todo todo) {
    setState(() {
      state.todos.add(todo);
    });
  }

  void _removeTodo(Todo todo) {
    setState(() {
      state.todos.remove(todo);
    });
  }

  void _updateFilter(VisibilityFilter filter) {
    setState(() {
      state.activeFilter = filter;
    });
  }

  void _updateTodo(
    Todo todo, {
    bool complete,
    String id,
    String note,
    String task,
  }) {
    setState(() {
      todo.complete = complete ?? todo.complete;
      todo.id = id ?? todo.id;
      todo.note = note ?? todo.note;
      todo.task = task ?? todo.task;
    });
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);

    widget.service.saveTodos(state.todos);
  }

  @override
  Widget build(BuildContext context) {
    return new StateContainer(
      state: state,
      updateTodo: _updateTodo,
      addTodo: _addTodo,
      removeTodo: _removeTodo,
      toggleAll: _toggleAll,
      clearCompleted: _clearCompleted,
      updateFilter: _updateFilter,
      child: new InheritedWidgetApp(),
    );
  }
}

class StateContainer extends InheritedWidget {
  final AppState state;
  final Function(Todo todo) addTodo;
  final Function(Todo todo) removeTodo;
  final TodoUpdater updateTodo;
  final Function() toggleAll;
  final Function() clearCompleted;
  final Function(VisibilityFilter) updateFilter;

  StateContainer({
    Key key,
    @required this.state,
    @required this.updateTodo,
    @required this.addTodo,
    @required this.removeTodo,
    @required this.toggleAll,
    @required this.clearCompleted,
    @required this.updateFilter,
    @required Widget child,
  })
      : super(key: key, child: child);

  static StateContainer of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(StateContainer);
  }

  @override
  bool updateShouldNotify(StateContainer old) => state != old.state;
}

typedef TodoUpdater(
  Todo todo, {
  bool complete,
  String id,
  String note,
  String task,
});
