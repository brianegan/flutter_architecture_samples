import 'dart:async';

import 'package:flutter/material.dart';

class VanillaLocalizations {
  static VanillaLocalizations of(BuildContext context) {
    return Localizations.of<VanillaLocalizations>(
        context, VanillaLocalizations);
  }

  String get appTitle => "Vanilla Example";
}

class VanillaLocalizationsDelegate
    extends LocalizationsDelegate<VanillaLocalizations> {
  @override
  Future<VanillaLocalizations> load(Locale locale) =>
      new Future(() => new VanillaLocalizations());

  @override
  bool shouldReload(VanillaLocalizationsDelegate old) => false;
}
