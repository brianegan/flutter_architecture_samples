import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:redurx_sample/models/app_state.dart';
import 'package:redurx_sample/models/app_tab.dart';

class UpdateTab implements Action<AppState> {
  final AppTab tab;

  UpdateTab(this.tab);

  @override
  AppState reduce(AppState state) {
    return state.rebuild((b) => b..activeTab = tab);
  }
}
