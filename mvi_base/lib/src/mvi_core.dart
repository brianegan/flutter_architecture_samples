import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

abstract class MviDisposable {
  Future<void> tearDown();
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

  MviPresenter({required Stream<ViewModel> stream, ViewModel? initialModel})
    : _subject = _createSubject<ViewModel>(stream, initialModel);

  // Get the current state. Useful for initial renders or re-renders when we
  // have already fetched the data
  ViewModel get latest => _subject.value;

  void setUp() {}

  @override
  @mustCallSuper
  Future<void> tearDown() =>
      Future.wait([_subject.close(), ...subscriptions.map((s) => s.cancel())]);

  static BehaviorSubject<ViewState> _createSubject<ViewState>(
    Stream<ViewState> model,
    ViewState? initialState,
  ) {
    late StreamSubscription<ViewState> subscription;
    late BehaviorSubject<ViewState> subject;

    void onListen() {
      subscription = model.listen(
        subject.add,
        onError: subject.addError,
        onDone: subject.close,
      );
    }

    void onCancel() => subscription.cancel();

    subject = initialState == null
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

    return subject;
  }

  @override
  StreamSubscription<ViewModel> listen(
    void Function(ViewModel event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return _subject.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}
