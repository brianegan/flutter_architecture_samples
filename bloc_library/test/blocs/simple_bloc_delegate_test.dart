// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_library/blocs/simple_bloc_delegate.dart';
import 'package:bloc/bloc.dart';
import 'dart:async';

List<String> printLog;

void main() {
  group('SimpleBlocDelegate', () {
    SimpleBlocDelegate delegate;

    setUp(() {
      delegate = SimpleBlocDelegate();
      printLog = <String>[];
    });

    test('onTransition prints Transition', overridePrint(() {
      delegate.onTransition(
        null,
        Transition<String, String>(
          currentState: 'A',
          event: 'E',
          nextState: 'B',
        ),
      );
      expect(
        printLog[0],
        'Transition { currentState: A, event: E, nextState: B }',
      );
    }));

    test('onError prints Error', overridePrint(() {
      delegate.onError(null, 'whoops', null);
      expect(
        printLog[0],
        'whoops',
      );
    }));

    test('onEvent prints Event', overridePrint(() {
      delegate.onEvent(null, 'event');
      expect(
        printLog[0],
        'event',
      );
    }));
  });
}

dynamic overridePrint(dynamic Function() testFn) => () {
      var spec = ZoneSpecification(print: (_, __, ___, String msg) {
        // Add to log instead of printing to stdout
        printLog.add(msg);
      });
      return Zone.current.fork(specification: spec).run<dynamic>(testFn);
    };
