import 'package:test/test.dart';

import 'package:mvu/details/details.dart';
import 'package:mvu/details/types.dart';
import 'package:mvu/common/todo_model.dart';
import 'data.dart';

void main() {
  group('Details screen ->', () {
    test('init', () {
      var todo = createTodos().map((x)=>TodoModel.fromEntity(x)).first;
      var model = init(todo).model;

      expect(model.todo, equals(todo));
    });

    test('ToggleCompleted: todo state is changed', () {
      var todo = createTodos().map((x)=>TodoModel.fromEntity(x)).first;
      var model = init(todo).model;

      var updatedModel = update(new ToggleCompleted(), model).model;

      expect(updatedModel.todo.complete, isNot(todo.complete));
    });

    test('Remove: model is not changed', () {
      var todo = createTodos().map((x)=>TodoModel.fromEntity(x)).first;
      var model = init(todo).model;

      var updatedModel = update(new Remove(), model).model;

      expect(updatedModel, equals(model));
    });

    test('Edit: model is not changed', () {
      var todo = createTodos().map((x)=>TodoModel.fromEntity(x)).first;
      var model = init(todo).model;

      var updatedModel = update(new Edit(), model).model;

      expect(updatedModel, equals(model));
    });
  });
}
