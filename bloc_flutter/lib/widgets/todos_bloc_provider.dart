import 'package:blocs/blocs.dart';
import 'package:flutter/material.dart';

class TodosBlocProvider extends StatefulWidget {
  final Widget child;
  final TodosListBloc bloc;

  const TodosBlocProvider({super.key, required this.child, required this.bloc});

  @override
  TodosBlocProviderState createState() => TodosBlocProviderState();

  static TodosListBloc of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_TodosBlocProvider>()!
        .bloc;
  }
}

class TodosBlocProviderState extends State<TodosBlocProvider> {
  @override
  Widget build(BuildContext context) {
    return _TodosBlocProvider(bloc: widget.bloc, child: widget.child);
  }

  @override
  void dispose() {
    widget.bloc.close();
    super.dispose();
  }
}

class _TodosBlocProvider extends InheritedWidget {
  final TodosListBloc bloc;

  const _TodosBlocProvider({required this.bloc, required super.child});

  @override
  bool updateShouldNotify(_TodosBlocProvider old) => bloc != old.bloc;
}
