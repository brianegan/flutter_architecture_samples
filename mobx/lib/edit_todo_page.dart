import 'package:flutter/material.dart';

class EditTodoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Todo'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {},
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(hintText: 'What needs to be done?'),
              style: TextStyle(fontSize: 20),
            ),
            TextFormField(
              decoration: InputDecoration(hintText: 'Additional notes'),
              maxLines: 10,
            )
          ],
        ),
      ),
    );
  }
}
