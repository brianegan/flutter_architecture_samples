import 'dart:async';

import 'package:flutter/material.dart';

class ReduRxLocalizations {
  static ReduRxLocalizations of(BuildContext context) {
    return Localizations.of<ReduRxLocalizations>(context, ReduRxLocalizations);
  }

  String get appTitle => "ReduRx Example";
}

class ReduRxLocalizationsDelegate
    extends LocalizationsDelegate<ReduRxLocalizations> {
  @override
  Future<ReduRxLocalizations> load(Locale locale) =>
      Future(() => ReduRxLocalizations());

  @override
  bool shouldReload(ReduRxLocalizationsDelegate old) => false;

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode.toLowerCase().contains("en");
}
