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
  AppState _appState;
  FlutterMvcFileStorage _storage;

  @override
  void initState() {
    super.initState();
    _appState = new AppState.loading([], VisibilityFilter.all);
    _storage = new FlutterMvcFileStorage("vanilla");

    _storage.loadAppState().then((loadedState) {
      setState(() {
        _appState = loadedState;
      });
    }).catchError((err) {
      setState(() {
        _appState = _appState.copyWith(isLoading: false);
      });
    });
  }

  void updateState(AppState appState) {
    setState(() {
      _appState = appState;
    });

    _storage.saveAppState(_appState);
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
            updateState: updateState,
            appState: _appState,
          );
        },
        '/addTodo': (context) => new AddEditScreen(
              updateState: updateState,
              appState: _appState,
            ),
      },
    );
  }
}

class DetailScreen extends StatelessWidget {
  final AppState appState;
  final Function(AppState) updateState;
  final Todo todo;

  DetailScreen({
    @required this.appState,
    @required this.updateState,
    @required this.todo,
    Key key,
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Todo Details"),
      ),
      body: new Padding(
        padding: new EdgeInsets.all(16.0),
        child: new ListView(
          children: [
            new Text(
              todo.task,
              style: Theme.of(context).textTheme.headline,
            ),
            new Text(
              todo.note,
              style: Theme.of(context).textTheme.subhead,
            )
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
                  appState: appState,
                  updateState: updateState,
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
  final AppState appState;
  final Function(AppState) updateState;
  final Todo todo;
  static final GlobalKey<FormState> formKey =
      new GlobalKey<FormState>(debugLabel: 'AddScreen Form');
  static final GlobalKey<FormFieldState<String>> taskKey =
      new GlobalKey<FormFieldState<String>>(debugLabel: 'AddScreen Task Field');
  static final GlobalKey<FormFieldState<String>> noteKey =
      new GlobalKey<FormFieldState<String>>(debugLabel: 'AddScreen Note Field');

  bool get isEditing => todo != null;

  AddEditScreen(
      {@required this.appState, @required this.updateState, this.todo, Key key})
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
                updateState(appState.updateTodo(
                    todo, todo.copyWith(task: task, note: note)));
              } else {
                updateState(appState.addTodo(new Todo(
                  task,
                  note: note,
                )));
              }

              Navigator.pop(context);
            }
          }),
    );
  }
}

class ListScreen extends StatelessWidget {
  final AppState appState;
  final Function(AppState) updateState;

  ListScreen({@required this.appState, @required this.updateState, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(VanillaApp.title),
        actions: [
          new FilterButton(
              activeFilter: appState.activeFilter,
              onSelected: (filter) {
                updateState(appState.copyWith(activeFilter: filter));
              }),
          new ExtraActionsButton(
            allComplete: appState.allComplete,
            hasCompletedTodos: appState.hasCompletedTodos,
            onSelected: (action) {
              if (action == ExtraAction.toggleAllComplete) {
                updateState(appState.toggleAll());
              } else if (action == ExtraAction.clearCompleted) {
                updateState(appState.clearCompleted());
              }
            },
          )
        ],
      ),
      body: appState.activeTab == AppTab.todos
          ? new Container(
              child: appState.isLoading
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
                      appState.numCompleted.toString(),
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
                      appState.numActive.toString(),
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

  Expanded _buildList() => new Expanded(
        child: new ListView.builder(
          itemCount: appState.filteredTodos.length,
          itemBuilder: (BuildContext context, int index) {
            final todo = appState.filteredTodos[index];

            return new Dismissible(
              key: new Key(todo.id),
              onDismissed: (direction) {
                updateState(appState.removeTodo(todo));
              },
              child: new ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    new PageRouteBuilder(
                      pageBuilder: (context, _, __) {
                        return new DetailScreen(
                          appState: appState,
                          updateState: updateState,
                          todo: todo,
                        );
                      },
                    ),
                  );
                },
                leading: new Checkbox(
                  value: todo.complete,
                  onChanged: (complete) {
                    updateState(appState.toggleOne(
                      todo,
                      complete,
                    ));
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

  BottomNavigationBar _buildNav() {
    return new BottomNavigationBar(
        currentIndex: AppTab.values.indexOf(appState.activeTab),
        onTap: (value) {
          updateState(appState.copyWith(activeTab: AppTab.values[value]));
        },
        items: AppTab.values.map((tab) {
          return new BottomNavigationBarItem(
            icon: new Icon(tab == AppTab.todos ? Icons.list : Icons.show_chart),
            title: new Text(FlutterMvcStrings.tabTitle(tab)),
          );
        }).toList());
  }
}
