import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_library/blocs/simple_bloc_observer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBloc extends Mock implements Bloc<dynamic, dynamic> {}

var printLog = <String>[];

void main() {
  group('$SimpleBlocObserver', () {
    late SimpleBlocObserver delegate;

    setUp(() {
      delegate = SimpleBlocObserver();
      printLog = <String>[];
    });

    test(
      'onTransition prints Transition',
      overridePrint(() {
        delegate.onTransition(
          MockBloc(),
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
      }),
    );

    test(
      'onError prints Error',
      overridePrint(() {
        delegate.onError(MockBloc(), 'whoops', StackTrace.empty);
        expect(printLog[0], 'whoops');
      }),
    );

    test(
      'onEvent prints Event',
      overridePrint(() {
        delegate.onEvent(MockBloc(), 'event');
        expect(printLog[0], 'event');
      }),
    );
  });
}

dynamic Function() overridePrint(void Function() testFn) => () {
  var spec = ZoneSpecification(
    print: (_, _, _, String msg) {
      // Add to log instead of printing to stdout
      printLog.add(msg);
    },
  );
  return Zone.current.fork(specification: spec).run<dynamic>(testFn);
};
