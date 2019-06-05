// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_library/blocs/simple_bloc_delegate.dart';
import 'package:bloc/bloc.dart';
import 'dart:async';

var printLog;

main() {
  group('SimpleBlocDelegate', () {
    SimpleBlocDelegate delegate;

    setUp(() {
      delegate = SimpleBlocDelegate();
      printLog = [];
    });

    test('onTransition prints Transition', overridePrint(() {
      delegate.onTransition(
        Transition(currentState: 'A', event: 'E', nextState: 'B'),
      );
      expect(
        printLog[0],
        'Transition { currentState: A, event: E, nextState: B }',
      );
    }));

    test('onError prints Error', overridePrint(() {
      delegate.onError('whoops', null);
      expect(
        printLog[0],
        'whoops',
      );
    }));
  });
}

overridePrint(testFn()) => () {
      var spec = ZoneSpecification(print: (_, __, ___, String msg) {
        // Add to log instead of printing to stdout
        printLog.add(msg);
      });
      return Zone.current.fork(specification: spec).run(testFn);
    };
