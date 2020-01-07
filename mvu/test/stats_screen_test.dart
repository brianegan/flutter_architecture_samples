import 'package:mvu/common/todo_model.dart';
import 'package:mvu/stats/stats.dart';
import 'package:mvu/stats/types.dart';
import 'package:test/test.dart';

import 'cmd_runner.dart';
import 'data.dart';

void main() {
  group('Home screen "Stats" ->', () {
    CmdRunner<StatsMessage> _cmdRunner;
    TestTodosCmdRepository _cmdRepo;

    setUp(() {
      _cmdRunner = CmdRunner();
      _cmdRepo = TestTodosCmdRepository();
    });

    test('init', () {
      final initResult = init();
      final model = initResult.model;
      final initEffects = initResult.effects;
      _cmdRunner.run(initEffects);

      expect(model.activeCount, 0);
      expect(model.completedCount, 0);
      expect(model.loading, isFalse);
      expect(initEffects, isNotEmpty);
      expect(_cmdRunner.producedMessages,
          orderedEquals([TypeMatcher<LoadStats>()]));
    });

    test('LoadStats: model is in loading state', () {
      var model = init().model;

      final upd = update(_cmdRepo, LoadStats(), model);
      final updatedModel = upd.model;
      final effects = upd.effects;
      _cmdRunner.run(effects);

      expect(updatedModel.loading, isTrue);
      expect(effects, isNotEmpty);
      expect(_cmdRunner.producedMessages,
          orderedEquals([TypeMatcher<OnStatsLoaded>()]));
      expect(_cmdRepo.createdEffects,
          orderedEquals([TypeMatcher<LoadTodosEffect>()]));
    });

    test('OnStatsLoaded: stats is displayed', () {
      var model = init().model;
      var activeCount = 5, completedCount = 8;
      var items = createTodosForStats(activeCount, completedCount);

      var updatedModel = update(_cmdRepo, OnStatsLoaded(items), model).model;

      expect(updatedModel.loading, isFalse);
      expect(updatedModel.activeCount, activeCount);
      expect(updatedModel.completedCount, completedCount);
    });

    test('ToggleAllMessage(false->true): stats is updated', () {
      var model = init().model;
      var items = createTodos(complete: false);
      var upd = update(_cmdRepo, OnStatsLoaded(items), model);
      var updatedModel = upd.model;
      upd = update(_cmdRepo, ToggleAllMessage(), updatedModel);
      updatedModel = upd.model;
      _cmdRunner.run(upd.effects);

      expect(updatedModel.activeCount, 0);
      expect(updatedModel.completedCount, items.length);
      expect(upd.effects, isNotEmpty);
      expect(_cmdRepo.createdEffects,
          orderedEquals([TypeMatcher<SaveAllTodosEffect>()]));
    });

    test('ToggleAllMessage(true->false): stats is updated', () {
      var model = init().model;
      var items = createTodos(complete: true);
      var updatedModel = update(_cmdRepo, OnStatsLoaded(items), model).model;

      updatedModel = update(_cmdRepo, ToggleAllMessage(), updatedModel).model;

      expect(updatedModel.activeCount, items.length);
      expect(updatedModel.completedCount, 0);
    });

    test('ToggleAllMessage(partially): stats is updated', () {
      var model = init().model;
      var activeCount = 3, completedCount = 6;
      var items = createTodosForStats(activeCount, completedCount);
      var updatedModel = update(_cmdRepo, OnStatsLoaded(items), model).model;

      updatedModel = update(_cmdRepo, ToggleAllMessage(), updatedModel).model;

      expect(updatedModel.activeCount, 0);
      expect(updatedModel.completedCount, items.length);
      expect(updatedModel.items,
          everyElement(predicate<TodoModel>((x) => x.complete)));
    });

    test('CleareCompletedMessage: stats is updated', () {
      var model = init().model;
      var activeCount = 3, completedCount = 6;
      var items = createTodosForStats(activeCount, completedCount);
      var updatedModel = update(_cmdRepo, OnStatsLoaded(items), model).model;

      final upd = update(_cmdRepo, CleareCompletedMessage(), updatedModel);
      updatedModel = upd.model;
      _cmdRunner.run(upd.effects);

      expect(updatedModel.activeCount, activeCount);
      expect(updatedModel.completedCount, 0);
      expect(updatedModel.items,
          everyElement(predicate<TodoModel>((x) => !x.complete)));
      expect(upd.effects, isNotEmpty);
      expect(_cmdRepo.createdEffects,
          orderedEquals([TypeMatcher<SaveAllTodosEffect>()]));
    });
  });
}
