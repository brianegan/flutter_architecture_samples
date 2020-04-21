import 'package:states_rebuilder_sample/domain/entities/todo.dart';
import 'package:states_rebuilder_sample/service/common/enums.dart';

class FilteredTodos {
  final List<Todo> _todos;

  VisibilityFilter activeFilter = VisibilityFilter.all;

  FilteredTodos(this._todos);

  List<Todo> get todos {
    return _todos.where((todo) {
      if (activeFilter == VisibilityFilter.all) {
        return true;
      } else if (activeFilter == VisibilityFilter.active) {
        return !todo.complete;
      } else {
        return todo.complete;
      }
    }).toList();
  }
}
