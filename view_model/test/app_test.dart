import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todos_app_core/todos_app_core.dart';
import 'package:todos_repository_core/todos_repository_core.dart';
import 'package:view_model/view_model.dart';
import 'package:view_model_sample/app.dart';

import 'support/fake_todos_repository.dart';

void main() {
  setUp(ViewModel.reset);
  tearDown(ViewModel.reset);

  testWidgets('shows loading then renders repository todos', (tester) async {
    final loadCompleter = Completer<List<TodoEntity>>();
    final repository = FakeTodosRepository(loadCompleter: loadCompleter);

    await tester.pumpWidget(ViewModelApp(repository: repository));
    await tester.pump();
    expect(find.byKey(ArchSampleKeys.todosLoading), findsOneWidget);

    loadCompleter.complete([TodoEntity('Loaded todo', '1', 'note', false)]);
    await tester.pumpAndSettle();

    expect(find.text('Loaded todo'), findsOneWidget);
    expect(find.byKey(ArchSampleKeys.todoItem('1')), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('adds a todo through the shared sample flow', (tester) async {
    final repository = FakeTodosRepository();
    await tester.pumpWidget(ViewModelApp(repository: repository));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(ArchSampleKeys.addTodoFab));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(ArchSampleKeys.taskField), 'Write tests');
    await tester.enterText(find.byKey(ArchSampleKeys.noteField), 'Use binding');
    await tester.tap(find.byKey(ArchSampleKeys.saveNewTodo));
    await tester.pumpAndSettle();

    expect(find.text('Write tests'), findsOneWidget);
    expect(repository.savedTodos.single.single.task, 'Write tests');

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('edits a todo and refreshes details and home', (tester) async {
    final repository = FakeTodosRepository(
      todos: [TodoEntity('Original', '1', 'old note', false)],
    );
    await tester.pumpWidget(ViewModelApp(repository: repository));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Original'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ArchSampleKeys.editTodoFab));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(ArchSampleKeys.taskField), 'Edited');
    await tester.enterText(find.byKey(ArchSampleKeys.noteField), 'new note');
    await tester.tap(find.byKey(ArchSampleKeys.saveTodoFab));
    await tester.pumpAndSettle();

    expect(repository.savedTodos.last.single.task, 'Edited');
    expect(find.byKey(ArchSampleKeys.todoDetailsScreen), findsOneWidget);
    expect(find.text('Edited'), findsOneWidget);
    expect(find.text('new note'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Edited'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
  });
}
