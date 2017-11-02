library serializers;

import 'package:built_redux_sample/data_model/models.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';

part 'serializers.g.dart';

@SerializersFor(const [
  AppTab,
  ExtraAction,
  VisibilityFilter,
  AppState,
  Todo,
])
final Serializers serializers = _$serializers;
