import 'package:test/test.dart';

import 'package:mvu/home/home.dart';
import 'package:mvu/home/types.dart';

void main() {
  group('Home screen ->', () {
    test('init', () {
      for (var tab in AppTab.values) {
        var initResult = init(tab);
        expect(initResult.model.body.tag, equals(tab));
      }
    });

    test('TabChangedMessage: tab is changed', () {
      var currentTab = AppTab.todos;
      var model = init(currentTab).model;
      expect(model.body.tag, equals(currentTab));

      currentTab = AppTab.stats;
      var updatedModel = update(TabChangedMessage(currentTab), model).model;
      expect(updatedModel.body.tag, equals(currentTab));

      currentTab = AppTab.todos;
      updatedModel = update(TabChangedMessage(currentTab), model).model;
      expect(updatedModel.body.tag, equals(currentTab));
    });

    test('TabChangedMessage: model is not changed if current and tab are same',
        () {
      var currentTab = AppTab.todos;
      var model = init(currentTab).model;
      expect(model.body.tag, equals(currentTab));
      var updatedModel = update(TabChangedMessage(currentTab), model).model;
      expect(updatedModel, equals(model));
    });
  });
}
