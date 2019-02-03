// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:mvi_base/src/models/models.dart';
import 'package:mvi_base/src/mvi_core.dart';
import 'package:mvi_base/src/todos_interactor.dart';

mixin DetailView implements MviView {
  final deleteTodo = StreamController<String>.broadcast(sync: true);

  final updateTodo = StreamController<Todo>.broadcast(sync: true);

  @override
  Future tearDown() {
    return Future.wait([
      deleteTodo.close(),
      updateTodo.close(),
    ]);
  }
}

class DetailPresenter extends MviPresenter<Todo> {
  final DetailView _view;
  final TodosInteractor _interactor;

  DetailPresenter({
    @required String id,
    @required DetailView view,
    @required TodosInteractor interactor,
  })  : _view = view,
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
