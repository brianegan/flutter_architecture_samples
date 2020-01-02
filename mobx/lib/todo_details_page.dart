import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx_sample/edit_todo_page.dart';
import 'package:mobx_sample/store/todo.dart';

class TodoDetailsPage extends StatelessWidget {
  TodoDetailsPage({@required this.todo, @required this.onRemove});

  final Todo todo;
  final void Function() onRemove;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Details'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: onRemove,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () {
          final todoClone = todo.clone();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditTodoPage(
                        todo: todoClone,
                        onDelete: () {
                          Navigator.pop(context);
                          onRemove();
                        },
                        onEdit: () {
                          Navigator.pop(context);
                          todo.copyFrom(todoClone);
                        },
                      )));
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Observer(
          builder: (_) => ListTile(
              title: Text(
                todo.title,
                style: TextStyle(fontSize: 20),
              ),
              subtitle: todo.notes != null
                  ? Text(todo.notes)
                  : Container(
                      width: 0,
                      height: 0,
                    ),
              leading: Checkbox(
                value: todo.done,
                onChanged: (value) => todo.done = value,
              )),
        ),
      ),
    );
  }
}
