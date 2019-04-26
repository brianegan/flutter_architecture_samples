import 'package:flutter/material.dart';
import 'package:mobx_sample/todo_stores.dart';

class AddTodoPage extends StatefulWidget {
  final void Function(Todo) onAdd;

  AddTodoPage({@required this.onAdd});

  @override
  _AddTodoPageState createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final todo = Todo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Todo'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _formKey.currentState.save();
          widget.onAdd(todo);
        },
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(hintText: 'What needs to be done?'),
                style: TextStyle(fontSize: 20),
                onSaved: todo.setTitle,
              ),
              TextFormField(
                decoration: InputDecoration(hintText: 'Additional notes'),
                maxLines: 10,
                onSaved: todo.setNotes,
              )
            ],
          ),
        ),
      ),
    );
  }
}
