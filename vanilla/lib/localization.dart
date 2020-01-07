// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';

class VanillaLocalizations {
  static VanillaLocalizations of(BuildContext context) {
    return Localizations.of<VanillaLocalizations>(
        context, VanillaLocalizations);
  }

  String get appTitle => 'Vanilla Example';
}

class VanillaLocalizationsDelegate
    extends LocalizationsDelegate<VanillaLocalizations> {
  @override
  Future<VanillaLocalizations> load(Locale locale) =>
      Future(() => VanillaLocalizations());

  @override
  bool shouldReload(VanillaLocalizationsDelegate old) => false;

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode.toLowerCase().contains('en');
}
