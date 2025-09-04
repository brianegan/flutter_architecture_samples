import 'dart:async';

import 'package:mvi_base/src/models/models.dart';
import 'package:mvi_base/src/mvi_core.dart';
import 'package:mvi_base/src/todo_list_interactor.dart';

mixin DetailView implements MviView {
  final deleteTodo = StreamController<String>.broadcast(sync: true);

  final updateTodo = StreamController<Todo>.broadcast(sync: true);

  @override
  Future<void> tearDown() {
    return Future.wait([deleteTodo.close(), updateTodo.close()]);
  }
}

class DetailPresenter extends MviPresenter<Todo> {
  final DetailView _view;
  final TodoListInteractor _interactor;

  DetailPresenter({
    required String id,
    required DetailView view,
    required TodoListInteractor interactor,
  }) : _view = view,
       _interactor = interactor,
       super(stream: interactor.todo(id));

  @override
  void setUp() {
    subscriptions.addAll([
      _view.deleteTodo.stream.listen(_interactor.deleteTodo),
      _view.updateTodo.stream.listen(_interactor.updateTodo),
    ]);
  }
}
