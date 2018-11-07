import 'package:built_collection/built_collection.dart';
import 'package:redurx_sample/models/app_tab.dart';
import 'package:test/test.dart';

void main() {
  group('AppTab', () {
    test('should have todos and stats values', () {
      expect(AppTab.values,
          equals(BuiltSet<AppTab>.from([AppTab.todos, AppTab.stats])));
    });

    test('should have its value as literal', () {
      expect(AppTab.valueOf('todos'), equals(AppTab.todos));
      expect(AppTab.valueOf('stats'), equals(AppTab.stats));
    });

    test('should have proper indexes', () {
      expect(AppTab.fromIndex(0), equals(AppTab.todos));
      expect(AppTab.fromIndex(1), equals(AppTab.stats));

      expect(AppTab.toIndex(AppTab.todos), equals(0));
      expect(AppTab.toIndex(AppTab.stats), equals(1));
    });
  });
}
