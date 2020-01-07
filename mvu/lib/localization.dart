import 'dart:async';

import 'package:flutter/material.dart';

class MvuLocalizations {
  static MvuLocalizations of(BuildContext context) {
    return Localizations.of<MvuLocalizations>(
      context,
      MvuLocalizations,
    );
  }

  String get appTitle => 'MVU Example';
}

class MvuLocalizationsDelegate extends LocalizationsDelegate<MvuLocalizations> {
  @override
  Future<MvuLocalizations> load(Locale locale) =>
      Future(() => MvuLocalizations());

  @override
  bool shouldReload(MvuLocalizationsDelegate old) => false;

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode.toLowerCase().contains('en');
}
