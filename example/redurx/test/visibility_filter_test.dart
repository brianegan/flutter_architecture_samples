import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:redurx_sample/models/visibility_filter.dart';
import 'package:test/test.dart';

void main() {
  group('VisibilityFilter', () {
    test('should have todos and stats values', () {
      expect(
          VisibilityFilter.values,
          equals(BuiltSet<VisibilityFilter>.from([
            VisibilityFilter.all,
            VisibilityFilter.active,
            VisibilityFilter.completed
          ])));
    });

    test('should have its value as literal', () {
      expect(VisibilityFilter.valueOf('all'), equals(VisibilityFilter.all));
      expect(
          VisibilityFilter.valueOf('active'), equals(VisibilityFilter.active));
      expect(VisibilityFilter.valueOf('completed'),
          equals(VisibilityFilter.completed));
    });

    test('should have a serializer', () {
      expect(VisibilityFilter.serializer,
          TypeMatcher<Serializer<VisibilityFilter>>());
    });
  });
}
