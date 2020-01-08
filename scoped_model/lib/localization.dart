// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';

class ScopedModelLocalizations {
  static ScopedModelLocalizations of(BuildContext context) {
    return Localizations.of<ScopedModelLocalizations>(
        context, ScopedModelLocalizations);
  }

  String get appTitle => 'scoped_model example';
}

class ScopedModelLocalizationsDelegate
    extends LocalizationsDelegate<ScopedModelLocalizations> {
  @override
  Future<ScopedModelLocalizations> load(Locale locale) =>
      Future(() => ScopedModelLocalizations());

  @override
  bool shouldReload(ScopedModelLocalizationsDelegate old) => false;

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode.toLowerCase().contains('en');
}
