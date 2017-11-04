import 'dart:async';

import 'package:flutter_driver/flutter_driver.dart';

abstract class TestScreen {
  final FlutterDriver driver;

  TestScreen(this.driver);

  Future<bool> isLoading({Duration timeout}) async {
    return !(await isReady(timeout: timeout));
  }

  Future<bool> isReady({Duration timeout});
}
