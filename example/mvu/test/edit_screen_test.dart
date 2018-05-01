import 'package:test/test.dart';

import 'package:mvu/edit/edit.dart';
import 'package:mvu/edit/types.dart';
import 'cmd_runner.dart';
import 'data.dart';

void main() {
  group('Edit screen ->', () {
    CmdRunner<EditTodoMessage> _cmdRunner;
    TestTodosCmdRepository _cmdRepo;

    setUp(() {
      _cmdRunner = CmdRunner();
      _cmdRepo = TestTodosCmdRepository();
    });

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

      var upd = update(_cmdRepo, OnSaved(todo), model);

      expect(upd.model, equals(model));
      expect(upd.effects, isNotEmpty);
    });

    test('Save: if task is empty no side effects', () {
      var model = init(null).model;

      var updateResult = update(_cmdRepo, Save(), model);

      expect(updateResult.model, equals(model));
      expect(updateResult.effects, isEmpty);
    });

    test('Save: if task is not empty has side effects', () {
      var todo = createTodos().first;
      var model = init(todo).model;
      final updatedNote = todo.note + '_changed';
      final updatedTask = todo.task + '_changed';
      model.note.text = updatedNote;
      model.task.text = updatedTask;

      var updateResult = update(_cmdRepo, Save(), model);
      _cmdRunner.run(updateResult.effects);

      expect(updateResult.model, equals(model));
      expect(updateResult.effects, isNotEmpty);
      expect(
          _cmdRepo.createdEffects,
          orderedEquals([
            predicate<RepoEffect>((x) =>
                x is UpdateDetailsEffect &&
                x.id == model.id &&
                x.note == updatedNote &&
                x.task == updatedTask)
          ]));
      expect(
          _cmdRunner.producedMessages,
          orderedEquals([
            predicate<EditTodoMessage>((x) =>
                x is OnSaved &&
                x.todo.id == model.id &&
                x.todo.note == updatedNote &&
                x.todo.task == updatedTask)
          ]));
    });
  });
}
