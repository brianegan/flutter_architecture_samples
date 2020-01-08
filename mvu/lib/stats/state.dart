part of stats;

Upd<StatsModel, StatsMessage> init() {
  var model = StatsModel((b) => b
    ..items = BuiltList<TodoModel>().toBuilder()
    ..activeCount = 0
    ..completedCount = 0
    ..loading = false);
  return Upd(model, effects: Cmd.ofMsg(LoadStats()));
}

Upd<StatsModel, StatsMessage> update(
    CmdRepository repo, StatsMessage msg, StatsModel model) {
  if (msg is LoadStats) {
    var updatedModel = model.rebuild((b) => b..loading = true);
    var loadCmd = repo.loadTodosCmd((items) => OnStatsLoaded(items));
    return Upd(updatedModel, effects: loadCmd);
  }
  if (msg is OnStatsLoaded) {
    var updatedModel = _onItemsChanged(model, msg.todos);
    updatedModel = _calculateStats(updatedModel);
    updatedModel = updatedModel.rebuild((b) => b..loading = false);
    return Upd(updatedModel);
  }
  if (msg is ToggleAllMessage) {
    return _toggleAll(repo, model, msg);
  }
  if (msg is CleareCompletedMessage) {
    var updatedModel = model.rebuild((b) => b.items.where((t) => !t.complete));
    updatedModel = _calculateStats(updatedModel);
    return Upd(updatedModel, effects: _saveItems(repo, updatedModel));
  }
  if (msg is OnNewTaskCreated) {
    var updatedModel =
        model.rebuild((b) => b.items.add(TodoModel.fromEntity(msg.entity)));
    updatedModel = _calculateStats(updatedModel);
    return Upd(updatedModel);
  }
  return Upd(model);
}

StatsModel _onItemsChanged(StatsModel model, List<TodoEntity> newItems) {
  return model.rebuild((b) => b
    ..items.clear()
    ..items.addAll(newItems.map((x) => TodoModel.fromEntity(x))));
}

StatsModel _calculateStats(StatsModel model) {
  var completedCount =
      model.items.fold<int>(0, (acc, t) => t.complete ? acc + 1 : acc);
  var activeCount = model.items.length - completedCount;
  var updatedModel = model.rebuild((b) => b
    ..activeCount = activeCount
    ..completedCount = completedCount);
  return updatedModel;
}

Upd<StatsModel, StatsMessage> _toggleAll(
    CmdRepository repo, StatsModel model, ToggleAllMessage msg) {
  var setComplete = model.items.any((x) => !x.complete);
  var activeCount = setComplete ? 0 : model.items.length;
  var completedCount = setComplete ? model.items.length : 0;

  var updatedModel = model.rebuild((b) => b
    ..items.map((t) => t.rebuild((x) => x..complete = setComplete))
    ..activeCount = activeCount
    ..completedCount = completedCount);
  return Upd(updatedModel, effects: _saveItems(repo, updatedModel));
}

Cmd<StatsMessage> _saveItems(CmdRepository repo, StatsModel model) =>
    repo.saveAllCmd(model.items.map((x) => x.toEntity()).toList());
