import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx_sample/store/todo.dart';

class EditTodoPage extends StatefulWidget {
  EditTodoPage(
      {@required this.todo, @required this.onEdit, @required this.onDelete});

  final void Function() onDelete;

  final void Function() onEdit;

  final Todo todo;

  @override
  _EditTodoPageState createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {
  final _titleEditingController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleEditingController.text = widget.todo.title;
    _titleEditingController.addListener(() {
      widget.todo.title = _titleEditingController.text;
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
        title: Text('Edit Todo'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: widget.onDelete,
          )
        ],
      ),
      floatingActionButton: Observer(
        builder: (_) => FloatingActionButton(
          backgroundColor: widget.todo.hasTitle ? Colors.blue : Colors.grey,
          child: Icon(Icons.check),
          onPressed: widget.todo.hasTitle
              ? () {
                  _formKey.currentState.save();

                  widget.onEdit();
                }
              : null,
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Observer(
                builder: (_) => TextFormField(
                  controller: _titleEditingController,
                  decoration: InputDecoration(
                      hintText: 'What needs to be done?',
                      focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      errorText: widget.todo.hasTitle
                          ? null
                          : 'Title cannot be blank'),
                  style: TextStyle(fontSize: 20),
                  onSaved: (value) => widget.todo.title = value,
                ),
              ),
              TextFormField(
                decoration: InputDecoration(hintText: 'Additional notes'),
                maxLines: 10,
                initialValue: widget.todo.notes,
                onSaved: (value) => widget.todo.notes = value,
              )
            ],
          ),
        ),
      ),
    );
  }
}
