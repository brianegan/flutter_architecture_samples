import 'package:test/test.dart';

import 'package:mvu/details/details.dart';
import 'package:mvu/details/types.dart';
import 'package:mvu/common/todo_model.dart';
import 'data.dart';
import 'cmd_runner.dart';

void main() {
  group('Details screen ->', () {
    CmdRunner<DetailsMessage> _cmdRunner;
    TestTodosCmdRepository _cmdRepo;

    setUp(() {
      _cmdRunner = CmdRunner();
      _cmdRepo = TestTodosCmdRepository();
    });

    test('init', () {
      var todo = createTodos().map((x) => TodoModel.fromEntity(x)).first;
      var model = init(todo).model;

      expect(model.todo, equals(todo));
    });

    test('ToggleCompleted: todo state is changed', () {
      var todo = createTodos().map((x) => TodoModel.fromEntity(x)).first;
      var model = init(todo).model;

      final updResult = update(_cmdRepo, ToggleCompleted(), model);
      final updatedModel = updResult.model;
      _cmdRunner.run(updResult.effects);

      expect(updatedModel.todo.complete, isNot(todo.complete));
      expect(
          _cmdRepo.createdEffects,
          orderedEquals([
            predicate<RepoEffect>((x) =>
                x is SaveTodoEffect && x.entity == updatedModel.todo.toEntity())
          ]));
      expect(_cmdRunner.producedMessages, isEmpty);
    });

    test('Remove: model is not changed', () {
      var todo = createTodos().map((x) => TodoModel.fromEntity(x)).first;
      var model = init(todo).model;

      final updateResult = update(_cmdRepo, Remove(), model);
      final updatedModel = updateResult.model;
      _cmdRunner.run(updateResult.effects);

      expect(updatedModel, equals(model));
      expect(
          _cmdRepo.createdEffects,
          orderedEquals([
            predicate<RepoEffect>((x) =>
                x is RemoveTodoEffect &&
                x.entity == updatedModel.todo.toEntity())
          ]));
      expect(_cmdRunner.producedMessages, isEmpty);
    });

    test('Edit: model is not changed', () {
      var todo = createTodos().map((x) => TodoModel.fromEntity(x)).first;
      var model = init(todo).model;

      var updateResult = update(_cmdRepo, Edit(), model);

      expect(updateResult.model, equals(model));
      expect(updateResult.effects, isNotEmpty);
    });
  });
}
