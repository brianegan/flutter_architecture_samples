import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_sample/models.dart';
import 'package:redux_sample/actions.dart';

class ActionSelectorViewModel {
  final Function(ExtraAction) onActionSelected;
  final bool allComplete;

  ActionSelectorViewModel({
    @required this.onActionSelected,
    @required this.allComplete,
  });

  static ActionSelectorViewModel fromStore(Store<AppState> store) {
    return new ActionSelectorViewModel(
      onActionSelected: (action) {
        if (action == ExtraAction.clearCompleted) {
          store.dispatch(new ClearCompletedAction());
        } else if (action == ExtraAction.toggleAllComplete) {
          store.dispatch(new ToggleAllAction());
        }
      },
      allComplete: store.state.allComplete,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ActionSelectorViewModel &&
              runtimeType == other.runtimeType &&
              allComplete == other.allComplete;

  @override
  int get hashCode => allComplete.hashCode;
}

class ActionSelector extends StatelessWidget {
  final ViewModelBuilder<ActionSelectorViewModel> builder;

  ActionSelector({Key key, @required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, ActionSelectorViewModel>(
      distinct: true,
      converter: ActionSelectorViewModel.fromStore,
      builder: builder,
    );
  }
}
