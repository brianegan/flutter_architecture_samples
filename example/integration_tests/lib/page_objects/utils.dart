import 'dart:async';

import 'package:flutter_driver/flutter_driver.dart';

Future<bool> widgetExists(
    FlutterDriver driver,
    SerializableFinder finder, {
      Duration timeout,
    }) async {
  try {
    await driver.waitFor(finder, timeout: timeout);

    return true;
  } catch (_) {
    return false;
  }
}

Future<bool> widgetAbsent(
    FlutterDriver driver,
    SerializableFinder finder, {
      Duration timeout,
    }) async {
  try {
    await driver.waitForAbsent(finder, timeout: timeout);

    return true;
  } catch (_) {
    return false;
  }
}