// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';

class BinderLocalizations {
  static BinderLocalizations of(BuildContext context) {
    return Localizations.of<BinderLocalizations>(context, BinderLocalizations);
  }

  String get appTitle => 'Binder Example';
}

class BinderLocalizationsDelegate
    extends LocalizationsDelegate<BinderLocalizations> {
  @override
  Future<BinderLocalizations> load(Locale locale) =>
      Future(() => BinderLocalizations());

  @override
  bool shouldReload(BinderLocalizationsDelegate old) => false;

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode.toLowerCase().contains('en');
}
