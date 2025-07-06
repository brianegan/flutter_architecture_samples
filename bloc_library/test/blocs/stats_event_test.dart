import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_library/blocs/blocs.dart';

void main() {
  group('StatsEvent', () {
    group('UpdateStats', () {
      test('toString returns correct value', () {
        expect(UpdateStats([]).toString(), 'UpdateStats { todos: [] }');
      });
    });
  });
}
