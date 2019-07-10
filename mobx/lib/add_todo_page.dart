import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx_sample/model/todo.dart';

class AddTodoPage extends StatefulWidget {
  final void Function(Todo) onAdd;

  AddTodoPage({@required this.onAdd});

  @override
  _AddTodoPageState createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final todo = Todo();
  final _titleEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleEditingController.addListener(() {
      todo.title = _titleEditingController.text;
    });
  }

  @override
  void dispose() {
    _titleEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Todo'),
      ),
      floatingActionButton: Observer(
          builder: (_) => FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: todo.hasTitle ? Colors.blue : Colors.grey,
              onPressed: todo.hasTitle
                  ? () {
                      _formKey.currentState.save();
                      widget.onAdd(todo);
                    }
                  : null)),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _titleEditingController,
                decoration: InputDecoration(hintText: 'What needs to be done?'),
                style: TextStyle(fontSize: 20),
                onSaved: (value) => todo.title = value,
                autofocus: true,
              ),
              TextFormField(
                decoration: InputDecoration(hintText: 'Additional notes'),
                maxLines: 10,
                onSaved: (value) => todo.notes = value,
              )
            ],
          ),
        ),
      ),
    );
  }
}
