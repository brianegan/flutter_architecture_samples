import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:redurx_sample/models/app_state.dart';
import 'package:redurx_sample/models/app_tab.dart';
import 'package:redurx_sample/models/extra_actions.dart';
import 'package:redurx_sample/models/todo.dart';
import 'package:redurx_sample/models/visibility_filter.dart';

part 'serializers.g.dart';

@SerializersFor(const [
  AppTab,
  ExtraAction,
  VisibilityFilter,
  AppState,
  Todo,
])
final Serializers serializers = _$serializers;
