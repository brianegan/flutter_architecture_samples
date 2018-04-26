// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:build_runner/build_runner.dart';
import 'package:built_redux/generator.dart';
import 'package:built_value_generator/built_value_generator.dart';
import 'package:source_gen/source_gen.dart';

Future main(List<String> args) async {
  await watch([
    BuildAction(
        PartBuilder([
          BuiltValueGenerator(),
          BuiltReduxGenerator(),
        ]),
        'built_redux_sample',
        inputs: const ['lib/**/*.dart'])
  ], deleteFilesByDefault: true);
}
