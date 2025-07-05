// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils.dart';
import 'test_element.dart';
import 'todo_item_element.dart';

class TodoListElement extends TestElement {
  final _todoListFinder = find.byKey(ValueKey('__todoList__'));
  final _loadingFinder = find.byKey(ValueKey('__todosLoading__'));

  TodoListElement(WidgetTester tester) : super(tester);

  Future<bool> get isLoading async {
    await tester.pump();

    return widgetExists(tester, _loadingFinder);
  }

  Future<bool> get isReady async {
    await tester.pumpAndSettle();
    return widgetExists(tester, _todoListFinder);
  }

  TodoItemElement todoItem(String id) => TodoItemElement(id, tester);

  TodoItemElement todoItemAbsent(String id) => TodoItemElement(id, tester);
}
