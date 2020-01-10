// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';

class ProviderLocalizations {
  static ProviderLocalizations of(BuildContext context) {
    return Localizations.of<ProviderLocalizations>(
        context, ProviderLocalizations);
  }

  String get appTitle => 'Provider Example';
}

class ProviderLocalizationsDelegate
    extends LocalizationsDelegate<ProviderLocalizations> {
  @override
  Future<ProviderLocalizations> load(Locale locale) =>
      Future(() => ProviderLocalizations());

  @override
  bool shouldReload(ProviderLocalizationsDelegate old) => false;

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode.toLowerCase().contains('en');
}
