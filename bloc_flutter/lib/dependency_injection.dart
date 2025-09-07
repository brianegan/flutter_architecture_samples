import 'package:blocs/blocs.dart';
import 'package:flutter/widgets.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

class Injector extends InheritedWidget {
  final TodosInteractor todosInteractor;
  final UserRepository userRepository;

  const Injector({
    super.key,
    required this.todosInteractor,
    required this.userRepository,
    required super.child,
  });

  static Injector of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Injector>()!;

  @override
  bool updateShouldNotify(Injector oldWidget) =>
      todosInteractor != oldWidget.todosInteractor ||
      userRepository != oldWidget.userRepository;
}
