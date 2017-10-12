import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';
import 'package:vanilla/models.dart';
import 'package:vanilla/screens/add_edit_screen.dart';
import 'package:vanilla/widgets/typedefs.dart';

class DetailScreen extends StatelessWidget {
  final Todo todo;
  final Function onDelete;
  final TodoAdder addTodo;
  final TodoUpdater updateTodo;

  DetailScreen({
    @required this.todo,
    @required this.addTodo,
    @required this.updateTodo,
    @required this.onDelete,
    Key key,
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(ArchSampleLocalizations.of(context).todoDetails),
        actions: [
          new IconButton(
              tooltip: ArchSampleLocalizations.of(context).deleteTodo,
              icon: new Icon(Icons.delete),
              onPressed: () {
                onDelete();
                Navigator.pop(context);
              },)
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
                      updateTodo(todo, complete: !todo.complete);
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
        tooltip: ArchSampleLocalizations.of(context).editTodo,
        child: new Icon(Icons.edit),
        onPressed: () {
          Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (context) {
                return new AddEditScreen(
                  updateTodo: updateTodo,
                  addTodo: addTodo,
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
