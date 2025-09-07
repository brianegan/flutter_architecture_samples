import 'package:bloc_library/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FlutterBlocLocalizations', () {
    late FlutterBlocLocalizations localizations;
    late FlutterBlocLocalizationsDelegate delegate;

    setUp(() {
      localizations = FlutterBlocLocalizations();
      delegate = FlutterBlocLocalizationsDelegate();
    });

    test('App Title is correct', () {
      expect(localizations.appTitle, 'Bloc Library Example');
    });

    test('shouldReload returns false', () {
      expect(delegate.shouldReload(FlutterBlocLocalizationsDelegate()), false);
    });

    test('isSupported returns true for english', () {
      expect(delegate.isSupported(Locale('en', 'US')), true);
    });

    test('isSupported returns false for french', () {
      expect(delegate.isSupported(Locale('fr', 'FR')), false);
    });
  });
}
