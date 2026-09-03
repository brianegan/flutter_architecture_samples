import 'dart:async';

import 'package:flutter/material.dart';

class ViewModelLocalizations {
  static ViewModelLocalizations of(BuildContext context) {
    return Localizations.of<ViewModelLocalizations>(
      context,
      ViewModelLocalizations,
    )!;
  }

  String get appTitle => 'ViewModel Example';
}

class ViewModelLocalizationsDelegate
    extends LocalizationsDelegate<ViewModelLocalizations> {
  @override
  Future<ViewModelLocalizations> load(Locale locale) {
    return Future.value(ViewModelLocalizations());
  }

  @override
  bool shouldReload(ViewModelLocalizationsDelegate old) => false;

  @override
  bool isSupported(Locale locale) {
    return locale.languageCode.toLowerCase().contains('en');
  }
}
