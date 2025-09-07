import 'package:mvi_base/mvi_base.dart';
import 'package:rxdart/rxdart.dart';

class StatsPresenter extends MviPresenter<StatsModel> {
  StatsPresenter(TodoListInteractor interactor)
    : super(
        initialModel: StatsModelLoading(),
        stream: Rx.combineLatest2(
          interactor.todos.map(_numActive),
          interactor.todos.map(_numComplete),
          (numActive, numComplete) =>
              StatsModelLoaded(numActive: numActive, numComplete: numComplete),
        ),
      );

  static int _numActive(List<Todo> todos) {
    return todos.fold(0, (sum, todo) => !todo.complete ? ++sum : sum);
  }

  static int _numComplete(List<Todo> todos) {
    return todos.fold(0, (sum, todo) => todo.complete ? ++sum : sum);
  }
}

sealed class StatsModel {}

class StatsModelLoading implements StatsModel {}

class StatsModelLoaded implements StatsModel {
  final int numActive;
  final int numComplete;

  StatsModelLoaded({required this.numActive, required this.numComplete});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatsModelLoaded &&
          runtimeType == other.runtimeType &&
          numActive == other.numActive &&
          numComplete == other.numComplete;

  @override
  int get hashCode => numActive.hashCode ^ numComplete.hashCode;

  @override
  String toString() {
    return 'StatsModelLoaded{numActive: $numActive, numComplete: $numComplete}';
  }
}
