import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_sample/models.dart';
import 'package:redux_sample/actions.dart';

class TabSelectorViewModelViewModel {
  final AppTab activeTab;
  final Function(AppTab) onTabSelected;

  TabSelectorViewModelViewModel({
    @required this.activeTab,
    @required this.onTabSelected,
  });

  static TabSelectorViewModelViewModel fromStore(Store<AppState> store) {
    return new TabSelectorViewModelViewModel(
      activeTab: store.state.activeTab,
      onTabSelected: (tab) => store.dispatch(new UpdateTabAction(tab)),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TabSelectorViewModelViewModel &&
              runtimeType == other.runtimeType &&
              activeTab == other.activeTab;

  @override
  int get hashCode => activeTab.hashCode;
}

class TabSelector extends StatelessWidget {
  final ViewModelBuilder<TabSelectorViewModelViewModel> builder;

  TabSelector({Key key, @required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, TabSelectorViewModelViewModel>(
      distinct: true,
      converter: TabSelectorViewModelViewModel.fromStore,
      builder: builder,
    );
  }
}
