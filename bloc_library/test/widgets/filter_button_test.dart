// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_library/blocs/filtered_todos/filtered_todos.dart';
import 'package:bloc_library/widgets/filter_button.dart';
import 'package:bloc_library/models/models.dart';
import 'package:bloc_library/localization.dart';
import 'package:todos_app_core/todos_app_core.dart';

class MockFilteredTodosBloc extends Mock implements FilteredTodosBloc {}

main() {
  group('FilterButton', () {
    FilteredTodosBloc filteredTodosBloc;

    setUp(() {
      filteredTodosBloc = MockFilteredTodosBloc();
    });

    testWidgets('should render properly with VisibilityFilter.all',
        (WidgetTester tester) async {
      when(filteredTodosBloc.currentState).thenAnswer(
        (_) => FilteredTodosLoaded([], VisibilityFilter.all),
      );
      await tester.pumpWidget(
        BlocProvider(
          bloc: filteredTodosBloc,
          child: MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                actions: [FilterButton(visible: true)],
              ),
              body: Container(),
            ),
            localizationsDelegates: [
              ArchSampleLocalizationsDelegate(),
              FlutterBlocLocalizationsDelegate(),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      Finder filterButtonFinder = find.byKey(ArchSampleKeys.filterButton);
      expect(filterButtonFinder, findsOneWidget);
      await tester.tap(filterButtonFinder);
      await tester.pumpAndSettle();
      expect(find.byKey(ArchSampleKeys.allFilter), findsOneWidget);
      expect(find.byKey(ArchSampleKeys.activeFilter), findsOneWidget);
    });

    testWidgets('should render properly VisibilityFilter.active',
        (WidgetTester tester) async {
      when(filteredTodosBloc.currentState).thenAnswer(
        (_) => FilteredTodosLoaded([], VisibilityFilter.active),
      );
      await tester.pumpWidget(
        BlocProvider(
          bloc: filteredTodosBloc,
          child: MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                actions: [FilterButton(visible: true)],
              ),
              body: Container(),
            ),
            localizationsDelegates: [
              ArchSampleLocalizationsDelegate(),
              FlutterBlocLocalizationsDelegate(),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      Finder filterButtonFinder = find.byKey(ArchSampleKeys.filterButton);
      expect(filterButtonFinder, findsOneWidget);
      await tester.tap(filterButtonFinder);
      await tester.pumpAndSettle();
      expect(find.byKey(ArchSampleKeys.allFilter), findsOneWidget);
      expect(find.byKey(ArchSampleKeys.activeFilter), findsOneWidget);
    });

    testWidgets('should render properly VisibilityFilter.completed',
        (WidgetTester tester) async {
      when(filteredTodosBloc.currentState).thenAnswer(
        (_) => FilteredTodosLoaded([], VisibilityFilter.completed),
      );
      await tester.pumpWidget(
        BlocProvider(
          bloc: filteredTodosBloc,
          child: MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                actions: [FilterButton(visible: true)],
              ),
              body: Container(),
            ),
            localizationsDelegates: [
              ArchSampleLocalizationsDelegate(),
              FlutterBlocLocalizationsDelegate(),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      Finder filterButtonFinder = find.byKey(ArchSampleKeys.filterButton);
      expect(filterButtonFinder, findsOneWidget);
      await tester.tap(filterButtonFinder);
      await tester.pumpAndSettle();
      expect(find.byKey(ArchSampleKeys.allFilter), findsOneWidget);
      expect(find.byKey(ArchSampleKeys.activeFilter), findsOneWidget);
    });

    testWidgets('should dispatch UpdateFilter when filter selected',
        (WidgetTester tester) async {
      when(filteredTodosBloc.currentState).thenAnswer(
        (_) => FilteredTodosLoaded([], VisibilityFilter.active),
      );
      when(filteredTodosBloc.dispatch(UpdateFilter(VisibilityFilter.all)))
          .thenReturn(null);
      await tester.pumpWidget(
        BlocProvider(
          bloc: filteredTodosBloc,
          child: MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                actions: [FilterButton(visible: true)],
              ),
              body: Container(),
            ),
            localizationsDelegates: [
              ArchSampleLocalizationsDelegate(),
              FlutterBlocLocalizationsDelegate(),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      Finder filterButtonFinder = find.byKey(ArchSampleKeys.filterButton);
      Finder allFilterFinder = find.byKey(ArchSampleKeys.allFilter);
      expect(filterButtonFinder, findsOneWidget);
      await tester.tap(filterButtonFinder);
      await tester.pumpAndSettle();
      expect(find.byKey(ArchSampleKeys.activeFilter), findsOneWidget);
      expect(allFilterFinder, findsOneWidget);

      await tester.tap(allFilterFinder);
      verify(filteredTodosBloc.dispatch(UpdateFilter(VisibilityFilter.all)))
          .called(1);
    });
  });
}
