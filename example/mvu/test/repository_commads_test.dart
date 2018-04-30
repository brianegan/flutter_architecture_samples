import 'dart:async';

import 'package:dartea/dartea.dart';
import 'package:test/test.dart';

import 'package:mvu/common/repository_commands.dart';
import 'package:todos_repository/todos_repository.dart';
import 'data.dart';

void main() {
  InMemoryTodosRepository todosRepository;
  CmdRepository brokenCmdRepository;
  CmdRepository cmdRepository;
  CmdRunner<Message> runner;
  setUp(() {
    todosRepository = InMemoryTodosRepository(initialItems: createTodos());
    brokenCmdRepository =
        CmdRepository(InMemoryTodosRepository(isBrokern: true));
    cmdRepository = CmdRepository(todosRepository);
    runner = CmdRunner();
  });

  group('repository commands', () {
    test('load todos (success)', () {
      final loadCmd = cmdRepository.loadTodosCmd<Message>(expectAsync1((items) {
        expect(items, orderedEquals(todosRepository.items));
        return OnLoadSuccess(items);
      }), onError: expectAsync1((e) => OnLoadError(e), count: 0));

      runner.run(loadCmd);
    });

    test('load todos (error)', () {
      final loadCmd = brokenCmdRepository.loadTodosCmd<Message>(
          expectAsync1((items) => OnLoadSuccess(items), count: 0),
          onError: expectAsync1((e) => OnLoadError(e), count: 1));

      runner.run(loadCmd);
    });

    test('save todos', () {
      final items = todosRepository.items.take(3).toList();
      final saveCmd =
          cmdRepository.saveAllCmd<Message>(items, onSuccess: expectAsync0(() {
        expect(todosRepository.items, orderedEquals(items));
      }));

      runner.run(saveCmd);
    });

    test('remove todo', () {
      final itemToRemove = todosRepository.items.first;
      final cmd = cmdRepository.removeCmd<Message>(itemToRemove,
          onSuccess: expectAsync0(() {
        expect(todosRepository.items, isNot(contains(itemToRemove)));
      }));

      runner.run(cmd);
    });

    test('save todo', () {
      final firstItem = todosRepository.items.first;
      final updated = TodoEntity(
          firstItem.task, firstItem.id, firstItem.note, !firstItem.complete);

      final cmd =
          cmdRepository.saveCmd<Message>(updated, onSuccess: expectAsync0(() {
        expect(todosRepository.items, contains(updated));
      }));

      runner.run(cmd);
    });

    test('create todo', () {
      final task = 'Write unit tests';
      final note = 'and integration';

      final cmd = cmdRepository.createCmd<Message>(expectAsync1((x) {
        expect(
            todosRepository.items,
            anyElement(predicate<TodoEntity>(
                (x) => x.note == note && x.task == task && !x.complete)));
      }), task, note);

      runner.run(cmd);
    });

    test('update details', () {
      final idToUpdate = todosRepository.items.first.id;
      final task = 'Write unit tests';
      final note = 'and integration';

      final cmd = cmdRepository.updateDetailsCmd<Message>(expectAsync1((x) {
        expect(
            todosRepository.items,
            anyElement(predicate<TodoEntity>((x) =>
                x.id == idToUpdate && x.note == note && x.task == task)));
      }), idToUpdate, task, note);

      runner.run(cmd);
    });
  });
}

class InMemoryTodosRepository implements TodosRepository {
  List<TodoEntity> items = List();
  final bool isBrokern;
  InMemoryTodosRepository(
      {Iterable<TodoEntity> initialItems, this.isBrokern = false}) {
    if (initialItems != null) {
      items.addAll(initialItems);
    }
  }
  @override
  Future<List<TodoEntity>> loadTodos() {
    if (isBrokern) {
      throw Exception('repo is broken');
    }
    return Future.value(items.toList());
  }

  @override
  Future saveTodos(List<TodoEntity> todos) => Future.sync(() {
        items.clear();
        items.addAll(todos);
      });
}

abstract class Message {}

class OnLoadSuccess implements Message {
  final List<TodoEntity> items;
  OnLoadSuccess(this.items);
}

class OnLoadError implements Message {
  final Exception error;
  OnLoadError(this.error);
}

class OnSaveSuccess implements Message {}

class CmdRunner<T> {
  final List<T> producedMessages = List();
  void run(Cmd<T> cmd) {
    for (var effect in cmd) {
      effect((m) => producedMessages.add(m));
    }
  }
}
