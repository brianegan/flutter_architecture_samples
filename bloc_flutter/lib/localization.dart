import 'dart:async';

import 'package:flutter/material.dart';

class BlocLocalizations {
  static BlocLocalizations of(BuildContext context) {
    return Localizations.of<BlocLocalizations>(context, BlocLocalizations)!;
  }

  String get appTitle => 'Bloc Example';
}

class BlocLocalizationsDelegate
    extends LocalizationsDelegate<BlocLocalizations> {
  @override
  Future<BlocLocalizations> load(Locale locale) =>
      Future(() => BlocLocalizations());

  @override
  bool shouldReload(BlocLocalizationsDelegate old) => false;

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode.toLowerCase().contains('en');
}
