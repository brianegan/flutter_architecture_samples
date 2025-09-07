import 'package:flutter_test/flutter_test.dart';

abstract class TestElement {
  final WidgetTester tester;

  TestElement(this.tester);
}
