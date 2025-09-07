import 'package:flutter/material.dart';
import 'package:simple_blocs/simple_blocs.dart';

class TodosBlocProvider extends StatefulWidget {
  final Widget child;
  final TodosListBloc bloc;

  const TodosBlocProvider({required this.child, required this.bloc, super.key});

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

  const _TodosBlocProvider({required super.child, required this.bloc});

  @override
  bool updateShouldNotify(_TodosBlocProvider old) => bloc != old.bloc;
}
