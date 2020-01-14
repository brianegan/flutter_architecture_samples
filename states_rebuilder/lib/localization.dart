// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';

class StatesRebuilderLocalizations {
  static StatesRebuilderLocalizations of(BuildContext context) {
    return Localizations.of<StatesRebuilderLocalizations>(
      context,
      StatesRebuilderLocalizations,
    );
  }

  String get appTitle => 'States_rebuilder Example';
}

class StatesRebuilderLocalizationsDelegate
    extends LocalizationsDelegate<StatesRebuilderLocalizations> {
  @override
  Future<StatesRebuilderLocalizations> load(Locale locale) =>
      Future(() => StatesRebuilderLocalizations());

  @override
  bool shouldReload(StatesRebuilderLocalizationsDelegate old) => false;

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode.toLowerCase().contains('en');
}
