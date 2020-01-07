// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';

class MobxLocalizations {
  static MobxLocalizations of(BuildContext context) {
    return Localizations.of<MobxLocalizations>(context, MobxLocalizations);
  }

  String get appTitle => 'Todos with MobX';
}

class MobxLocalizationsDelegate
    extends LocalizationsDelegate<MobxLocalizations> {
  @override
  Future<MobxLocalizations> load(Locale locale) =>
      Future(() => MobxLocalizations());

  @override
  bool shouldReload(MobxLocalizationsDelegate old) => false;

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode.toLowerCase().contains('en');
}
