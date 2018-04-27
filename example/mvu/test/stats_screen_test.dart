import 'package:test/test.dart';

import 'package:mvu/stats/stats.dart';
import 'package:mvu/stats/types.dart';
import 'package:mvu/common/todo_model.dart';
import 'data.dart';

void main() {
  group('Home screen "Stats" ->', () {
    test('init', () {
      var model = init().model;

      expect(model.activeCount, 0);
      expect(model.completedCount, 0);
      expect(model.loading, isFalse);
    });

    test('LoadStats: model is in loading state', () {
      var model = init().model;

      var updatedModel = update(new LoadStats(), model).model;

      expect(updatedModel.loading, isTrue);
    });

    test('OnStatsLoaded: stats is displayed', () {
      var model = init().model;
      int activeCount = 5, completedCount = 8;
      var items = createTodosForStats(activeCount, completedCount);

      var updatedModel = update(new OnStatsLoaded(items), model).model;

      expect(updatedModel.loading, isFalse);
      expect(updatedModel.activeCount, activeCount);
      expect(updatedModel.completedCount, completedCount);
    });

    test('ToggleAllMessage(false->true): stats is updated', () {
      var model = init().model;
      var items = createTodos(complete: false);
      var updatedModel = update(OnStatsLoaded(items), model).model;

      updatedModel = update(ToggleAllMessage(), updatedModel).model;

      expect(updatedModel.activeCount, 0);
      expect(updatedModel.completedCount, items.length);
    });

    test('ToggleAllMessage(true->false): stats is updated', () {
      var model = init().model;
      var items = createTodos(complete: true);
      var updatedModel = update(OnStatsLoaded(items), model).model;

      updatedModel = update(ToggleAllMessage(), updatedModel).model;

      expect(updatedModel.activeCount, items.length);
      expect(updatedModel.completedCount, 0);
    });

    test('ToggleAllMessage(partailly): stats is updated', () {
      var model = init().model;
      int activeCount = 3, completedCount = 6;
      var items = createTodosForStats(activeCount, completedCount);
      var updatedModel = update(OnStatsLoaded(items), model).model;

      updatedModel = update(ToggleAllMessage(), updatedModel).model;

      expect(updatedModel.activeCount, 0);
      expect(updatedModel.completedCount, items.length);
      expect(updatedModel.items,
          everyElement(predicate<TodoModel>((x) => x.complete)));
    });

    test('CleareCompletedMessage: stats is updated', () {
      var model = init().model;
      int activeCount = 3, completedCount = 6;
      var items = createTodosForStats(activeCount, completedCount);
      var updatedModel = update(OnStatsLoaded(items), model).model;

      updatedModel = update(CleareCompletedMessage(), updatedModel).model;

      expect(updatedModel.activeCount, activeCount);
      expect(updatedModel.completedCount, 0);
      expect(updatedModel.items,
          everyElement(predicate<TodoModel>((x) => !x.complete)));
    });
  });
}
