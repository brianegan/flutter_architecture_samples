import 'package:flutter/widgets.dart';
import 'package:mvi_base/mvi_base.dart';

class Injector extends InheritedWidget {
  final TodoListInteractor todosInteractor;
  final UserInteractor userInteractor;

  const Injector({
    super.key,
    required this.todosInteractor,
    required this.userInteractor,
    required super.child,
  });

  static Injector of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Injector>()!;

  @override
  bool updateShouldNotify(Injector oldWidget) =>
      todosInteractor != oldWidget.todosInteractor ||
      userInteractor != oldWidget.userInteractor;
}
