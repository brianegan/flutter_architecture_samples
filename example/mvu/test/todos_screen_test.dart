import 'package:test/test.dart';
import 'package:built_collection/built_collection.dart';

import 'package:mvu/home/types.dart' show VisibilityFilter;
import 'package:mvu/common/todo_model.dart';
import 'package:mvu/todos/todos.dart';
import 'package:mvu/todos/types.dart';
import 'package:todos_repository/todos_repository.dart';

import 'data.dart';

void main() {
  group('Home screen "Todos" ->', () {
    test('init', () {
      for (var filter in VisibilityFilter.values) {
        var model = init(filter).model;
        expect(model.filter, equals(filter));
        expect(model.isLoading, isFalse);
        expect(model.loadingError, anyOf(isNull, isEmpty));
        expect(model.items, isEmpty);
      }
    });

    test('LoadTodos: model is in loading state', () {
      var model = init(VisibilityFilter.all).model;
      var updatedModel = _updateAndUnwrap(new LoadTodos(), model);
      expect(updatedModel.isLoading, isTrue);
    });

    test('OnTodosLoaded: todos are loaded', () {
      var model = init(VisibilityFilter.all).model;
      var items = createTodos();
      var updatedModel = _updateAndUnwrap(new OnTodosLoaded(items), model);
      expect(updatedModel.isLoading, isFalse);
      expect(updatedModel.items.map((x) => x.toEntity()), orderedEquals(items));
    });

    test('OnTodosLoadError: model is in error state', () {
      var model = init(VisibilityFilter.all).model;
      var cause = new Exception("No connection");
      var updatedModel = _updateAndUnwrap(new OnTodosLoadError(cause), model);
      expect(updatedModel.isLoading, isFalse);
      expect(updatedModel.loadingError, equals(cause.toString()));
    });

    test('UpdateTodo: toggle todo state', () {
      var items = createTodos().map((x) => TodoModel.fromEntity(x));
      var model = _createWith(items);

      for (var item in items) {
        var updatedModel =
            _updateAndUnwrap(new UpdateTodo(!item.complete, item), model);
        var updatedTodo =
            updatedModel.items.firstWhere((x) => x.id == item.id, orElse: null);
        expect(updatedModel.items.length, items.length);
        expect(updatedTodo, isNotNull);
        expect(updatedTodo.complete, equals(!item.complete));
      }
    });

    test('RemoveTodo: item is removed', () {
      var items = createTodos().map((x) => TodoModel.fromEntity(x));
      var model = _createWith(items);

      for (var item in items) {
        var updatedModel = _updateAndUnwrap(new RemoveTodo(item), model);
        expect(updatedModel.items, isNot(contains(item)));
      }
    });

    test('UndoRemoveItem: undo removing', () {
      var items = createTodos().map((x) => TodoModel.fromEntity(x));
      var model = _createWith(items);

      for (var itemToRemove in items) {
        var updatedModel = _updateAndUnwrap(new RemoveTodo(itemToRemove), model);
        expect(updatedModel.items, isNot(contains(itemToRemove)));
        var undoModel = _updateAndUnwrap(new UndoRemoveItem(itemToRemove), updatedModel);
        expect(undoModel.items, contains(itemToRemove));
      }
    });

    test('FilterChanged: model with provided filter', () {
      var currentFilter = VisibilityFilter.all;
      var model = init(currentFilter).model;
      expect(model.filter, equals(currentFilter));

      for (var filter in VisibilityFilter.values) {
        var updatedModel = _updateAndUnwrap(new FilterChanged(filter), model);
        expect(updatedModel.filter, equals(filter));
      }
    });

    test('ToggleAllMessage: mark all as complete', () {
      var items =
          createTodos(complete: false).map((x) => TodoModel.fromEntity(x));
      var model = _createWith(items);

      var updatedModel = _updateAndUnwrap(new ToggleAllMessage(), model);

      expect(updatedModel.items,
          everyElement(predicate<TodoModel>((x) => x.complete)));
    });

    test('ToggleAllMessage: mark all as incomplete', () {
      var items =
          createTodos(complete: true).map((x) => TodoModel.fromEntity(x));
      var model = _createWith(items);

      var updatedModel = _updateAndUnwrap(new ToggleAllMessage(), model);

      expect(updatedModel.items,
          everyElement(predicate<TodoModel>((x) => !x.complete)));
    });

    test('CleareCompletedMessage: remove all completed todos', () {
      var items = createTodos().map((x) => TodoModel.fromEntity(x));
      var model = _createWith(items);
      expect(model.items, anyElement(predicate<TodoModel>((x) => x.complete)));

      var updatedModel = _updateAndUnwrap(new CleareCompletedMessage(), model);

      expect(updatedModel.items,
          everyElement(predicate<TodoModel>((x) => !x.complete)));
    });

    test('ShowDetailsMessage: model is not changed', () {
      var items = createTodos().map((x) => TodoModel.fromEntity(x));
      var model = _createWith(items);

      var updatedModel =
          _updateAndUnwrap(new ShowDetailsMessage(items.first), model);

      expect(updatedModel, equals(model));
    });

    test('OnTodoItemChanged: item is updated', () {
      var items = createTodos().map((x) => TodoModel.fromEntity(x));
      var model = _createWith(items);

      var itemToUpdate = items.first.rebuild((b) => b
        ..complete = !b.complete
        ..note = b.note + 'v1'
        ..task = b.task + 'v1');

      var updatedModel = _updateAndUnwrap(
          new OnTodoItemChanged(updated: itemToUpdate.toEntity()), model);
      var updatedItem =
          updatedModel.items.firstWhere((x) => x.id == itemToUpdate.id);

      expect(itemToUpdate, equals(updatedItem));
    });

    test('OnTodoItemChanged: item is removed', () {
      var items = createTodos().map((x) => TodoModel.fromEntity(x));
      var model = _createWith(items);

      var itemToRemove = items.first;

      var updatedModel = _updateAndUnwrap(
          new OnTodoItemChanged(removed: itemToRemove.toEntity()), model);

      expect(updatedModel.items, isNot(contains(itemToRemove)));
    });

    test('OnTodoItemChanged: item is created', () {
      var items = createTodos().map((x) => TodoModel.fromEntity(x));
      var model = _createWith(items);

      var newItem = new TodoEntity('New one', '11234', 'some note', false);

      var updatedModel =
          _updateAndUnwrap(new OnTodoItemChanged(created: newItem), model);

      expect(updatedModel.items, contains(TodoModel.fromEntity(newItem)));
    });
  });
}

TodosModel _updateAndUnwrap(TodosMessage msg, TodosModel model) =>
    update(msg, model).model;

TodosModel _createWith(Iterable<TodoModel> items) => new TodosModel((b) => b
  ..filter = VisibilityFilter.all
  ..isLoading = false
  ..items = new BuiltList<TodoModel>(items).toBuilder());
