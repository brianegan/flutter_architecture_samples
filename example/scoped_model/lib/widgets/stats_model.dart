import 'package:flutter/src/widgets/framework.dart';
import 'package:meta/meta.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:todos_repository/todos_repository.dart';

class StatsModel extends Model {
  TodosRepository repository;

  /// Wraps [ModelFinder.of] for this [Model]. See [ModelFinder.of] for more
  static StatsModel of(BuildContext context) =>
      new ModelFinder<StatsModel>().of(context);

  StatsModel({@required this.repository});
}
