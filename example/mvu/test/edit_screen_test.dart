import 'package:test/test.dart';

import 'package:mvu/edit/edit.dart';
import 'package:mvu/edit/types.dart';
import 'data.dart';

void main() {
  group('Edit screen ->', () {
    test('init', () {
      var todo = createTodos().first;
      var model = init(todo).model;

      expect(model.id, equals(todo.id));
      expect(model.note.text, equals(todo.note));
      expect(model.task.text, equals(todo.task));
    });

    test('OnSaved: model is not changed, has effects', () {
      var todo = createTodos().first;
      var model = init(todo).model;

      var upd = update(new OnSaved(todo), model);

      expect(upd.model, equals(model));
      expect(upd.effects, isNotEmpty);
    });

    test('Save: if task is empty no side effects', () {
      var model = init(null).model;

      var updateResult = update(new Save(), model);

      expect(updateResult.model, equals(model));
      expect(updateResult.effects, isEmpty);
    });

    test('Save: if task is not empty has side effects', () {
      var todo = createTodos().first;
      var model = init(todo).model;

      var updateResult = update(new Save(), model);

      expect(updateResult.model, equals(model));
      expect(updateResult.effects, isNotEmpty);
    });
  });
}
