// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_library/blocs/todos/todos.dart';
import 'package:bloc_library/screens/home_screen.dart';
import 'package:bloc_library/widgets/widgets.dart';
import 'package:bloc_library/localization.dart';
import 'package:todos_app_core/todos_app_core.dart';

class MockTodosBloc extends Mock implements TodosBloc {}

main() {
  group('HomeScreen', () {
    TodosBloc todosBloc;

    setUp(() {
      todosBloc = MockTodosBloc();
    });

    testWidgets('renders correctly', (WidgetTester tester) async {
      when(todosBloc.state).thenAnswer((_) => Stream.empty());
      when(todosBloc.currentState).thenAnswer((_) => TodosLoaded([]));
      await tester.pumpWidget(
        BlocProvider(
          bloc: todosBloc,
          child: MaterialApp(
            home: Scaffold(
              body: HomeScreen(
                onInit: () {},
              ),
            ),
            localizationsDelegates: [
              ArchSampleLocalizationsDelegate(),
              FlutterBlocLocalizationsDelegate(),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(ArchSampleKeys.addTodoFab), findsOneWidget);
      expect(find.text('Bloc Library Example'), findsOneWidget);
    });

    testWidgets('calls onInit', (WidgetTester tester) async {
      when(todosBloc.state).thenAnswer((_) => Stream.empty());
      when(todosBloc.currentState).thenAnswer((_) => TodosLoaded([]));
      var onInitCalled = false;
      await tester.pumpWidget(
        BlocProvider(
          bloc: todosBloc,
          child: MaterialApp(
            home: Scaffold(
              body: HomeScreen(
                onInit: () {
                  onInitCalled = true;
                },
              ),
            ),
            localizationsDelegates: [
              ArchSampleLocalizationsDelegate(),
              FlutterBlocLocalizationsDelegate(),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(onInitCalled, true);
    });

    testWidgets('Navigates to /addTodo when Floating Action Button is tapped',
        (WidgetTester tester) async {
      when(todosBloc.state).thenAnswer((_) => Stream.empty());
      when(todosBloc.currentState).thenAnswer((_) => TodosLoaded([]));
      final Key addTodoContainer = Key('add_todo_container');
      await tester.pumpWidget(
        BlocProvider(
          bloc: todosBloc,
          child: MaterialApp(
            localizationsDelegates: [
              ArchSampleLocalizationsDelegate(),
              FlutterBlocLocalizationsDelegate(),
            ],
            routes: {
              ArchSampleRoutes.home: (context) {
                return Scaffold(
                  body: HomeScreen(
                    onInit: () {},
                  ),
                );
              },
              ArchSampleRoutes.addTodo: (context) {
                return Container(key: addTodoContainer);
              }
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ArchSampleKeys.addTodoFab));
      await tester.pumpAndSettle();
      expect(find.byKey(addTodoContainer), findsOneWidget);
    });
  });
}
