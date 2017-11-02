import 'dart:async';

import 'package:flutter/material.dart';

class BuiltReduxLocalizations {
  static BuiltReduxLocalizations of(BuildContext context) {
    return Localizations.of<BuiltReduxLocalizations>(
      context,
      BuiltReduxLocalizations,
    );
  }

  String get appTitle => "Built Redux Example";
}

class BuiltReduxLocalizationsDelegate
    extends LocalizationsDelegate<BuiltReduxLocalizations> {
  @override
  Future<BuiltReduxLocalizations> load(Locale locale) =>
      new Future(() => new BuiltReduxLocalizations());

  @override
  bool shouldReload(BuiltReduxLocalizationsDelegate old) => false;

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode.toLowerCase().contains("en");
}
