// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';

class FirestoreReduxLocalizations {
  static FirestoreReduxLocalizations of(BuildContext context) {
    return Localizations.of<FirestoreReduxLocalizations>(
      context,
      FirestoreReduxLocalizations,
    );
  }

  String get appTitle => 'Firestore Redux Example';
}

class FirestoreReduxLocalizationsDelegate
    extends LocalizationsDelegate<FirestoreReduxLocalizations> {
  @override
  Future<FirestoreReduxLocalizations> load(Locale locale) =>
      Future(() => FirestoreReduxLocalizations());

  @override
  bool shouldReload(FirestoreReduxLocalizationsDelegate old) => false;

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode.toLowerCase().contains('en');
}
