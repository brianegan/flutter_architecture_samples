import 'package:built_redux_sample/containers/typedefs.dart';
import 'package:built_redux_sample/models/models.dart';
import 'package:built_redux_sample/actions/actions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';

class AppLoading
    extends StoreConnector<AppState, AppStateBuilder, AppActions, bool> {
  final ViewModelBuilder<bool> builder;

  AppLoading({Key key, @required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context, bool state, AppActions actions) {
    return builder(context, state);
  }

  @override
  bool connect(AppState state) {
    return state.isLoading;
  }
}
