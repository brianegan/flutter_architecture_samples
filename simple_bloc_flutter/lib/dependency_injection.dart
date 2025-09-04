// A poor man's DI, but an example of how to use the InheritedWidget class for
// DI in a Flutter app.
import 'package:flutter/widgets.dart';
import 'package:simple_blocs/simple_blocs.dart';
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
