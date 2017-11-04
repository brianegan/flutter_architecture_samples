import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_sample/models/models.dart';
import 'package:redux_sample/selectors/selectors.dart';
import 'package:redux_sample/presentation/stats_counter.dart';

class StatsViewModel {
  final int numCompleted;
  final int numActive;

  StatsViewModel({@required this.numCompleted, @required this.numActive});

  static StatsViewModel fromStore(Store<AppState> store) {
    return new StatsViewModel(
      numActive: numActiveSelector(todosSelector(store.state)),
      numCompleted: numCompletedSelector(todosSelector(store.state)),
    );
  }
}

class Stats extends StatelessWidget {
  Stats({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, StatsViewModel>(
      converter: StatsViewModel.fromStore,
      builder: (context, vm) {
        return new StatsCounter(
          numActive: vm.numActive,
          numCompleted: vm.numCompleted,
        );
      },
    );
  }
}
