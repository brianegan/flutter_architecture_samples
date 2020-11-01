// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';

class RvmsLocalizations {
  static RvmsLocalizations of(BuildContext context) {
    return Localizations.of<RvmsLocalizations>(context, RvmsLocalizations);
  }

  String get appTitle => 'rvms example';
}

class RvmsLocalizationsDelegate
    extends LocalizationsDelegate<RvmsLocalizations> {
  @override
  Future<RvmsLocalizations> load(Locale locale) =>
      Future(() => RvmsLocalizations());

  @override
  bool shouldReload(RvmsLocalizationsDelegate old) => false;

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode.toLowerCase().contains('en');
}
