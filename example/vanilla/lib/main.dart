import 'package:flutter/material.dart';
import 'package:flutter_mvc/flutter_mvc.dart';

void main() {
  runApp(new VanillaApp());
}

class VanillaApp extends StatelessWidget {
  static String title = 'FlutterMvc Vanilla';

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: title,
      theme: FlutterMvcTheme.theme,
      home: new Vanilla(),
    );
  }
}

class Vanilla extends StatefulWidget {
  Vanilla({Key key}) : super(key: key);

  @override
  _VanillaState createState() => new _VanillaState();
}

class _VanillaState extends State<Vanilla> {
  AppState _appState;
  FlutterMvcFileStorage _storage;
  TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _appState = new AppState.loading([], VisibilityFilter.all);
    _storage = new FlutterMvcFileStorage("vanilla");
    _textEditingController = new TextEditingController();

    _storage.loadAppState().then((appState) {
      setState(() {
        _appState = appState;
      });
    }).catchError((err) {
      setState(() {
        _appState.isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(VanillaApp.title),
      ),
      body: new Container(
        padding: new EdgeInsets.all(8.0),
        child: _appState.isLoading
            ? new Center(child: new CircularProgressIndicator())
            : new Column(
                children: [
                  _buildInput(),
                  _buildList(),
                ],
              ),
      ),
      bottomNavigationBar: _buildNav(),
    );
  }

  Row _buildInput() => new Row(
        children: [
          new Padding(
            padding: new EdgeInsets.only(right: 8.0),
            child: new GestureDetector(
              onTap: () {
                setState(() {
                  final completed = !_appState.allCompleted;

                  _appState.todos.forEach((todo) => todo.complete = completed);
                });
              },
              child: new AnimatedOpacity(
                opacity: _appState.todos.isEmpty ? 0.0 : 1.0,
                duration: new Duration(milliseconds: 200),
                child: new Icon(Icons.arrow_downward),
              ),
            ),
          ),
          new Expanded(
            child: new Padding(
              child: new TextField(
                controller: _textEditingController,
                decoration: new InputDecoration(
                  hintText: FlutterMvcStrings.hintText,
                ),
                onSubmitted: (todo) {
                  final trimmed = todo.trim();
                  if (trimmed.isNotEmpty) {
                    setState(() {
                      _appState.todos.add(new Todo(trimmed));
                      _textEditingController.clear();
                    });
                  }
                },
              ),
              padding: new EdgeInsets.only(right: 8.0),
            ),
          ),
        ],
      );

  Expanded _buildList() => new Expanded(
        child: new ListView.builder(
          itemCount: _appState.filteredTodos.length,
          itemBuilder: (BuildContext context, int index) =>
              _buildTodo(_appState.filteredTodos[index]),
        ),
      );

  Row _buildTodo(Todo todo) {
    return new Row(
      key: new ObjectKey(todo),
      children: [
        new Checkbox(
          value: todo.complete,
          onChanged: (complete) {
            setState(() {
              todo.complete = complete;
            });
          },
        ),
        new Expanded(child: _buildTodoTextOrInput(todo))
      ],
    );
  }

  Widget _buildTodoTextOrInput(Todo todo) {
    final controller = new TextEditingController(text: todo.text);

    return todo.editing
        ? new TextField(
            autofocus: true,
            controller: controller,
            onSubmitted: (task) {
              final trimmed = task.trim();

              setState(() {
                if (trimmed.isEmpty) {
                  _appState.todos.remove(todo);
                } else {
                  todo.text = trimmed;
                  todo.editing = false;
                }
              });
            },
          )
        : new GestureDetector(
            onDoubleTap: () {
              setState(() {
                todo.editing = true;
              });
            },
            child: new Text(todo.text),
          );
  }

  BottomNavigationBar _buildNav() {
    return new BottomNavigationBar(
        currentIndex: VisibilityFilter.values.indexOf(_appState.filter),
        onTap: (value) {
          setState(() {
            _appState.filter = VisibilityFilter.values[value];
          });
        },
        items: [
          new BottomNavigationBarItem(
              icon: new Icon(Icons.list),
              title: new Text(FlutterMvcStrings.all)),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.check_box_outline_blank),
              title: new Text(FlutterMvcStrings.active)),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.check_box),
              title: new Text(FlutterMvcStrings.completed)),
        ]);
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);

    _storage.saveAppState(_appState);
  }
}
