import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_sample/models.dart';

class StatsViewModel {
  final int numCompleted;
  final int numActive;

  StatsViewModel({@required this.numCompleted, @required this.numActive});

  static StatsViewModel fromStore(Store<AppState> store) {
    return new StatsViewModel(
      numActive: store.state.numActive,
      numCompleted: store.state.numCompleted,
    );
  }
}

class Stats extends StatelessWidget {
  final ViewModelBuilder<StatsViewModel> builder;

  Stats({Key key, @required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, StatsViewModel>(
      converter: StatsViewModel.fromStore,
      builder: builder,
    );
  }
}
