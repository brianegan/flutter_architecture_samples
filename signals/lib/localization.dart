import 'dart:async';

import 'package:flutter/material.dart';

class SignalsLocalizations {
  static SignalsLocalizations of(BuildContext context) {
    return Localizations.of<SignalsLocalizations>(
      context,
      SignalsLocalizations,
    )!;
  }

  String get appTitle => 'Signals Example';
}

class SignalsLocalizationsDelegate
    extends LocalizationsDelegate<SignalsLocalizations> {
  @override
  Future<SignalsLocalizations> load(Locale locale) =>
      Future(() => SignalsLocalizations());

  @override
  bool shouldReload(SignalsLocalizationsDelegate old) => false;

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode.toLowerCase().contains('en');
}
