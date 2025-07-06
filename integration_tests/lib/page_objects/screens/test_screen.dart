import 'package:flutter_test/flutter_test.dart';

abstract class TestScreen {
  final WidgetTester tester;

  TestScreen(this.tester);

  Future<bool> isLoading() async {
    return !(await isReady());
  }

  Future<bool> isReady();
}
