// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

abstract class MviDisposable {
  Future tearDown();
}

// A class that should contain a number of broadcast StreamControllers. These
// will act as the bridge between the View and the Presenter.
//
// The dispose method must be implemented and should `close` all
// StreamControllers
abstract class MviView implements MviDisposable {}

// A class that takes intents from the View and converts them into view
// state or side effects.
class MviPresenter<ViewModel> extends Stream<ViewModel>
    implements MviDisposable {
  final BehaviorSubject<ViewModel> _subject;
  final List<StreamSubscription<dynamic>> subscriptions = [];

  MviPresenter({
    @required Stream<ViewModel> stream,
    ViewModel initialModel,
  }) : _subject = _createSubject<ViewModel>(stream, initialModel);

  // Get the current state. Useful for initial renders or re-renders when we
  // have already fetched the data
  ViewModel get latest => _subject.value;

  void setUp() {}

  @mustCallSuper
  Future tearDown() => Future.wait(
      [_subject.close()]..addAll(subscriptions.map((s) => s.cancel())));

  static _createSubject<ViewState>(
    Stream<ViewState> model,
    ViewState initialState,
  ) {
    StreamSubscription<ViewState> subscription;
    BehaviorSubject<ViewState> _subject;
    void onListen() {
      subscription = model.listen(
        _subject.add,
        onError: _subject.addError,
        onDone: _subject.close,
      );
    }

    ;
    void onCancel() => subscription.cancel();

    _subject = initialState == null
        ? BehaviorSubject<ViewState>(
            onListen: onListen,
            onCancel: onCancel,
            sync: true,
          )
        : BehaviorSubject<ViewState>.seeded(
            initialState,
            onListen: onListen,
            onCancel: onCancel,
          );

    return _subject;
  }

  @override
  StreamSubscription<ViewModel> listen(
    void Function(ViewModel event) onData, {
    Function onError,
    void Function() onDone,
    bool cancelOnError,
  }) =>
      _subject.stream.listen(
        onData,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError,
      );
}
