import 'dart:async';

import 'package:flutter/material.dart';

class FrideosLocalizations {
  static FrideosLocalizations of(BuildContext context) {
    return Localizations.of<FrideosLocalizations>(
        context, FrideosLocalizations);
  }

  String get appTitle => 'Frideos Example';
}

class FrideosLocalizationsDelegate
    extends LocalizationsDelegate<FrideosLocalizations> {
  @override
  Future<FrideosLocalizations> load(Locale locale) =>
      Future(() => FrideosLocalizations());

  @override
  bool shouldReload(FrideosLocalizationsDelegate old) => false;

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode.toLowerCase().contains('en');
}
