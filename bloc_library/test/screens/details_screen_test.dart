// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_library/blocs/todos/todos.dart';
import 'package:bloc_library/screens/screens.dart';
import 'package:bloc_library/models/models.dart';
import 'package:bloc_library/bloc_library_keys.dart';
import 'package:bloc_library/localization.dart';
import 'package:todos_app_core/todos_app_core.dart';

class MockTodosBloc extends MockBloc<TodosEvent, TodosState>
    implements TodosBloc {}

void main() {
  group('DetailsScreen', () {
    TodosBloc todosBloc;

    setUp(() {
      todosBloc = MockTodosBloc();
    });

    tearDown(() {
      todosBloc.close();
    });

    testWidgets('renders properly with no todos', (WidgetTester tester) async {
      when(todosBloc.state).thenReturn(TodosLoaded([]));
      await tester.pumpWidget(
        BlocProvider.value(
          value: todosBloc,
          child: MaterialApp(
            home: Scaffold(
              body: DetailsScreen(id: '0'),
            ),
            localizationsDelegates: [
              ArchSampleLocalizationsDelegate(),
              FlutterBlocLocalizationsDelegate(),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(BlocLibraryKeys.emptyDetailsContainer), findsOneWidget);
    });

    testWidgets('renders properly with todos', (WidgetTester tester) async {
      when(todosBloc.state).thenReturn(
        TodosLoaded([Todo('wash car', id: '0')]),
      );
      await tester.pumpWidget(
        BlocProvider.value(
          value: todosBloc,
          child: MaterialApp(
            home: Scaffold(
              body: DetailsScreen(id: '0'),
            ),
            localizationsDelegates: [
              ArchSampleLocalizationsDelegate(),
              FlutterBlocLocalizationsDelegate(),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(ArchSampleKeys.detailsTodoItemTask), findsOneWidget);
      expect(find.text('wash car'), findsOneWidget);
    });

    testWidgets('adds UpdateTodo when checkbox tapped',
        (WidgetTester tester) async {
      when(todosBloc.state).thenReturn(
        TodosLoaded([Todo('wash car', id: '0')]),
      );
      when(todosBloc.add(
        UpdateTodo(Todo('wash car', id: '0', complete: true)),
      )).thenReturn(null);
      await tester.pumpWidget(
        BlocProvider.value(
          value: todosBloc,
          child: MaterialApp(
            home: Scaffold(
              body: DetailsScreen(id: '0'),
            ),
            localizationsDelegates: [
              ArchSampleLocalizationsDelegate(),
              FlutterBlocLocalizationsDelegate(),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(BlocLibraryKeys.detailsScreenCheckBox));
      verify(todosBloc.add(
        UpdateTodo(Todo('wash car', id: '0', complete: true)),
      )).called(1);
    });

    testWidgets('Navigates to Edit Todo Screen when Edit Tapped',
        (WidgetTester tester) async {
      when(todosBloc.state).thenReturn(
        TodosLoaded([Todo('wash car', id: '0')]),
      );
      await tester.pumpWidget(
        BlocProvider.value(
          value: todosBloc,
          child: MaterialApp(
            home: Scaffold(
              body: DetailsScreen(id: '0'),
            ),
            localizationsDelegates: [
              ArchSampleLocalizationsDelegate(),
              FlutterBlocLocalizationsDelegate(),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ArchSampleKeys.editTodoFab));
      await tester.pumpAndSettle();
      expect(find.byKey(ArchSampleKeys.editTodoScreen), findsOneWidget);
    });

    testWidgets('adds UpdateTodo when onSave called',
        (WidgetTester tester) async {
      when(todosBloc.add(
        UpdateTodo(Todo('new todo', id: '0', complete: true)),
      )).thenReturn(null);
      when(todosBloc.state).thenReturn(
        TodosLoaded([Todo('wash car', id: '0')]),
      );
      await tester.pumpWidget(
        BlocProvider.value(
          value: todosBloc,
          child: MaterialApp(
            home: Scaffold(
              body: DetailsScreen(id: '0'),
            ),
            localizationsDelegates: [
              ArchSampleLocalizationsDelegate(),
              FlutterBlocLocalizationsDelegate(),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ArchSampleKeys.editTodoFab));
      await tester.pumpAndSettle();
      expect(find.byKey(ArchSampleKeys.editTodoScreen), findsOneWidget);
      await tester.tap(find.byKey(ArchSampleKeys.taskField));
      await tester.enterText(find.byKey(ArchSampleKeys.taskField), 'new todo');
      await tester.tap(find.byKey(ArchSampleKeys.saveTodoFab));
      await tester.pumpAndSettle();
      verify(todosBloc.add(
        UpdateTodo(Todo('new todo', id: '0', complete: false)),
      )).called(1);
    });
  });
}
