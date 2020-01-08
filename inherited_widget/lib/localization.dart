// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';

class InheritedWidgetLocalizations {
  static InheritedWidgetLocalizations of(BuildContext context) {
    return Localizations.of<InheritedWidgetLocalizations>(
        context, InheritedWidgetLocalizations);
  }

  String get appTitle => 'InheritedWidget Example';
}

class InheritedWidgetLocalizationsDelegate
    extends LocalizationsDelegate<InheritedWidgetLocalizations> {
  @override
  Future<InheritedWidgetLocalizations> load(Locale locale) =>
      Future(() => InheritedWidgetLocalizations());

  @override
  bool shouldReload(InheritedWidgetLocalizationsDelegate old) => false;

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode.toLowerCase().contains('en');
}
