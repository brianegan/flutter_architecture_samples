// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/rendering.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_library/blocs/blocs.dart';
import 'package:bloc_library/widgets/widgets.dart';
import 'package:bloc_library/models/models.dart';
import 'package:bloc_library/bloc_library_keys.dart';
import 'package:bloc_library/localization.dart';
import 'package:todos_app_core/todos_app_core.dart';

class MockTodosBloc extends Mock implements TodosBloc {}

class MockFilteredTodosBloc extends Mock implements FilteredTodosBloc {}

main() {
  group('FilteredTodos', () {
    TodosBloc todosBloc;
    FilteredTodosBloc filteredTodosBloc;

    setUp(() {
      todosBloc = MockTodosBloc();
      filteredTodosBloc = MockFilteredTodosBloc();
    });

    testWidgets('should show loading indicator when state is TodosLoading',
        (WidgetTester tester) async {
      when(filteredTodosBloc.currentState).thenAnswer(
        (_) => FilteredTodosLoading(),
      );
      await tester.pumpWidget(
        BlocProviderTree(
          blocProviders: [
            BlocProvider<TodosBloc>(bloc: todosBloc),
            BlocProvider<FilteredTodosBloc>(bloc: filteredTodosBloc),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: FilteredTodos(),
            ),
            localizationsDelegates: [
              ArchSampleLocalizationsDelegate(),
              FlutterBlocLocalizationsDelegate(),
            ],
          ),
        ),
      );
      await tester.pump(Duration(seconds: 1));
      expect(find.byKey(ArchSampleKeys.todosLoading), findsOneWidget);
    });

    testWidgets('should show empty container when state is null',
        (WidgetTester tester) async {
      when(filteredTodosBloc.currentState).thenAnswer(
        (_) => null,
      );
      await tester.pumpWidget(
        BlocProviderTree(
          blocProviders: [
            BlocProvider<TodosBloc>(bloc: todosBloc),
            BlocProvider<FilteredTodosBloc>(bloc: filteredTodosBloc),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: FilteredTodos(),
            ),
            localizationsDelegates: [
              ArchSampleLocalizationsDelegate(),
              FlutterBlocLocalizationsDelegate(),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(BlocLibraryKeys.filteredTodosEmptyContainer),
          findsOneWidget);
    });

    testWidgets(
        'should show empty list when state is TodosLoaded with no todos',
        (WidgetTester tester) async {
      when(todosBloc.currentState).thenAnswer((_) => TodosLoaded([]));
      when(filteredTodosBloc.currentState).thenAnswer(
        (_) => FilteredTodosLoaded([], VisibilityFilter.all),
      );
      await tester.pumpWidget(
        BlocProviderTree(
          blocProviders: [
            BlocProvider<TodosBloc>(bloc: todosBloc),
            BlocProvider<FilteredTodosBloc>(bloc: filteredTodosBloc),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: FilteredTodos(),
            ),
            localizationsDelegates: [
              ArchSampleLocalizationsDelegate(),
              FlutterBlocLocalizationsDelegate(),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      final todoListFinder = find.byKey(ArchSampleKeys.todoList);
      expect(todoListFinder, findsOneWidget);
      expect(
          (todoListFinder.evaluate().first.widget as ListView)
              .semanticChildCount,
          0);
    });

    testWidgets('should show todos when state is TodosLoaded with todos',
        (WidgetTester tester) async {
      when(todosBloc.currentState)
          .thenAnswer((_) => TodosLoaded([Todo('wash car')]));
      when(filteredTodosBloc.currentState).thenAnswer(
        (_) => FilteredTodosLoaded([Todo('wash car')], VisibilityFilter.all),
      );
      await tester.pumpWidget(
        BlocProviderTree(
          blocProviders: [
            BlocProvider<TodosBloc>(bloc: todosBloc),
            BlocProvider<FilteredTodosBloc>(bloc: filteredTodosBloc),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: FilteredTodos(),
            ),
            localizationsDelegates: [
              ArchSampleLocalizationsDelegate(),
              FlutterBlocLocalizationsDelegate(),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      final todoListFinder = find.byKey(ArchSampleKeys.todoList);
      expect(todoListFinder, findsOneWidget);
      expect(
          (todoListFinder.evaluate().first.widget as ListView)
              .semanticChildCount,
          1);
    });

    testWidgets('should dispatch OnCheckboxChanged when checkbox tapped',
        (WidgetTester tester) async {
      when(todosBloc.currentState)
          .thenAnswer((_) => TodosLoaded([Todo('wash car', id: '0')]));
      when(filteredTodosBloc.currentState).thenAnswer(
        (_) => FilteredTodosLoaded(
            [Todo('wash car', id: '0')], VisibilityFilter.all),
      );
      when(todosBloc
              .dispatch(UpdateTodo(Todo('wash car', id: '0', complete: true))))
          .thenReturn(null);
      await tester.pumpWidget(
        BlocProviderTree(
          blocProviders: [
            BlocProvider<TodosBloc>(bloc: todosBloc),
            BlocProvider<FilteredTodosBloc>(bloc: filteredTodosBloc),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: FilteredTodos(),
            ),
            localizationsDelegates: [
              ArchSampleLocalizationsDelegate(),
              FlutterBlocLocalizationsDelegate(),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      final todoFinder = find.byKey(ArchSampleKeys.todoItem('0'));
      expect(todoFinder, findsOneWidget);
      final checkboxFinder = find.byKey(ArchSampleKeys.todoItemCheckbox('0'));
      expect(checkboxFinder, findsOneWidget);
      await tester.tap(checkboxFinder);
      verify(
        todosBloc.dispatch(
          UpdateTodo(
            Todo('wash car', id: '0', complete: true),
          ),
        ),
      ).called(1);
    });

    testWidgets('should dispatch DeleteTodo when dismissed',
        (WidgetTester tester) async {
      when(todosBloc.currentState)
          .thenAnswer((_) => TodosLoaded([Todo('wash car', id: '0')]));
      when(filteredTodosBloc.currentState).thenAnswer(
        (_) => FilteredTodosLoaded(
            [Todo('wash car', id: '0')], VisibilityFilter.all),
      );
      when(todosBloc.dispatch(DeleteTodo(Todo('wash car', id: '0'))))
          .thenReturn(null);
      await tester.pumpWidget(
        BlocProviderTree(
          blocProviders: [
            BlocProvider<TodosBloc>(bloc: todosBloc),
            BlocProvider<FilteredTodosBloc>(bloc: filteredTodosBloc),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: FilteredTodos(),
            ),
            localizationsDelegates: [
              ArchSampleLocalizationsDelegate(),
              FlutterBlocLocalizationsDelegate(),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      final todoFinder = find.byKey(ArchSampleKeys.todoItem('0'));
      expect(todoFinder, findsOneWidget);
      await dismissElement(
        tester,
        todoFinder,
        gestureDirection: AxisDirection.right,
      );
      await tester.pumpAndSettle();
      verify(
        todosBloc.dispatch(
          DeleteTodo(
            Todo('wash car', id: '0'),
          ),
        ),
      ).called(1);
    });

    testWidgets('should dispatch AddTodo when dismissed and Undo Tapped',
        (WidgetTester tester) async {
      when(todosBloc.currentState)
          .thenAnswer((_) => TodosLoaded([Todo('wash car', id: '0')]));
      when(filteredTodosBloc.currentState).thenAnswer(
        (_) => FilteredTodosLoaded(
            [Todo('wash car', id: '0')], VisibilityFilter.all),
      );
      when(todosBloc.dispatch(DeleteTodo(Todo('wash car', id: '0'))))
          .thenReturn(null);
      when(todosBloc.dispatch(AddTodo(Todo('wash car', id: '0'))))
          .thenReturn(null);
      await tester.pumpWidget(
        BlocProviderTree(
          blocProviders: [
            BlocProvider<TodosBloc>(bloc: todosBloc),
            BlocProvider<FilteredTodosBloc>(bloc: filteredTodosBloc),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: FilteredTodos(),
            ),
            localizationsDelegates: [
              ArchSampleLocalizationsDelegate(),
              FlutterBlocLocalizationsDelegate(),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      final todoFinder = find.byKey(ArchSampleKeys.todoItem('0'));
      expect(todoFinder, findsOneWidget);
      await dismissElement(
        tester,
        todoFinder,
        gestureDirection: AxisDirection.right,
      );
      await tester.pumpAndSettle();
      verify(
        todosBloc.dispatch(
          DeleteTodo(
            Todo('wash car', id: '0'),
          ),
        ),
      ).called(1);
      expect(find.text('Undo'), findsOneWidget);
      await tester.tap(find.text('Undo'));
      verify(
        todosBloc.dispatch(
          AddTodo(
            Todo('wash car', id: '0'),
          ),
        ),
      ).called(1);
    });

    testWidgets('should Navigate to DetailsScreen when todo tapped',
        (WidgetTester tester) async {
      when(todosBloc.currentState)
          .thenAnswer((_) => TodosLoaded([Todo('wash car', id: '0')]));
      when(filteredTodosBloc.currentState).thenAnswer(
        (_) => FilteredTodosLoaded(
            [Todo('wash car', id: '0')], VisibilityFilter.all),
      );
      await tester.pumpWidget(
        BlocProviderTree(
          blocProviders: [
            BlocProvider<TodosBloc>(bloc: todosBloc),
            BlocProvider<FilteredTodosBloc>(bloc: filteredTodosBloc),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: FilteredTodos(),
            ),
            localizationsDelegates: [
              ArchSampleLocalizationsDelegate(),
              FlutterBlocLocalizationsDelegate(),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      final todoFinder = find.byKey(ArchSampleKeys.todoItem('0'));
      expect(todoFinder, findsOneWidget);
      await tester.tap(todoFinder);
      await tester.pumpAndSettle();
      expect(find.byKey(ArchSampleKeys.todoDetailsScreen), findsOneWidget);
    });

    testWidgets(
        'should dispatch DeleteTodo when todo deleted from DetailsScreen',
        (WidgetTester tester) async {
      when(todosBloc.currentState)
          .thenAnswer((_) => TodosLoaded([Todo('wash car', id: '0')]));
      when(filteredTodosBloc.currentState).thenAnswer(
        (_) => FilteredTodosLoaded(
            [Todo('wash car', id: '0')], VisibilityFilter.all),
      );
      when(todosBloc.dispatch(DeleteTodo(Todo('wash car', id: '0'))))
          .thenReturn(null);
      await tester.pumpWidget(
        BlocProviderTree(
          blocProviders: [
            BlocProvider<TodosBloc>(bloc: todosBloc),
            BlocProvider<FilteredTodosBloc>(bloc: filteredTodosBloc),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: FilteredTodos(),
            ),
            localizationsDelegates: [
              ArchSampleLocalizationsDelegate(),
              FlutterBlocLocalizationsDelegate(),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      final todoFinder = find.byKey(ArchSampleKeys.todoItem('0'));
      expect(todoFinder, findsOneWidget);
      await tester.tap(todoFinder);
      await tester.pumpAndSettle();
      expect(find.byKey(ArchSampleKeys.todoDetailsScreen), findsOneWidget);
      await tester.tap(find.byKey(ArchSampleKeys.deleteTodoButton));
      await tester.pumpAndSettle();
      verify(
        todosBloc.dispatch(
          DeleteTodo(
            Todo('wash car', id: '0'),
          ),
        ),
      ).called(1);
    });

    testWidgets(
        'should dispatch AddTodo when todo deleted from DetailsScreen and Undo Tapped',
        (WidgetTester tester) async {
      when(todosBloc.currentState)
          .thenAnswer((_) => TodosLoaded([Todo('wash car', id: '0')]));
      when(filteredTodosBloc.currentState).thenAnswer(
        (_) => FilteredTodosLoaded(
            [Todo('wash car', id: '0')], VisibilityFilter.all),
      );
      when(todosBloc.dispatch(DeleteTodo(Todo('wash car', id: '0'))))
          .thenReturn(null);
      when(todosBloc.dispatch(AddTodo(Todo('wash car', id: '0'))))
          .thenReturn(null);
      await tester.pumpWidget(
        BlocProviderTree(
          blocProviders: [
            BlocProvider<TodosBloc>(bloc: todosBloc),
            BlocProvider<FilteredTodosBloc>(bloc: filteredTodosBloc),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: FilteredTodos(),
            ),
            localizationsDelegates: [
              ArchSampleLocalizationsDelegate(),
              FlutterBlocLocalizationsDelegate(),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      final todoFinder = find.byKey(ArchSampleKeys.todoItem('0'));
      expect(todoFinder, findsOneWidget);
      await tester.tap(todoFinder);
      await tester.pumpAndSettle();
      expect(find.byKey(ArchSampleKeys.todoDetailsScreen), findsOneWidget);
      await tester.tap(find.byKey(ArchSampleKeys.deleteTodoButton));
      await tester.pumpAndSettle();
      verify(
        todosBloc.dispatch(
          DeleteTodo(
            Todo('wash car', id: '0'),
          ),
        ),
      ).called(1);
      await tester.tap(find.text('Undo'));
      verify(
        todosBloc.dispatch(
          AddTodo(
            Todo('wash car', id: '0'),
          ),
        ),
      ).called(1);
    });
  });
}

Future<void> dismissElement(
  WidgetTester tester,
  Finder finder, {
  @required AxisDirection gestureDirection,
}) async {
  Offset downLocation;
  Offset upLocation;
  switch (gestureDirection) {
    case AxisDirection.left:
      // getTopRight() returns a point that's just beyond itemWidget's right
      // edge and outside the Dismissible event listener's bounds.
      downLocation = tester.getTopRight(finder) + const Offset(-0.1, 0.0);
      upLocation = tester.getTopLeft(finder);
      break;
    case AxisDirection.right:
      // we do the same thing here to keep the test symmetric
      downLocation = tester.getTopLeft(finder) + const Offset(0.1, 0.0);
      upLocation = tester.getTopRight(finder);
      break;
    case AxisDirection.up:
      // getBottomLeft() returns a point that's just below itemWidget's bottom
      // edge and outside the Dismissible event listener's bounds.
      downLocation = tester.getBottomLeft(finder) + const Offset(0.0, -0.1);
      upLocation = tester.getTopLeft(finder);
      break;
    case AxisDirection.down:
      // again with doing the same here for symmetry
      downLocation = tester.getTopLeft(finder) + const Offset(0.1, 0.0);
      upLocation = tester.getBottomLeft(finder);
      break;
    default:
      fail('unsupported gestureDirection');
  }

  final TestGesture gesture = await tester.startGesture(downLocation);
  await gesture.moveTo(upLocation);
  await gesture.up();
}
