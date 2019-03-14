// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_library/blocs/todos/todos.dart';
import 'package:bloc_library/widgets/stats.dart';
import 'package:bloc_library/models/models.dart';
import 'package:bloc_library/bloc_library_keys.dart';
import 'package:bloc_library/localization.dart';
import 'package:todos_app_core/todos_app_core.dart';

class MockTodosBloc extends Mock implements TodosBloc {}

main() {
  group('Stats', () {
    TodosBloc todosBloc;

    setUp(() {
      todosBloc = MockTodosBloc();
    });

    testWidgets('should render LoadingIndicator when state is TodosLoading',
        (WidgetTester tester) async {
      when(todosBloc.currentState).thenAnswer((_) => TodosLoading());
      await tester.pumpWidget(
        BlocProvider(
          bloc: todosBloc,
          child: MaterialApp(
            home: Scaffold(
              body: Stats(),
            ),
            localizationsDelegates: [
              ArchSampleLocalizationsDelegate(),
              FlutterBlocLocalizationsDelegate(),
            ],
          ),
        ),
      );
      await tester.pump(Duration(seconds: 1));
      expect(find.byKey(BlocLibraryKeys.statsLoadingIndicator), findsOneWidget);
    });

    testWidgets(
        'should render empty stats container when state is TodosNotLoaded',
        (WidgetTester tester) async {
      when(todosBloc.currentState).thenAnswer((_) => TodosNotLoaded());
      await tester.pumpWidget(
        BlocProvider(
          bloc: todosBloc,
          child: MaterialApp(
            home: Scaffold(
              body: Stats(),
            ),
            localizationsDelegates: [
              ArchSampleLocalizationsDelegate(),
              FlutterBlocLocalizationsDelegate(),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(BlocLibraryKeys.emptyStatsContainer), findsOneWidget);
    });

    testWidgets(
        'should render correct stats when state is TodosLoaded and todos are empty',
        (WidgetTester tester) async {
      when(todosBloc.currentState).thenAnswer((_) => TodosLoaded([]));
      await tester.pumpWidget(
        BlocProvider(
          bloc: todosBloc,
          child: MaterialApp(
            home: Scaffold(
              body: Stats(),
            ),
            localizationsDelegates: [
              ArchSampleLocalizationsDelegate(),
              FlutterBlocLocalizationsDelegate(),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      final numActiveFinder = find.byKey(ArchSampleKeys.statsNumActive);
      final numCompletedFinder = find.byKey(ArchSampleKeys.statsNumCompleted);

      expect(numActiveFinder, findsOneWidget);
      expect((numActiveFinder.evaluate().first.widget as Text).data, '0');
      expect(numCompletedFinder, findsOneWidget);
      expect((numCompletedFinder.evaluate().first.widget as Text).data, '0');
    });

    testWidgets('should render correct stats when state is TodosLoaded',
        (WidgetTester tester) async {
      when(todosBloc.currentState).thenAnswer((_) => TodosLoaded([
            Todo('wash car'),
            Todo('clean garage', complete: true),
            Todo('walk dog'),
          ]));
      await tester.pumpWidget(
        BlocProvider(
          bloc: todosBloc,
          child: MaterialApp(
            home: Scaffold(
              body: Stats(),
            ),
            localizationsDelegates: [
              ArchSampleLocalizationsDelegate(),
              FlutterBlocLocalizationsDelegate(),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      final numActiveFinder = find.byKey(ArchSampleKeys.statsNumActive);
      final numCompletedFinder = find.byKey(ArchSampleKeys.statsNumCompleted);

      expect(numActiveFinder, findsOneWidget);
      expect((numActiveFinder.evaluate().first.widget as Text).data, '2');
      expect(numCompletedFinder, findsOneWidget);
      expect((numCompletedFinder.evaluate().first.widget as Text).data, '1');
    });
  });
}
