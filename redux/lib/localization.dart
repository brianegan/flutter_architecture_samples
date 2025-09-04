import 'dart:async';

import 'package:flutter/material.dart';

class ReduxLocalizations {
  static ReduxLocalizations of(BuildContext context) {
    return Localizations.of<ReduxLocalizations>(context, ReduxLocalizations)!;
  }

  String get appTitle => 'Redux Example';
}

class ReduxLocalizationsDelegate
    extends LocalizationsDelegate<ReduxLocalizations> {
  @override
  Future<ReduxLocalizations> load(Locale locale) =>
      Future(() => ReduxLocalizations());

  @override
  bool shouldReload(ReduxLocalizationsDelegate old) => false;

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode.toLowerCase().contains('en');
}
