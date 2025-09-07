import 'dart:async';

import 'package:flutter/material.dart';

class SimpleBlocLocalizations {
  static SimpleBlocLocalizations of(BuildContext context) {
    return Localizations.of<SimpleBlocLocalizations>(
      context,
      SimpleBlocLocalizations,
    )!;
  }

  String get appTitle => 'Simple Bloc Example';
}

class SimpleBlocLocalizationsDelegate
    extends LocalizationsDelegate<SimpleBlocLocalizations> {
  @override
  Future<SimpleBlocLocalizations> load(Locale locale) =>
      Future(() => SimpleBlocLocalizations());

  @override
  bool shouldReload(SimpleBlocLocalizationsDelegate old) => false;

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode.toLowerCase().contains('en');
}
