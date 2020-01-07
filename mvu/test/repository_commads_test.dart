import 'package:test/test.dart';

import 'package:mvu/common/repository_commands.dart';
import 'package:todos_repository_core/todos_repository_core.dart';
import 'cmd_runner.dart';
import 'data.dart';

void main() {
  InMemoryTodosRepository todosRepository;
  CmdRepository brokenCmdRepository;
  CmdRepository cmdRepository;
  CmdRunner<Message> runner;
  setUp(() {
    todosRepository = InMemoryTodosRepository(initialItems: createTodos());
    brokenCmdRepository =
        TodosCmdRepository(InMemoryTodosRepository(isBrokern: true));
    cmdRepository = TodosCmdRepository(todosRepository);
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
        return null;
      }));

      runner.run(saveCmd);
    });

    test('remove todo', () {
      final itemToRemove = todosRepository.items.first;
      final cmd = cmdRepository.removeCmd<Message>(itemToRemove,
          onSuccess: expectAsync0(() {
        expect(todosRepository.items, isNot(contains(itemToRemove)));
        return null;
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
        return null;
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
        return null;
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
        return null;
      }), idToUpdate, task, note);

      runner.run(cmd);
    });
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
