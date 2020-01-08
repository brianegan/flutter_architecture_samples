part of details;

Upd<DetailsModel, DetailsMessage> init(TodoModel todo) {
  var model = DetailsModel((b) => b..todo = todo.toBuilder());
  return Upd(model);
}

Upd<DetailsModel, DetailsMessage> update(
    CmdRepository repo, DetailsMessage msg, DetailsModel model) {
  if (msg is Remove) {
    var removeCmd = repo.removeCmd<DetailsMessage>(model.todo.toEntity());
    return Upd(model, effects: removeCmd);
  }
  if (msg is ToggleCompleted) {
    var updatedModel =
        model.rebuild((b) => b.todo.update((t) => t.complete = !t.complete));
    return Upd(updatedModel,
        effects: repo.saveCmd(updatedModel.todo.toEntity()));
  }
  if (msg is Edit) {
    var navigateCmd = router.goToEditTodoScreen<DetailsMessage>(model.todo);
    return Upd(model, effects: navigateCmd);
  }
  if (msg is OnTodoChanged &&
      msg.entity != null &&
      msg.entity.id == model.todo.id) {
    var updatedModel = model.rebuild((b) => b.todo
      ..complete = msg.entity.complete
      ..note = msg.entity.note
      ..task = msg.entity.task);
    return Upd(updatedModel);
  }
  if (msg is OnTodoRemoved &&
      msg.entity != null &&
      msg.entity.id == model.todo.id) {
    var navigateCmd = router.goBack<DetailsMessage>();
    return Upd(model, effects: navigateCmd);
  }
  return Upd(model);
}
