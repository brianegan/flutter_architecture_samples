import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mvc/flutter_mvc.dart';

class StatsCounter extends StatelessWidget {
  final int numActive;
  final int numCompleted;

  StatsCounter({@required this.numActive, @required this.numCompleted});

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new Padding(
            padding: new EdgeInsets.only(bottom: 8.0),
            child: new Text(
              ArchitectureLocalizations
                  .of(context)
                  .completedTodos,
              style: Theme
                  .of(context)
                  .textTheme
                  .title,
            ),
          ),
          new Padding(
            padding: new EdgeInsets.only(bottom: 24.0),
            child: new Text(
              '$numCompleted',
              style: Theme
                  .of(context)
                  .textTheme
                  .subhead,
            ),
          ),
          new Padding(
            padding: new EdgeInsets.only(bottom: 8.0),
            child: new Text(
              ArchitectureLocalizations
                  .of(context)
                  .activeTodos,
              style: Theme
                  .of(context)
                  .textTheme
                  .title,
            ),
          ),
          new Padding(
            padding: new EdgeInsets.only(bottom: 24.0),
            child: new Text(
              "$numActive",
              style: Theme
                  .of(context)
                  .textTheme
                  .subhead,
            ),
          )
        ],
      ),
    );
  }
}
