// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_library/localization.dart';
import 'package:flutter/material.dart';

void main() {
  group('FlutterBlocLocalizations', () {
    FlutterBlocLocalizations localizations;
    FlutterBlocLocalizationsDelegate delegate;

    setUp(() {
      localizations = FlutterBlocLocalizations();
      delegate = FlutterBlocLocalizationsDelegate();
    });

    test('App Title is correct', () {
      expect(localizations.appTitle, 'Bloc Library Example');
    });

    test('shouldReload returns false', () {
      expect(delegate.shouldReload(null), false);
    });

    test('isSupported returns true for english', () {
      expect(delegate.isSupported(Locale('en', 'US')), true);
    });

    test('isSupported returns false for french', () {
      expect(delegate.isSupported(Locale('fr', 'FR')), false);
    });
  });
}
