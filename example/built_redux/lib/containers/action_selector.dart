import 'package:built_redux_sample/models/models.dart';
import 'package:built_redux_sample/actions/actions.dart';
import 'package:built_redux_sample/widgets/extra_actions_button.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';
import 'package:built_redux_sample/selectors/selectors.dart';

class ExtraActionSelector
    extends StoreConnector<AppState, AppStateBuilder, AppActions, bool> {
  ExtraActionSelector({Key key}) : super(key: key);

  @override
  bool connect(AppState state) {
    return allCompleteSelector(todosSelector(state));
  }

  @override
  Widget build(BuildContext context, bool allComplete, AppActions actions) {
    return new ExtraActionsButton(
      allComplete: allComplete,
      onSelected: (action) {
        if (action == ExtraAction.clearCompleted) {
          actions.clearCompletedAction();
        } else if (action == ExtraAction.toggleAllComplete) {
          actions.toggleAllAction();
        }
      },
    );
  }
}
