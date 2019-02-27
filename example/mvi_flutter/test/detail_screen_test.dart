// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mvi_base/mvi_base.dart';
import 'package:mvi_flutter_sample/screens/detail_screen.dart';
import 'package:test/test.dart' as test;

void main() {
  test.group('DetailScreen', () {
    testWidgets('should render the Task and Note', (tester) async {
      final todo = Todo('Hallo', note: 'Hello');
      final presenter = MockDetailPresenter(todo);
      final screen = MaterialApp(
        localizationsDelegates: [
          ArchSampleLocalizationsDelegate(),
        ],
        home: DetailScreen(
          todoId: todo.id,
          initPresenter: (view) => presenter,
        ),
      );

      await tester.pumpWidget(screen);
      await tester.pumpAndSettle(); // Build the widget and wait for the data

      expect(find.text(todo.task), findsOneWidget);
      expect(find.text(todo.note), findsOneWidget);
    });

    testWidgets('should be checked when todo complete', (tester) async {
      final todo = Todo('Hallo', note: 'Hello', complete: true);
      final presenter = MockDetailPresenter(todo);
      final screen = MaterialApp(
        localizationsDelegates: [
          ArchSampleLocalizationsDelegate(),
        ],
        home: DetailScreen(
          todoId: todo.id,
          initPresenter: (view) => presenter,
        ),
      );

      await tester.pumpWidget(screen);
      await tester.pumpAndSettle(); // Build the widget and wait for the data

      expect(
        tester.firstWidget(find.byKey(ArchSampleKeys.detailsTodoItemCheckbox)),
        isChecked,
      );
    });

    testWidgets('should not be checked when incomplete', (tester) async {
      final todo = Todo('Hallo', note: 'Hello', complete: false);
      final presenter = MockDetailPresenter(todo);
      final screen = MaterialApp(
        localizationsDelegates: [
          ArchSampleLocalizationsDelegate(),
        ],
        home: DetailScreen(
          todoId: todo.id,
          initPresenter: (view) => presenter,
        ),
      );

      await tester.pumpWidget(screen);
      await tester.pumpAndSettle(); // Build the widget and wait for the data

      expect(
        tester.firstWidget(find.byKey(ArchSampleKeys.detailsTodoItemCheckbox)),
        test.isNot(isChecked),
      );
    });

    testWidgets('should delete the todo', (tester) async {
      final todo = Todo('Hallo');
      final presenter = MockDetailPresenter(todo);
      final key = GlobalKey<DetailScreenState>();
      final screen = MaterialApp(
        localizationsDelegates: [
          ArchSampleLocalizationsDelegate(),
        ],
        home: DetailScreen(
          key: key,
          todoId: todo.id,
          initPresenter: (view) => presenter,
        ),
      );

      await tester.pumpWidget(screen);
      await tester.pumpAndSettle(); // Build the widget and wait for the data

      // Delay the tap until we start listening to the stream
      scheduleMicrotask(() async {
        await tester.tap(find.byKey(ArchSampleKeys.deleteTodoButton));
      });

      // Expect that the deleteTodoStream emits the current id. The Presenter
      // is responsible for listening to this stream and doing work with it!
      expect(key.currentState.deleteTodo.stream, test.emits(todo.id));
    });

    testWidgets('should update a todo', (tester) async {
      final todo = Todo('Hallo');
      final presenter = MockDetailPresenter(todo);
      final key = GlobalKey<DetailScreenState>();
      final screen = MaterialApp(
        localizationsDelegates: [
          ArchSampleLocalizationsDelegate(),
        ],
        home: DetailScreen(
          key: key,
          todoId: todo.id,
          initPresenter: (view) => presenter,
        ),
      );

      await tester.pumpWidget(screen);
      await tester.pumpAndSettle(); // Build the widget and wait for the data

      // Delay the tap until we start listening to the stream
      scheduleMicrotask(() async {
        await tester.tap(find.byKey(ArchSampleKeys.detailsTodoItemCheckbox));
      });

      // Expect that the deleteTodoStream emits the current id. The Presenter
      // is responsible for listening to this stream and doing work with it!
      expect(
        key.currentState.updateTodo.stream,
        test.emits(todo.copyWith(complete: true)),
      );
    });
  });
}

class MockDetailPresenter extends MviPresenter<Todo> {
  MockDetailPresenter(Todo todo)
      : super(
          stream: Stream.fromIterable([todo]),
          initialModel: todo,
        );
}

test.Matcher get isChecked => CheckedMatcher(true);

class CheckedMatcher extends test.Matcher {
  final bool checked;
  bool wasCheckbox = true;

  CheckedMatcher(this.checked);

  @override
  test.Description describe(test.Description description) {
    if (!wasCheckbox) {
      return description.replace('The item was not a checkbox');
    } else {
      return description
          .replace('Checkbox was ${!checked} rather than $checked');
    }
  }

  @override
  bool matches(item, Map matchState) {
    if (item is Checkbox) {
      return item.value == checked;
    } else {
      wasCheckbox = false;
      return false;
    }
  }
}
