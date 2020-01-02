// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:bloc_library/blocs/blocs.dart';
import 'package:bloc_library/blocs/tab/tab_bloc.dart';
import 'package:bloc_library/models/app_tab.dart';
import 'package:bloc_library/screens/screens.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_library/blocs/todos/todos.dart';
import 'package:bloc_library/screens/home_screen.dart';
import 'package:bloc_library/localization.dart';
import 'package:todos_app_core/todos_app_core.dart';

class MockTodosBloc extends MockBloc<TodosEvent, TodosState>
    implements TodosBloc {}

class MockFilteredTodosBloc
    extends MockBloc<FilteredTodosLoaded, FilteredTodosState>
    implements FilteredTodosBloc {}

class MockTabBloc extends MockBloc<TabEvent, AppTab> implements TabBloc {}

class MockStatsBloc extends MockBloc<StatsEvent, StatsState>
    implements StatsBloc {}

void main() {
  group('HomeScreen', () {
    TodosBloc todosBloc;
    FilteredTodosBloc filteredTodosBloc;
    TabBloc tabBloc;
    StatsBloc statsBloc;

    setUp(() {
      todosBloc = MockTodosBloc();
      filteredTodosBloc = MockFilteredTodosBloc();
      tabBloc = MockTabBloc();
      statsBloc = MockStatsBloc();
    });

    testWidgets('renders correctly', (WidgetTester tester) async {
      when(todosBloc.state).thenAnswer((_) => TodosLoaded([]));
      when(tabBloc.state).thenAnswer((_) => AppTab.todos);
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<TodosBloc>.value(
              value: todosBloc,
            ),
            BlocProvider<FilteredTodosBloc>.value(
              value: filteredTodosBloc,
            ),
            BlocProvider<TabBloc>.value(
              value: tabBloc,
            ),
            BlocProvider<StatsBloc>.value(
              value: statsBloc,
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: HomeScreen(),
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

    testWidgets('Navigates to /addTodo when Floating Action Button is tapped',
        (WidgetTester tester) async {
      when(todosBloc.state).thenAnswer((_) => TodosLoaded([]));
      when(tabBloc.state).thenAnswer((_) => AppTab.todos);
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<TodosBloc>.value(
              value: todosBloc,
            ),
            BlocProvider<FilteredTodosBloc>.value(
              value: filteredTodosBloc,
            ),
            BlocProvider<TabBloc>.value(
              value: tabBloc,
            ),
            BlocProvider<StatsBloc>.value(
              value: statsBloc,
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: HomeScreen(),
            ),
            localizationsDelegates: [
              ArchSampleLocalizationsDelegate(),
              FlutterBlocLocalizationsDelegate(),
            ],
            routes: {
              ArchSampleRoutes.addTodo: (context) {
                return AddEditScreen(
                  key: ArchSampleKeys.addTodoScreen,
                  onSave: (task, note) {},
                  isEditing: false,
                );
              },
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ArchSampleKeys.addTodoFab));
      await tester.pumpAndSettle();
      expect(find.byType(AddEditScreen), findsOneWidget);
    });
  });
}
