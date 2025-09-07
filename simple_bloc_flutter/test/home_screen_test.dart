import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:simple_bloc_flutter_sample/anonymous_user_repository.dart';
import 'package:simple_bloc_flutter_sample/dependency_injection.dart';
import 'package:simple_bloc_flutter_sample/localization.dart';
import 'package:simple_bloc_flutter_sample/screens/home_screen.dart';
import 'package:simple_bloc_flutter_sample/widgets/todos_bloc_provider.dart';
import 'package:simple_blocs/simple_blocs.dart';
import 'package:todos_app_core/todos_app_core.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

import 'home_screen_test.mocks.dart';

@GenerateNiceMocks([MockSpec<TodosInteractor>(), MockSpec<UserRepository>()])
void main() {
  group('HomeScreen', () {
    final todoListFinder = find.byKey(ArchSampleKeys.todoList);
    final todoItem1Finder = find.byKey(ArchSampleKeys.todoItem('1'));
    final todoItem2Finder = find.byKey(ArchSampleKeys.todoItem('2'));
    final todoItem3Finder = find.byKey(ArchSampleKeys.todoItem('3'));

    testWidgets('should render loading indicator at first', (tester) async {
      await tester.pumpWidget(
        _TestWidget(
          todosInteractor: MockTodosInteractor(),
          userRepository: AnonymousUserRepository(),
        ),
      );
      await tester.pump(Duration.zero);

      expect(find.byKey(ArchSampleKeys.todosLoading), findsOneWidget);
    });

    testWidgets('should display a list after loading todos', (tester) async {
      final handle = tester.ensureSemantics();
      final interactor = MockTodosInteractor();

      when(
        interactor.todos,
      ).thenAnswer((_) => Stream.fromIterable([_TestWidget._defaultTodos]));

      await tester.pumpWidget(
        _TestWidget(
          todosInteractor: interactor,
          userRepository: AnonymousUserRepository(),
        ),
      );
      await tester.pumpAndSettle();

      final checkbox1 = find.descendant(
        of: find.byKey(ArchSampleKeys.todoItemCheckbox('1')),
        matching: find.byType(Focus),
      );
      final checkbox2 = find.descendant(
        of: find.byKey(ArchSampleKeys.todoItemCheckbox('2')),
        matching: find.byType(Focus),
      );
      final checkbox3 = find.descendant(
        of: find.byKey(ArchSampleKeys.todoItemCheckbox('3')),
        matching: find.byType(Focus),
      );

      expect(todoListFinder, findsOneWidget);
      expect(todoItem1Finder, findsOneWidget);
      expect(find.text('T1'), findsOneWidget);
      expect(find.text('N1'), findsOneWidget);
      expect(tester.getSemantics(checkbox1), isChecked(false));
      expect(todoItem2Finder, findsOneWidget);
      expect(find.text('T2'), findsOneWidget);
      expect(tester.getSemantics(checkbox2), isChecked(false));
      expect(todoItem3Finder, findsOneWidget);
      expect(find.text('T3'), findsOneWidget);
      expect(tester.getSemantics(checkbox3), isChecked(true));

      handle.dispose();
    });

    testWidgets('should remove todos using a dismissible', (tester) async {
      final interactor = MockTodosInteractor();

      when(
        interactor.todos,
      ).thenAnswer((_) => Stream.fromIterable([_TestWidget._defaultTodos]));

      await tester.pumpWidget(
        _TestWidget(
          todosInteractor: interactor,
          userRepository: AnonymousUserRepository(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.drag(todoItem1Finder, Offset(-1000, 0));
      await tester.pumpAndSettle(Duration(seconds: 5));

      expect(todoItem1Finder, findsNothing);
      expect(todoItem2Finder, findsOneWidget);
      expect(todoItem3Finder, findsOneWidget);
    });

    testWidgets('should display stats when switching tabs', (tester) async {
      final interactor = MockTodosInteractor();

      when(
        interactor.todos,
      ).thenAnswer((_) => Stream.fromIterable([_TestWidget._defaultTodos]));

      await tester.pumpWidget(
        _TestWidget(
          todosInteractor: interactor,
          userRepository: AnonymousUserRepository(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ArchSampleKeys.statsTab));
      await tester.pump();

      expect(find.byKey(ArchSampleKeys.statsNumActive), findsOneWidget);
      expect(find.byKey(ArchSampleKeys.statsNumActive), findsOneWidget);
    });
  });
}

class _TestWidget extends StatelessWidget {
  const _TestWidget({
    required this.todosInteractor,
    required this.userRepository,
  });

  final TodosInteractor todosInteractor;
  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    return Injector(
      todosInteractor: todosInteractor,
      userRepository: userRepository,
      child: TodosBlocProvider(
        bloc: TodosListBloc(todosInteractor),
        child: MaterialApp(
          localizationsDelegates: [
            SimpleBlocLocalizationsDelegate(),
            ArchSampleLocalizationsDelegate(),
          ],
          home: const HomeScreen(),
        ),
      ),
    );
  }

  static List<Todo> get _defaultTodos {
    return [
      Todo('T1', id: '1', note: 'N1'),
      Todo('T2', id: '2'),
      Todo('T3', id: '3', complete: true),
    ];
  }
}

Matcher isChecked(bool isChecked) {
  return matchesSemantics(
    isChecked: isChecked,
    hasTapAction: true,
    hasFocusAction: true,
    hasCheckedState: true,
    isFocusable: true,
    hasEnabledState: true,
    isEnabled: true,
  );
}
