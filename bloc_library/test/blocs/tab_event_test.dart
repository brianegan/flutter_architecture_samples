import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_library/blocs/blocs.dart';
import 'package:bloc_library/models/models.dart';

void main() {
  group('TabEvent', () {
    group('UpdateTab', () {
      test('toString returns correct value', () {
        expect(
          UpdateTab(AppTab.todos).toString(),
          'UpdateTab { tab: AppTab.todos }',
        );
      });
    });
  });
}
