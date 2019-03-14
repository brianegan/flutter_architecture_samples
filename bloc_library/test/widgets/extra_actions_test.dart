// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:bloc_library/widgets/extra_actions.dart';
import 'package:bloc_library/blocs/todos/todos.dart';
import 'package:bloc_library/models/models.dart';
import 'package:bloc_library/bloc_library_keys.dart';
import 'package:bloc_library/localization.dart';
import 'package:todos_app_core/todos_app_core.dart';

class MockTodosBloc extends Mock implements TodosBloc {}

main() {
  group('ExtraActions', () {
    TodosBloc todosBloc;

    setUp(() {
      todosBloc = MockTodosBloc();
    });

    testWidgets('renders an empty Container if state is not TodosLoaded',
        (WidgetTester tester) async {
      when(todosBloc.currentState).thenReturn(TodosLoading());
      await tester.pumpWidget(
        BlocProvider(
          bloc: todosBloc,
          child: MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                actions: [ExtraActions()],
              ),
              body: Container(),
            ),
          ),
        ),
      );
      expect(find.byKey((BlocLibraryKeys.extraActionsEmptyContainer)),
          findsOneWidget);
    });

    testWidgets(
        'renders PopupMenuButton with mark all done if state is TodosLoaded with incomplete todos',
        (WidgetTester tester) async {
      when(todosBloc.currentState).thenReturn(TodosLoaded([Todo('walk dog')]));
      await tester.pumpWidget(
        BlocProvider(
          bloc: todosBloc,
          child: MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                actions: [ExtraActions()],
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
      await tester.tap(find.byKey(BlocLibraryKeys.extraActionsPopupMenuButton));
      await tester.pump();
      expect(find.byKey(ArchSampleKeys.toggleAll), findsOneWidget);
      expect(find.text('Clear completed'), findsOneWidget);
      expect(find.text('Mark all complete'), findsOneWidget);
    });

    testWidgets(
        'renders PopupMenuButton with mark all incomplete if state is TodosLoaded with complete todos',
        (WidgetTester tester) async {
      when(todosBloc.currentState)
          .thenReturn(TodosLoaded([Todo('walk dog', complete: true)]));
      await tester.pumpWidget(
        BlocProvider(
          bloc: todosBloc,
          child: MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                actions: [ExtraActions()],
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
      await tester.tap(find.byKey(BlocLibraryKeys.extraActionsPopupMenuButton));
      await tester.pump();
      expect(find.byKey(ArchSampleKeys.toggleAll), findsOneWidget);
      expect(find.text('Clear completed'), findsOneWidget);
      expect(find.text('Mark all incomplete'), findsOneWidget);
    });

    testWidgets('tapping clear completed dispatches ClearCompleted',
        (WidgetTester tester) async {
      when(todosBloc.currentState).thenReturn(TodosLoaded([
        Todo('walk dog'),
        Todo('take out trash', complete: true),
      ]));
      when(todosBloc.dispatch(ClearCompleted())).thenReturn(null);
      await tester.pumpWidget(
        BlocProvider(
          bloc: todosBloc,
          child: MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                actions: [ExtraActions()],
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
      await tester.tap(find.byKey(BlocLibraryKeys.extraActionsPopupMenuButton));
      await tester.pump();
      expect(find.byKey(ArchSampleKeys.clearCompleted), findsOneWidget);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ArchSampleKeys.clearCompleted));
      verify(todosBloc.dispatch(ClearCompleted())).called(1);
    });

    testWidgets('tapping toggle all dispatches ToggleAll',
        (WidgetTester tester) async {
      when(todosBloc.currentState).thenReturn(TodosLoaded([
        Todo('walk dog'),
        Todo('take out trash'),
      ]));
      when(todosBloc.dispatch(ToggleAll())).thenReturn(null);
      await tester.pumpWidget(
        BlocProvider(
          bloc: todosBloc,
          child: MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                actions: [ExtraActions()],
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
      await tester.tap(find.byKey(BlocLibraryKeys.extraActionsPopupMenuButton));
      await tester.pump();
      expect(find.byKey(ArchSampleKeys.toggleAll), findsOneWidget);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ArchSampleKeys.toggleAll));
      verify(todosBloc.dispatch(ToggleAll())).called(1);
    });
  });
}
