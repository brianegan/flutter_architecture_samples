import 'package:built_redux_sample/data_model/models.dart';
import 'package:built_redux_sample/redux/actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';


typedef OnTabsSelected = void Function(int);

class TabSelector
    extends StoreConnector<AppState, AppStateBuilder, AppActions, AppTab> {
  TabSelector({Key key}) : super(key: key);

  @override
  AppTab connect(AppState state) => state.activeTab;

  @override
  Widget build(BuildContext context, AppTab activeTab, AppActions action) {
    return new BottomNavigationBar(
      key: ArchSampleKeys.tabs,
      currentIndex: AppTab.toIndex(activeTab),
      onTap: (index) {
        action.updateTabAction(AppTab.fromIndex(index));
      },
      items: AppTab.values.map((tab) {
        return new BottomNavigationBarItem(
          icon: new Icon(tab == AppTab.todos ? Icons.list : Icons.show_chart),
          title: new Text(tab == AppTab.stats
              ? ArchSampleLocalizations.of(context).stats
              : ArchSampleLocalizations.of(context).todos),
        );
      }).toList(),
    );
  }
}
