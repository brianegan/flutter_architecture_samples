import 'package:built_collection/built_collection.dart';
import 'package:mvu/common/todo_model.dart';
import 'package:mvu/home/types.dart' show VisibilityFilter;
import 'package:mvu/todos/todos.dart';
import 'package:mvu/todos/types.dart';
import 'package:test/test.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

import 'cmd_runner.dart';
import 'data.dart';

CmdRunner<TodosMessage> _cmdRunner;
TestTodosCmdRepository _cmdRepo;

void main() {
  group('Home screen "Todos" ->', () {
    setUp(() {
      _cmdRunner = CmdRunner();
      _cmdRepo = TestTodosCmdRepository();
    });

    test('init', () {
      for (var filter in VisibilityFilter.values) {
        var initResult = init(filter);
        final model = initResult.model;
        _cmdRunner.run(initResult.effects);

        expect(model.filter, equals(filter));
        expect(model.isLoading, isFalse);
        expect(model.loadingError, anyOf(isNull, isEmpty));
        expect(model.items, isEmpty);
        expect(initResult.effects, isNotEmpty);
        expect(_cmdRunner.producedMessages,
            orderedEquals([TypeMatcher<LoadTodos>()]));

        _cmdRunner.invalidate();
      }
    });

    test('LoadTodos: model is in loading state', () {
      var model = init(VisibilityFilter.all).model;
      var upd = update(_cmdRepo, LoadTodos(), model);
      final updatedModel = upd.model;
      _cmdRunner.run(upd.effects);

      expect(updatedModel.isLoading, isTrue);
      expect(upd.effects, isNotEmpty);
      expect(_cmdRepo.createdEffects,
          orderedEquals([TypeMatcher<LoadTodosEffect>()]));
      expect(_cmdRunner.producedMessages,
          orderedEquals([TypeMatcher<OnTodosLoaded>()]));
    });

    test('OnTodosLoaded: todos are loaded', () {
      var model = init(VisibilityFilter.all).model;
      var items = createTodos();
      var upd = update(_cmdRepo, OnTodosLoaded(items), model);
      final updatedModel = upd.model;

      expect(updatedModel.isLoading, isFalse);
      expect(updatedModel.items.map((x) => x.toEntity()), orderedEquals(items));
      expect(upd.effects, isEmpty);
    });

    test('OnTodosLoadError: model is in error state', () {
      var model = init(VisibilityFilter.all).model;
      var cause = Exception('No connection');
      var upd = update(_cmdRepo, OnTodosLoadError(cause), model);
      final updatedModel = upd.model;

      expect(updatedModel.isLoading, isFalse);
      expect(updatedModel.loadingError, equals(cause.toString()));
      expect(upd.effects, isEmpty);
    });

    test('UpdateTodo: toggle todo state', () {
      var items = createTodos().map((x) => TodoModel.fromEntity(x));
      var model = _createWith(items);

      var repoEffectsMatchers = <Matcher>[];
      for (var item in items) {
        var upd = update(_cmdRepo, UpdateTodo(!item.complete, item), model);
        final updatedModel = upd.model;
        var updatedTodo = updatedModel.items.firstWhere(
          (x) => x.id == item.id,
          orElse: () => null,
        );
        _cmdRunner.run(upd.effects);

        expect(updatedModel.items.length, items.length);
        expect(updatedTodo, isNotNull);
        expect(updatedTodo.complete, equals(!item.complete));
        expect(upd.effects, isNotEmpty);
        repoEffectsMatchers.add(TypeMatcher<SaveAllTodosEffect>());
      }
      expect(_cmdRepo.createdEffects, orderedEquals(repoEffectsMatchers));
    });

    test('RemoveTodo: item is removed', () {
      var items = createTodos().map((x) => TodoModel.fromEntity(x));
      var model = _createWith(items);

      final repoEffectsMatchers = [];
      for (var item in items) {
        var upd = update(_cmdRepo, RemoveTodo(item), model);
        final updatedModel = upd.model;
        _cmdRunner.run(upd.effects);

        expect(updatedModel.items, isNot(contains(item)));
        repoEffectsMatchers.add(TypeMatcher<RemoveTodoEffect>());
      }
      expect(_cmdRepo.createdEffects, orderedEquals(repoEffectsMatchers));
    });

    test('UndoRemoveItem: undo removing', () {
      var items = createTodos().map((x) => TodoModel.fromEntity(x));
      var model = _createWith(items);

      for (var itemToRemove in items) {
        var upd = update(_cmdRepo, RemoveTodo(itemToRemove), model);
        final updatedModel = upd.model;
        expect(updatedModel.items, isNot(contains(itemToRemove)));
        final undoUpd =
            update(_cmdRepo, UndoRemoveItem(itemToRemove), updatedModel);
        final undoModel = undoUpd.model;
        expect(undoModel.items, contains(itemToRemove));
      }
    });

    test('FilterChanged: model with provided filter', () {
      var currentFilter = VisibilityFilter.all;
      var model = init(currentFilter).model;
      expect(model.filter, equals(currentFilter));

      for (var filter in VisibilityFilter.values) {
        var upd = update(_cmdRepo, FilterChanged(filter), model);
        expect(upd.model.filter, equals(filter));
      }
    });

    test('ToggleAllMessage: mark all as complete', () {
      var items =
          createTodos(complete: false).map((x) => TodoModel.fromEntity(x));
      var model = _createWith(items);

      var upd = update(_cmdRepo, ToggleAllMessage(), model);
      _cmdRunner.run(upd.effects);

      expect(upd.model.items,
          everyElement(predicate<TodoModel>((x) => x.complete)));
      expect(_cmdRepo.createdEffects,
          orderedEquals([TypeMatcher<SaveAllTodosEffect>()]));
    });

    test('ToggleAllMessage: mark all as incomplete', () {
      var items =
          createTodos(complete: true).map((x) => TodoModel.fromEntity(x));
      var model = _createWith(items);

      var upd = update(_cmdRepo, ToggleAllMessage(), model);

      expect(upd.model.items,
          everyElement(predicate<TodoModel>((x) => !x.complete)));
    });

    test('CleareCompletedMessage: remove all completed todos', () {
      var items = createTodos().map((x) => TodoModel.fromEntity(x));
      var model = _createWith(items);
      expect(model.items, anyElement(predicate<TodoModel>((x) => x.complete)));

      var upd = update(_cmdRepo, CleareCompletedMessage(), model);
      _cmdRunner.run(upd.effects);

      expect(upd.model.items,
          everyElement(predicate<TodoModel>((x) => !x.complete)));
      expect(_cmdRepo.createdEffects,
          orderedEquals([TypeMatcher<SaveAllTodosEffect>()]));
    });

    test('ShowDetailsMessage: model is not changed', () {
      var items = createTodos().map((x) => TodoModel.fromEntity(x));
      var model = _createWith(items);

      var upd = update(_cmdRepo, ShowDetailsMessage(items.first), model);

      expect(upd.model, equals(model));
    });

    test('OnTodoItemChanged: item is updated', () {
      var items = createTodos().map((x) => TodoModel.fromEntity(x));
      var model = _createWith(items);

      var itemToUpdate = items.first.rebuild((b) => b
        ..complete = !b.complete
        ..note = b.note + 'v1'
        ..task = b.task + 'v1');

      var upd = update(
          _cmdRepo, OnTodoItemChanged(updated: itemToUpdate.toEntity()), model);
      var updatedItem =
          upd.model.items.firstWhere((x) => x.id == itemToUpdate.id);

      expect(itemToUpdate, equals(updatedItem));
    });

    test('OnTodoItemChanged: item is removed', () {
      var items = createTodos().map((x) => TodoModel.fromEntity(x));
      var model = _createWith(items);

      var itemToRemove = items.first;

      var upd = update(
          _cmdRepo, OnTodoItemChanged(removed: itemToRemove.toEntity()), model);

      expect(upd.model.items, isNot(contains(itemToRemove)));
    });

    test('OnTodoItemChanged: item is created', () {
      var items = createTodos().map((x) => TodoModel.fromEntity(x));
      var model = _createWith(items);

      var newItem = TodoEntity('New one', '11234', 'some note', false);

      var upd = update(_cmdRepo, OnTodoItemChanged(created: newItem), model);

      expect(upd.model.items, contains(TodoModel.fromEntity(newItem)));
    });
  });
}

TodosModel _createWith(Iterable<TodoModel> items) => TodosModel((b) => b
  ..filter = VisibilityFilter.all
  ..isLoading = false
  ..items = BuiltList<TodoModel>(items).toBuilder());
