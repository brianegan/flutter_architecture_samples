// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_library/localization.dart';
import 'package:todos_app_core/todos_app_core.dart';
import 'package:bloc_library/widgets/tab_selector.dart';
import 'package:bloc_library/models/models.dart';

void main() {
  group('TabSelector', () {
    testWidgets('should render properly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(),
            bottomNavigationBar: TabSelector(
              onTabSelected: (_) => null,
              activeTab: AppTab.todos,
            ),
          ),
          localizationsDelegates: [
            ArchSampleLocalizationsDelegate(),
            FlutterBlocLocalizationsDelegate(),
          ],
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(ArchSampleKeys.todoTab), findsOneWidget);
      expect(find.byKey(ArchSampleKeys.statsTab), findsOneWidget);
    });

    testWidgets('should call onTabSelected with correct index when tab tapped',
        (WidgetTester tester) async {
      AppTab selectedTab;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(),
            bottomNavigationBar: TabSelector(
              onTabSelected: (appTab) {
                selectedTab = appTab;
              },
              activeTab: AppTab.todos,
            ),
          ),
          localizationsDelegates: [
            ArchSampleLocalizationsDelegate(),
            FlutterBlocLocalizationsDelegate(),
          ],
        ),
      );
      await tester.pumpAndSettle();
      final todoTabFinder = find.byKey(ArchSampleKeys.todoTab);
      final statsTabFinder = find.byKey(ArchSampleKeys.statsTab);
      expect(todoTabFinder, findsOneWidget);
      expect(statsTabFinder, findsOneWidget);
      await tester.tap(todoTabFinder);
      expect(selectedTab, AppTab.todos);
      await tester.tap(statsTabFinder);
      expect(selectedTab, AppTab.stats);
    });
  });
}
