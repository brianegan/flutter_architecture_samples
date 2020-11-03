import 'package:binder/binder.dart';
import 'package:binder_sample/localization.dart';
import 'package:binder_sample/logics/todos.dart';
import 'package:binder_sample/models.dart';
import 'package:binder_sample/screens/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todos_app_core/todos_app_core.dart';

class MockTodosLogic extends Mock implements TodosLogic {}

TodosLogic mockTodosLogic;

void main() {
  setUp(() {
    mockTodosLogic = MockTodosLogic();
  });

  group('DetailScreen', () {
    testWidgets('renders properly with todos', (tester) async {
      await tester.pumpWidget(DetailScreenTester(
        todos: [
          Todo('t1', id: '1'),
          Todo('t2', id: '2'),
          Todo('t3', id: '3'),
        ],
        id: '2',
      ));

      await tester.pumpAndSettle();
      expect(find.byKey(ArchSampleKeys.detailsTodoItemTask), findsOneWidget);
      expect(find.text('t2'), findsOneWidget);
    });

    testWidgets('can delete the todo', (tester) async {
      await tester.pumpWidget(DetailScreenTester(
        todos: [
          Todo('t1', id: '1'),
          Todo('t2', id: '2'),
          Todo('t3', id: '3'),
        ],
        id: '2',
      ));

      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ArchSampleKeys.deleteTodoButton));
      verify(mockTodosLogic.delete(Todo('t2', id: '2')));
    });
  });
}

class DetailScreenTester extends StatelessWidget {
  const DetailScreenTester({
    Key key,
    @required this.id,
    @required this.todos,
  }) : super(key: key);

  final String id;
  final List<Todo> todos;

  @override
  Widget build(BuildContext context) {
    return BinderScope(
      overrides: [
        todosLogicRef.overrideWith((scope) => mockTodosLogic),
        todosRef.overrideWith(todos),
      ],
      child: MaterialApp(
        theme: ArchSampleTheme.theme,
        localizationsDelegates: [
          ArchSampleLocalizationsDelegate(),
          BinderLocalizationsDelegate(),
        ],
        home: DetailScreen(id: id),
      ),
    );
  }
}
