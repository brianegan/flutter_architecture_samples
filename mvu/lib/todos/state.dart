part of todos;

Upd<TodosModel, TodosMessage> init(VisibilityFilter filter) {
  var model = TodosModel((b) => b
    ..isLoading = false
    ..filter = filter
    ..items = BuiltList<TodoModel>().toBuilder());
  return Upd(model, effects: Cmd.ofMsg(LoadTodos()));
}

Upd<TodosModel, TodosMessage> update(
    CmdRepository repo, TodosMessage msg, TodosModel model) {
  if (msg is LoadTodos) {
    return _loadTodos(repo, model);
  }
  if (msg is OnTodosLoaded) {
    return _onTodosLoaded(model, msg);
  }
  if (msg is OnTodosLoadError) {
    return _onLoadingError(model, msg);
  }
  if (msg is UpdateTodo) {
    return _toggleTodo(repo, model, msg);
  }
  if (msg is RemoveTodo) {
    var updatedModel = _removeTodo(model, msg.todo.id);
    return Upd(updatedModel, effects: repo.removeCmd(msg.todo.toEntity()));
  }
  if (msg is UndoRemoveItem) {
    var updatedModel = model.rebuild((b) => b.items.add(msg.item));
    return Upd(updatedModel, effects: _saveTodosCmd(repo, updatedModel));
  }
  if (msg is FilterChanged) {
    var updatedModel = model.rebuild((b) => b..filter = msg.value);
    return Upd(updatedModel);
  }
  if (msg is ToggleAllMessage) {
    return _toggleAll(repo, model, msg);
  }
  if (msg is CleareCompletedMessage) {
    var updatedModel = model.rebuild((b) => b.items.where((t) => !t.complete));
    return Upd(updatedModel, effects: _saveTodosCmd(repo, updatedModel));
  }
  if (msg is ShowDetailsMessage) {
    var navigateCmd = router.goToDetailsScreen<TodosMessage>(msg.todo);
    return Upd(model, effects: navigateCmd);
  }
  if (msg is OnTodoItemChanged) {
    return _onRepoEvent(model, msg);
  }
  return Upd(model);
}

Upd<TodosModel, TodosMessage> _loadTodos(CmdRepository repo, TodosModel model) {
  var loadCmd = repo.loadTodosCmd((items) => OnTodosLoaded(items),
      onError: (exc) => OnTodosLoadError(exc));
  var updatedModel = model.rebuild((b) => b
    ..isLoading = true
    ..loadingError = null);
  return Upd(updatedModel, effects: loadCmd);
}

Upd<TodosModel, TodosMessage> _onTodosLoaded(
    TodosModel model, OnTodosLoaded msg) {
  var updatedModel = model.rebuild((b) => b
    ..isLoading = false
    ..loadingError = null
    ..items.clear()
    ..items.addAll(msg.items.map(TodoModel.fromEntity)));
  return Upd(updatedModel);
}

Upd<TodosModel, TodosMessage> _onLoadingError(
    TodosModel model, OnTodosLoadError msg) {
  var updatedModel = model.rebuild((b) => b
    ..isLoading = false
    ..loadingError = msg.cause.toString());
  return Upd(updatedModel);
}

Upd<TodosModel, TodosMessage> _toggleTodo(
    CmdRepository repo, TodosModel model, UpdateTodo msg) {
  var updatedTodo = msg.todo.rebuild((b) => b..complete = msg.value);
  var updatedModel = _updateTodoItem(model, updatedTodo);
  return Upd(updatedModel, effects: _saveTodosCmd(repo, updatedModel));
}

Upd<TodosModel, TodosMessage> _toggleAll(
    CmdRepository repo, TodosModel model, ToggleAllMessage msg) {
  var setComplete = model.items.any((x) => !x.complete);
  var updatedModel = model.rebuild(
      (b) => b.items.map((t) => t.rebuild((x) => x..complete = setComplete)));
  return Upd(updatedModel, effects: _saveTodosCmd(repo, updatedModel));
}

TodosModel _removeTodo(TodosModel model, String id) =>
    model.rebuild((b) => b.items.where((x) => x.id != id));

Upd<TodosModel, TodosMessage> _onRepoEvent(
    TodosModel model, OnTodoItemChanged msg) {
  if (msg.updated != null) {
    var updatedTodo = TodoModel.fromEntity(msg.updated);
    return Upd(_updateTodoItem(model, updatedTodo));
  }
  if (msg.created != null) {
    var newItem = TodoModel.fromEntity(msg.created);
    var updatedModel = model.rebuild((b) => b.items.add(newItem));
    return Upd(updatedModel);
  }
  if (msg.removed != null) {
    var updatedModel = _removeTodo(model, msg.removed.id);
    return Upd(updatedModel,
        effects: snackbar.showUndoCmd<TodosMessage>(msg.removed.task,
            () => UndoRemoveItem(TodoModel.fromEntity(msg.removed))));
  }
  return Upd(model);
}

TodosModel _updateTodoItem(TodosModel model, TodoModel updatedTodo) {
  return model.rebuild(
      (b) => b.items.map((x) => x.id == updatedTodo.id ? updatedTodo : x));
}

Cmd<TodosMessage> _saveTodosCmd(CmdRepository repo, TodosModel model) =>
    repo.saveAllCmd(model.items.map((t) => t.toEntity()).toList());
