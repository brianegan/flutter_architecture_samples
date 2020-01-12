# states_rebuilder_sample

This sample is an implementation of the todoMVC app using `states_rebuilder` package as a state management technique.

For more information and tutorials on how states_rebuilder work please check out the [official documentation](https://github.com/GIfatahTH/states_rebuilder).

# key concepts

* Business logic is written using Plain Old Dart Object without any need to extend, notify, annotate any thing.
* The app is divided into there layers : Domain, Service, and the outer layer for UI and external services which has three parts (UI, repository, and infrastructure).

The folders structure is :

lib - 
  |-domain
  |  |-entities
  |  |-exceptions
  |-service
  |      |-interfaces
  |      |-exceptions
  |      |-common
  |-repository
  |-ui
  |  |-pages
  |  |-exceptions
  |  |-common
 

## domain
Contains enterprise wide business logic. It encapsulates entities, value_objects, exceptions. In case of todoMVC we need one entity `Todo`.

>Entity is a mutable object with an ID. It should contain all the logic It controls. Entity is validated just before persistance, ie, in toMap() method.

**file:domain/entities/todo.dart**
```dart
class Todo {
  String id;
  bool complete;
  String note;
  String task;

  Todo(this.task, {String id, this.note, this.complete = false})
      : id = id ?? flutter_arch_sample_app.Uuid().generateV4();

  Todo.fromJson(Map<String, Object> map) {
    id = map['id'] as String;
    task = map['task'] as String;
    note = map['note'] as String;
    complete = map['complete'] as bool;
  }

  // toJson is called just before persistance.
  Map<String, Object> toJson() {
    // validation 
    _validation();
    return {
      'complete': complete,
      'task': task,
      'note': note,
      'id': id,
    };
  }

  void _validation() {
    if (id == null) {
      // Custom defined error classes
      throw ValidationException('This todo has no ID!');
    }
    if (task == null || task.isEmpty) {
      throw ValidationException('Empty task are not allowed');
    }
  }

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Todo && runtimeType == other.runtimeType && id == other.id;
}
```
>Domain objects must throw exceptions defined in the exception folders:

**file:domain/exceptions/validation_exception.dart**
```dart
class ValidationException extends Error {
  final String message;

  ValidationException(this.message);
}
```

## service
Contains service application use cases business logic. It defines a set of API to be consumed by the outer layer (UI and infrastructure).
> Service layer defines a set of interfaces, outer layer (repository and infrastructure) must implement.

**file:service/interfaces/i_todo_repository.dart**

```dart
abstract class ITodoRepository {
  /// Loads todos
  Future<List<Todo>> loadTodos();
  // Persists todos to local disk and the web
  Future saveTodos(List<Todo> todos);
}
```
>Service objects must throw exceptions defined in the exception folders:

**file:service/exceptions/validation_exception.dart**

```dart
class PersistanceException extends Error {
  final String message;

  PersistanceException(this.message);
}
```

>Service layer contains common and helper classes used inside it:

**file:service/common/enums.dart**

```dart
enum VisibilityFilter { all, active, completed }
```
NOTE that `AppTab` and `ExtraAction` are not used here. They will be declared in the UI layer.

>Service layer contains service classes that defined the application specific use cases. These class must obey to the single responsibility principle.

**file:service/todos_service.dart**

```dart
class TodosService {
  //Constructor injection of the ITodoRepository abstract class.
  TodosService(ITodoRepository todoRepository)
      : _todoRepository = todoRepository;
  
  //private fields
  final ITodoRepository _todoRepository;
  List<Todo> _todos = const [];
  List<Todo> get _completedTodos => _todos.where((t) => t.complete).toList();
  List<Todo> get _activeTodos => _todos.where((t) => !t.complete).toList();

  //public field
  VisibilityFilter activeFilter = VisibilityFilter.all;

  //getters 
  List<Todo> get todos {
    if (activeFilter == VisibilityFilter.active) {
      return _activeTodos;
    }
    if (activeFilter == VisibilityFilter.completed) {
      return _completedTodos;
    }
    return _todos;
  }
  int get numCompleted => _completedTodos.length;
  int get numActive => _activeTodos.length;
  bool get allComplete => _activeTodos.isEmpty;
  

  //methods for CRUD
  void loadTodos() async {
    _todos = await _todoRepository.loadTodos();
  }

  void addTodo(Todo todo) {
    _todos.add(todo);
    _todoRepository.saveTodos(_todos);
  }

  void updateTodo(Todo todo) {
    final index = _todos.indexOf(todo);
    if (index == -1) return;
    _todos[index] = todo;
    _todoRepository.saveTodos(_todos);
  }

  void deleteTodo(Todo todo) {
    if (_todos.remove(todo)) {
      _todoRepository.saveTodos(_todos);
    }
  }

  void toggleAll() {
    final allComplete = _todos.every((todo) => todo.complete);

    for (final todo in _todos) {
      todo.complete = !allComplete;
    }
    _todoRepository.saveTodos(_todos);
  }

  void clearCompleted() {
    _todos.removeWhere((todo) => todo.complete);
    _todoRepository.saveTodos(_todos);
  }
}
```
`TodosService` is a pure dart class that can be easily tested (see test folder).

>Domain and Service layer are the core portable part of your app. It does not depend on any concrete implementation of external service and can be share a cross many UI frameworks.

# Repository
**file:repository/todos_repository.dart**

The `TodosRepository` implements the  `ITodosRepository` and delegate to `LocalStorageRepository` for fetching todos and persisting them.
```dart
class TodosRepository implements ITodosRepository {
  final KeyValueStorage localStorage;

  TodosRepository({this.localStorage})
      : _localStorageRepository = LocalStorageRepository(
          localStorage: localStorage,
        );

  final LocalStorageRepository _localStorageRepository;
  
  @override
  Future<List<Todo>> loadTodos() async {
    try {
      final todoEntities = await _localStorageRepository.loadTodos();
      var todos = <Todo>[];
      for (var todoEntity in todoEntities) {
        todos.add(
          Todo.fromJson(todoEntity.toJson()),
        );
      }
      return todos;
    } catch (e) {
      throw PersistanceException('There is a problem in loading todos : $e');
    }
  }

  @override
  Future saveTodos(List<Todo> todos) {
    try {
      var todosEntities = <TodoEntity>[];
      for (var todo in todos) {
        todosEntities.add(TodoEntity.fromJson(todo.toJson()));
      }

      return _localStorageRepository.saveTodos(todosEntities);
    } catch (e) {
      throw PersistanceException('There is a problem in saving todos : $e');
    }
  }
}
```

## UI

**file:ui/main.dart**

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    StatesRebuilderApp(
      repository: TodosRepository(
          localStorage: KeyValueStorage(
        'states_rebuilder',
        FlutterKeyValueStore(await SharedPreferences.getInstance()),
      )),
    ),
  );
}
```
**file:ui/app.dart**

```dart

class StatesRebuilderApp extends StatelessWidget {
  final TodosRepository repository;

  const StatesRebuilderApp({Key key, this.repository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Injecting the TodoService globally before MaterialApp widget.
    //It will be available throughout all the widget tree even after navigation.
    return Injector(
      inject: [Inject(() => TodosService(repository))],
      builder: (_) => MaterialApp(
        title: StatesRebuilderLocalizations().appTitle,
        theme: ArchSampleTheme.theme,
        localizationsDelegates: [
          ArchSampleLocalizationsDelegate(),
          StatesRebuilderLocalizationsDelegate(),
        ],
        routes: {
          ArchSampleRoutes.home: (context) => HomeScreen(),
          ArchSampleRoutes.addTodo: (context) => AddEditPage(),
        },
      ),
    );
  }
}
```

**The home screen**
**file:ui/pages/home_screen/home_screen.dart**

```dart
class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key ?? ArchSampleKeys.homeScreen);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Here we use a StatefulWidget to store the _activeTab state which is is private to this class
  // In fact, with states_rebuilder, we refer to StatefulWidgets in two cases:
  // 1. To caches UI related state of a widget, ex: the state of Taps, Selector, Checkbox, DropdownButton , ...
  // 2. For local private variable only used inside the widget.
  AppTab _activeTab = AppTab.todos;
  @override
  Widget build(BuildContext context) {
    //Get the reactive model of TodosService and subscribe the HomeScreen to it using the context
    //In the context of Observable pattern: todoServiceRM is the observable and HomeScreen is the observer.
    //and setState is used for notification (see later)
    final todosServiceRM =
        Injector.getAsReactive<TodosService>(context: context);

    return Scaffold(
      appBar: AppBar(
        title: Text(StatesRebuilderLocalizations.of(context).appTitle),
        actions: [
          //see file:ui/pages/home_screen/filter_button.dart
          FilterButton(isActive: _activeTab == AppTab.todos),
          //see file:ui/pages/home_screen/extra_action_button.dart
          ExtraActionsButton(),
        ],
      ),
      
      body: StateBuilder<TodosService>(
        //Get reactive model of TodosService and subscribe this StateBuilder to it.
        models: [Injector.getAsReactive<TodosService>()],
        initState: (_, todosServiceRM) {
          //mutate the state by calling loadTodos and notify observers.
          return todosServiceRM.setState((s) => s.loadTodos());
        },
        builder: (_, todosServiceRM) {
          //TodoList : see file:ui/pages/home_screen/todo_list.dart
          //StatsCounter : see file:ui/pages/home_screen/stats_counter.dart
          return _activeTab == AppTab.todos ? TodoList() : StatsCounter();
        },
      ),
      floatingActionButton: FloatingActionButton(
        key: ArchSampleKeys.addTodoFab,
        onPressed: () {
          Navigator.pushNamed(context, ArchSampleRoutes.addTodo);
        },
        child: Icon(Icons.add),
        tooltip: ArchSampleLocalizations.of(context).addTodo,
      ),
      bottomNavigationBar: BottomNavigationBar(
        key: ArchSampleKeys.tabs,
        currentIndex: AppTab.values.indexOf(_activeTab),
        onTap: (index) {
          //For this particular case the only mutated variable is _activeTab which is local private to the widget
          //we can simply use setState of flutter:
          setState(() => _activeTab = AppTab.values[index]);
        },
        items: AppTab.values.map(
          (tab) {
            return BottomNavigationBarItem(
              icon: Icon(
                tab == AppTab.todos ? Icons.list : Icons.show_chart,
                key: tab == AppTab.stats
                    ? ArchSampleKeys.statsTab
                    : ArchSampleKeys.todoTab,
              ),
              title: Text(
                tab == AppTab.stats
                    ? ArchSampleLocalizations.of(context).stats
                    : ArchSampleLocalizations.of(context).todos,
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
```

**The home screen**
**file:ui/pages/home_screen/filter_button.dart**

```dart
class FilterButton extends StatelessWidget {
  FilterButton({this.isActive, Key key}) : super(key: key);
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    //get the reactive model of TodosService and subscribe this widget as observer.
    final todosServiceRM = Injector.getAsReactive<TodosService>(context: context);

    final defaultStyle = Theme.of(context).textTheme.body1;
    final activeStyle = Theme.of(context)
        .textTheme
        .body1
        .copyWith(color: Theme.of(context).accentColor);
    final button = _Button(
      onSelected: (filter) {
        //mutate the state of the activeFilter and notify observers 
        todosServiceRM.setState((s) => s.activeFilter = filter);
      },
      //get the value of activeFiler
      activeFilter: todosServiceRM.state.activeFilter,
      activeStyle: activeStyle,
      defaultStyle: defaultStyle,
    );

    return AnimatedOpacity(
      opacity: isActive ? 1.0 : 0.0,
      duration: Duration(milliseconds: 150),
      child: isActive ? button : IgnorePointer(child: button),
    );
  }
}
```
**The home screen**
**file:ui/pages/home_screen/extra_action_button.dart**

```dart
class ExtraActionsButton extends StatelessWidget {
  ExtraActionsButton({Key key}) : super(key: key);
  //get the reactive model of TodosService without subscription.
  final todosServiceRM = Injector.getAsReactive<TodosService>();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ExtraAction>(
      key: ArchSampleKeys.extraActionsButton,
      onSelected: (action) {
        if (action == ExtraAction.toggleAllComplete) {
          //mutate the state by calling toggleAll and notify observers (HomeScreen) 
          todosServiceRM.setState((s) => s.toggleAll());
        } else if (action == ExtraAction.clearCompleted) {
          //mutate the state by calling clearCompleted and notify observers (HomeScreen)
          todosServiceRM.setState((s) => s.clearCompleted());
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuItem<ExtraAction>>[
        PopupMenuItem<ExtraAction>(
          key: ArchSampleKeys.toggleAll,
          value: ExtraAction.toggleAllComplete,
          child: Text(todosServiceRM.state.allComplete
              ? ArchSampleLocalizations.of(context).markAllIncomplete
              : ArchSampleLocalizations.of(context).markAllComplete),
        ),
        PopupMenuItem<ExtraAction>(
          key: ArchSampleKeys.clearCompleted,
          value: ExtraAction.clearCompleted,
          child: Text(ArchSampleLocalizations.of(context).clearCompleted),
        ),
      ],
    );
  }
}
```
**The home screen**
**file:ui/pages/home_screen/todo_list.dart**

```dart
class TodoList extends StatelessWidget {
  TodoList() : super(key: ArchSampleKeys.todoList);
  //Get reactive model of TodosService without subscription.
  final todosServiceRM = Injector.getAsReactive<TodosService>();
  @override
  Widget build(BuildContext context) {
    //use of whenConnectionState to go through all the possible status of the state
    return todosServiceRM.whenConnectionState(
      onIdle: () => Container(),
      onWaiting: () => Center(
        child: CircularProgressIndicator(
          key: ArchSampleKeys.todosLoading,
        ),
      ),
      onData: (todosService) {
        return ListView.builder(
          key: ArchSampleKeys.todoList,
          itemCount: todosService.todos.length,
          itemBuilder: (BuildContext context, int index) {
            final todo = todosService.todos[index];
            return TodoItem(todo: todo);
          },
        );
      },
      onError: (error) {
        //delegate to the ErrorHandler.getErrorMessage to get the error message
        return Center(child: Text(ErrorHandler.getErrorMessage(error)));
      },
    );
  }
}
```

**The home screen**
**file:ui/pages/home_screen/todo_item.dart**

```dart
class TodoItem extends StatelessWidget {
  final Todo todo;

  TodoItem({
    Key key,
    @required this.todo,
  }) : super(key: key);
  
  //get the reactive model of TodosService without subscription.
  final todosServiceRM = Injector.getAsReactive<TodosService>();

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ArchSampleKeys.todoItem(todo.id),
      onDismissed: (direction) {
        //Delegate to HelperMethods.removeTodo to remove todo and show snackbar.
        HelperMethods.removeTodo(todo);
      },
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) {
                return DetailScreen(todo);
              },
            ),
          );
        },
        leading: Checkbox(
          key: ArchSampleKeys.todoItemCheckbox(todo.id),
          value: todo.complete,
          onChanged: (complete) {
            todo.complete = !todo.complete;
          //mutate the state by calling updateTodo and notify observers (HomeScreen, StateBuilder)
            todosServiceRM.setState((s) => s.updateTodo(todo));
          },
        ),
        title: Text(
          todo.task,
          key: ArchSampleKeys.todoItemTask(todo.id),
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: Text(
          todo.note,
          key: ArchSampleKeys.todoItemNote(todo.id),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.subhead,
        ),
      ),
    );
  }
}
```
**The home screen**
**file:ui/pages/home_screen/stats_counter.dart**
```dart
class StatsCounter extends StatelessWidget {
  //get the registered TodosService instance using Injector.get.
  //because we do not need reactivity in this widget.
  final todosService = Injector.get<TodosService>();

  StatsCounter() : super(key: ArchSampleKeys.statsCounter);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              ArchSampleLocalizations.of(context).completedTodos,
              style: Theme.of(context).textTheme.title,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 24.0),
            child: Text(
              '${todosService.numCompleted}',
              key: ArchSampleKeys.statsNumCompleted,
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              ArchSampleLocalizations.of(context).activeTodos,
              style: Theme.of(context).textTheme.title,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 24.0),
            child: Text(
              '${todosService.numCompleted}',
              key: ArchSampleKeys.statsNumActive,
              style: Theme.of(context).textTheme.subhead,
            ),
          )
        ],
      ),
    );
  }
}
```

The next screen is the add edit screen
**The add edit screen**
**file:ui/pages/add_edit_screen/add_edit_screen.dart**
```dart
class AddEditPage extends StatefulWidget {
  final Todo todo;

  AddEditPage({
    Key key,
    this.todo,
  }) : super(key: key ?? ArchSampleKeys.addTodoScreen);

  @override
  _AddEditPageState createState() => _AddEditPageState();
}

class _AddEditPageState extends State<AddEditPage> {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // Here we use a StatefulWidget to store local fields _task and _note
  // In fact, with states_rebuilder, we refer to StatefulWidgets in two cases:
  // 1. To caches UI related state of a widget, ex: the state of Taps, Selector, Checkbox, DropdownButton , ...
  // 2. For local variable only used inside the widget
  String _task;
  String _note;
  bool get isEditing => widget.todo != null;

  //get the reactive model of TodosService without subscription.
  final todosServiceRM = Injector.getAsReactive<TodosService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing
            ? ArchSampleLocalizations.of(context).editTodo
            : ArchSampleLocalizations.of(context).addTodo),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          autovalidate: false,
          onWillPop: () {
            return Future(() => true);
          },
          child: ListView(
            children: [
              TextFormField(
                initialValue: widget.todo != null ? widget.todo.task : '',
                key: ArchSampleKeys.taskField,
                autofocus: isEditing ? false : true,
                style: Theme.of(context).textTheme.headline,
                decoration: InputDecoration(
                    hintText: ArchSampleLocalizations.of(context).newTodoHint),
                validator: (val) => val.trim().isEmpty
                    ? ArchSampleLocalizations.of(context).emptyTodoError
                    : null,
                onSaved: (value) => _task = value,
              ),
              TextFormField(
                initialValue: widget.todo != null ? widget.todo.note : '',
                key: ArchSampleKeys.noteField,
                maxLines: 10,
                style: Theme.of(context).textTheme.subhead,
                decoration: InputDecoration(
                  hintText: ArchSampleLocalizations.of(context).notesHint,
                ),
                onSaved: (value) => _note = value,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key:
            isEditing ? ArchSampleKeys.saveTodoFab : ArchSampleKeys.saveNewTodo,
        tooltip: isEditing
            ? ArchSampleLocalizations.of(context).saveChanges
            : ArchSampleLocalizations.of(context).addTodo,
        child: Icon(isEditing ? Icons.check : Icons.add),
        onPressed: () {
          final form = formKey.currentState;
          if (form.validate()) {
            form.save();

            if (isEditing) {
              widget.todo
                ..task = _task
                ..note = _note;
              //mutate the state by calling updateTodo and notify observers (HomeScreen)
              todosServiceRM.setState((s) => s.updateTodo(widget.todo));
            } else {
              //mutate the state by calling addTodo and notify observers (HomeScreen)
              todosServiceRM.setState(
                (s) => s.addTodo(Todo(
                  _task,
                  note: _note,
                )),
              );
            }

            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
```
The last screen is the detail screen
**The detail screen**
**file:ui/pages/detail_screen/detail_screen.dart**

```dart
class DetailScreen extends StatelessWidget {
  DetailScreen(this.todo) : super(key: ArchSampleKeys.todoDetailsScreen);
  final Todo todo;

  //get the reactive model of TodosService without subscription.
  final todosServiceRM = Injector.getAsReactive<TodosService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ArchSampleLocalizations.of(context).todoDetails),
        actions: [
          IconButton(
            key: ArchSampleKeys.deleteTodoButton,
            tooltip: ArchSampleLocalizations.of(context).deleteTodo,
            icon: Icon(Icons.delete),
            onPressed: () {
              //mutate the state by calling deleteTodo and notify observers (HomeScreen)
              todosServiceRM.setState((s) => s.deleteTodo(todo));
              Navigator.pop(context, todo);
              //Delegate to HelperMethods.removeTodo method to remove todo and display snackbar
              HelperMethods.removeTodo(todo);
            },
          )
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
                      todo.complete = !todo.complete;
                      //mutate the state by calling updateTodo and notify observers (HomeScreen)
                      todosServiceRM.setState((s) => s.updateTodo(todo));
                    },
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 8.0,
                          bottom: 16.0,
                        ),
                        child: Text(
                          todo.task,
                          key: ArchSampleKeys.detailsTodoItemTask,
                          style: Theme.of(context).textTheme.headline,
                        ),
                      ),
                      Text(
                        todo.note,
                        key: ArchSampleKeys.detailsTodoItemNote,
                        style: Theme.of(context).textTheme.subhead,
                      )
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
        child: Icon(Icons.edit),
        key: ArchSampleKeys.editTodoFab,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return AddEditPage(
                  key: ArchSampleKeys.editTodoScreen,
                  todo: todo,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
```
Error handling center:

**file:ui/exceptions/error_handler.dart**

```dart
class ErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is ValidationException) {
      return error.message;
    }

    if (error is PersistanceException) {
      return error.message;
    }

    throw (error);
  }
}
```

common folder

**file:ui/common/enums.dart**

```dart
enum AppTab { todos, stats }
enum ExtraAction { toggleAllComplete, clearCompleted }
```
**file:ui/common/helper_methods.dart**

```dart
class HelperMethods {
  //the removeTodo is used in many places in the app. It removes the provided todo and shows a snackBar
  static void removeTodo(Todo todo) {
    final todosServiceRM = Injector.getAsReactive<TodosService>();
    todosServiceRM.setState(
      (s) => s.deleteTodo(todo),
      onSetState: (context) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            key: ArchSampleKeys.snackbar,
            duration: Duration(seconds: 2),
            content: Text(
              ArchSampleLocalizations.of(context).todoDeleted(todo.task),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            action: SnackBarAction(
              label: ArchSampleLocalizations.of(context).undo,
              onPressed: () {
                todosServiceRM.setState((s) => s.addTodo(todo));
              },
            ),
          ),
        );
      },
    );
  }
}
```
