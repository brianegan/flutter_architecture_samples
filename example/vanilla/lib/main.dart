import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mvc/flutter_mvc.dart';
import 'package:meta/meta.dart';

void main() {
  runApp(new VanillaApp());
}

class VanillaApp extends StatefulWidget {
  static String title = 'Vanilla Example';

  @override
  State<StatefulWidget> createState() {
    return new VanillaAppState();
  }
}

class VanillaAppState extends State<VanillaApp> {
  List<Todo> todos = [];
  VisibilityFilter activeFilter = VisibilityFilter.all;
  bool isLoading = true;
  AppTab activeTab = AppTab.todos;

  FlutterMvcFileStorage _storage = new FlutterMvcFileStorage("vanilla");

  @override
  void initState() {
    super.initState();

    _storage.loadAppState().then((loadedState) {
      setState(() {
        isLoading = false;
        todos = loadedState.todos;
        activeTab = loadedState.activeTab;
        activeFilter = loadedState.activeFilter;
      });
    }).catchError((err) {
      setState(() {
        isLoading = false;
      });
    });
  }

  void updateTodos(VoidCallback fn) {
    setState(fn);
  }

  void updateFilter(VisibilityFilter filter) {
    setState(() {
      activeFilter = filter;
    });
  }

  void updateTab(AppTab tab) {
    setState(() {
      activeTab = tab;
    });
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);

    _storage.saveAppState(new AppState(
      todos: todos,
      activeFilter: activeFilter,
      activeTab: activeTab,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: VanillaApp.title,
      theme: FlutterMvcTheme.theme,
      onGenerateRoute: (settings) {},
      routes: {
        '/': (context) {
          return new ListScreen(
            activeFilter: activeFilter,
            activeTab: activeTab,
            todos: todos,
            isLoading: isLoading,
            updateFilter: updateFilter,
            updateTab: updateTab,
            updateTodos: updateTodos,
          );
        },
        '/addTodo': (context) {
          return new AddEditScreen(
            updateTodos: updateTodos,
            todos: todos,
          );
        },
      },
    );
  }
}

class DetailScreen extends StatelessWidget {
  final List<Todo> todos;
  final Todo todo;
  final Function(Function) updateTodos;

  DetailScreen({
    @required this.todos,
    @required this.todo,
    @required this.updateTodos,
    Key key,
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Todo Details"),
        actions: [
          new IconButton(
              tooltip: FlutterMvcStrings.deleteTodo,
              icon: new Icon(Icons.delete),
              onPressed: () {
                updateTodos(() {
                  todos.remove(todo);
                });

                Navigator.of(context).pop();
              })
        ],
      ),
      body: new Padding(
        padding: new EdgeInsets.all(16.0),
        child: new ListView(
          children: [
            new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new Padding(
                  padding: new EdgeInsets.only(right: 8.0),
                  child: new Checkbox(
                    value: todo.complete,
                    onChanged: (complete) {
                      updateTodos(() {
                        todo.complete = !todo.complete;
                      });
                    },
                  ),
                ),
                new Expanded(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      new Padding(
                        padding: new EdgeInsets.only(
                          top: 8.0,
                          bottom: 16.0,
                        ),
                        child: new Text(
                          todo.task,
                          style: Theme.of(context).textTheme.headline,
                        ),
                      ),
                      new Text(
                        todo.note,
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
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.edit),
        onPressed: () {
          Navigator.of(context).push(
            new PageRouteBuilder(
              pageBuilder: (context, _, __) {
                return new AddEditScreen(
                  updateTodos: updateTodos,
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

class AddEditScreen extends StatelessWidget {
  static final GlobalKey<FormState> formKey =
      new GlobalKey<FormState>(debugLabel: 'AddScreen Form');
  static final GlobalKey<FormFieldState<String>> taskKey =
      new GlobalKey<FormFieldState<String>>(debugLabel: 'AddScreen Task Field');
  static final GlobalKey<FormFieldState<String>> noteKey =
      new GlobalKey<FormFieldState<String>>(debugLabel: 'AddScreen Note Field');

  final List<Todo> todos;
  final Todo todo;
  final Function(Function) updateTodos;

  AddEditScreen({this.todos, this.todo, @required this.updateTodos, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
            isEditing ? FlutterMvcStrings.editTodo : FlutterMvcStrings.addTodo),
      ),
      body: new Padding(
        padding: new EdgeInsets.all(16.0),
        child: new Form(
          key: formKey,
          autovalidate: false,
          onWillPop: () {
            return new Future(() => true);
          },
          child: new ListView(
            children: [
              new TextFormField(
                initialValue: todo != null ? todo.task : '',
                key: taskKey,
                autofocus: isEditing ? false : true,
                style: Theme.of(context).textTheme.headline,
                decoration:
                    new InputDecoration(hintText: "What needs to be done?"),
                validator: (val) =>
                    val.trim().isEmpty ? 'The task cannot be empty' : null,
              ),
              new TextFormField(
                initialValue: todo != null ? todo.note : '',
                key: noteKey,
                maxLines: 10,
                style: Theme.of(context).textTheme.subhead,
                decoration: new InputDecoration(
                  hintText: "Additional notes...",
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
          child: new Icon(isEditing ? Icons.check : Icons.add),
          onPressed: () {
            final form = formKey.currentState;
            if (form.validate()) {
              final task = taskKey.currentState.value;
              final note = noteKey.currentState.value;

              if (isEditing) {
                updateTodos(() {
                  todo.task = task;
                  todo.note = note;
                });
              } else {
                updateTodos(() {
                  todos.add(new Todo(
                    task,
                    note: note,
                  ));
                });
              }

              Navigator.pop(context);
            }
          }),
    );
  }

  bool get isEditing => todo != null;
}

class ListScreen extends StatelessWidget {
  final List<Todo> todos;
  final VisibilityFilter activeFilter;
  final bool isLoading;
  final AppTab activeTab;
  final Function(Function) updateTodos;
  final Function(VisibilityFilter) updateFilter;
  final Function(AppTab) updateTab;

  ListScreen({
    @required this.todos,
    @required this.updateTodos,
    @required this.updateFilter,
    @required this.updateTab,
    @required this.activeTab,
    @required this.activeFilter,
    @required this.isLoading,
    Key key,
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final numCompleted = todos.fold(
      0,
      (sum, todo) => todo.complete ? ++sum : sum,
    );

    final numActive = todos.fold(
      0,
      (sum, todo) => !todo.complete ? ++sum : sum,
    );

    final allComplete = todos.every((todo) => todo.complete);

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(VanillaApp.title),
        actions: [
          new FilterButton(
            activeFilter: activeFilter,
            onSelected: updateFilter,
          ),
          new ExtraActionsButton(
            allComplete: allComplete,
            hasCompletedTodos: todos.any((todo) => todo.complete),
            onSelected: (action) {
              if (action == ExtraAction.toggleAllComplete) {
                updateTodos(() {
                  todos.forEach((todo) => todo.complete = !allComplete);
                });
              } else if (action == ExtraAction.clearCompleted) {
                updateTodos(() {
                  todos.removeWhere((todo) => todo.complete);
                });
              }
            },
          )
        ],
      ),
      body: activeTab == AppTab.todos
          ? new Container(
              child: isLoading
                  ? new Center(child: new CircularProgressIndicator())
                  : new Column(
                      children: [
                        _buildList(),
                      ],
                    ),
            )
          : new Center(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new Padding(
                    padding: new EdgeInsets.only(bottom: 8.0),
                    child: new Text(
                      "Completed Todos",
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.only(bottom: 24.0),
                    child: new Text(
                      numCompleted.toString(),
                      style: Theme.of(context).textTheme.subhead,
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.only(bottom: 8.0),
                    child: new Text(
                      "Active Todos",
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.only(bottom: 24.0),
                    child: new Text(
                      "$numActive",
                      style: Theme.of(context).textTheme.subhead,
                    ),
                  )
                ],
              ),
            ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addTodo');
        },
        child: new Icon(Icons.add),
        tooltip: FlutterMvcStrings.addTodo,
      ),
      bottomNavigationBar: _buildNav(),
    );
  }

  Expanded _buildList() {
    final filteredTodos = todos.where((todo) {
      if (activeFilter == VisibilityFilter.all) {
        return true;
      } else if (activeFilter == VisibilityFilter.active) {
        return !todo.complete;
      } else if (activeFilter == VisibilityFilter.completed) {
        return todo.complete;
      }
    }).toList();

    return new Expanded(
      child: new ListView.builder(
        itemCount: filteredTodos.length,
        itemBuilder: (BuildContext context, int index) {
          final todo = filteredTodos[index];

          return new Dismissible(
            key: new Key(todo.id),
            onDismissed: (direction) {
              updateTodos(() {
                todos.remove(todo);
              });
            },
            child: new ListTile(
              onTap: () {
                Navigator.of(context).push(
                  new PageRouteBuilder(
                    pageBuilder: (context, _, __) {
                      return new DetailScreen(
                        todos: todos,
                        todo: todo,
                        updateTodos: updateTodos,
                      );
                    },
                  ),
                );
              },
              leading: new Checkbox(
                value: todo.complete,
                onChanged: (complete) {
                  updateTodos(() {
                    todo.complete = !todo.complete;
                  });
                },
              ),
              title: new Text(
                todo.task,
                style: Theme.of(context).textTheme.title,
              ),
              subtitle: new Text(
                todo.note,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.subhead,
              ),
            ),
          );
        },
      ),
    );
  }

  BottomNavigationBar _buildNav() {
    return new BottomNavigationBar(
        currentIndex: AppTab.values.indexOf(activeTab),
        onTap: (index) {
          updateTab(AppTab.values[index]);
        },
        items: AppTab.values.map((tab) {
          return new BottomNavigationBarItem(
            icon: new Icon(tab == AppTab.todos ? Icons.list : Icons.show_chart),
            title: new Text(FlutterMvcStrings.tabTitle(tab)),
          );
        }).toList());
  }
}
