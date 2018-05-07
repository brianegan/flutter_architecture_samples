part of edit;

Upd<EditTodoModel, EditTodoMessage> init(TodoEntity todo) {
  var model = new EditTodoModel((b) => b
    ..id = todo != null ? todo.id : ""
    ..note = new TextEditingController(text: todo != null ? todo.note : "")
    ..task = new TextEditingController(text: todo != null ? todo.task : ""));
  return new Upd(model);
}

Upd<EditTodoModel, EditTodoMessage> update(
    CmdRepository repo, EditTodoMessage msg, EditTodoModel model) {
  if (msg is Save && model.task.text.isNotEmpty) {
    var updateCmd = model.id.isEmpty
        ? repo.createCmd((t) => OnSaved(t), model.task.text, model.note.text)
        : repo.updateDetailsCmd(
            (t) => OnSaved(t), model.id, model.task.text, model.note.text);
    return new Upd(model, effects: updateCmd);
  }
  if (msg is OnSaved && msg.todo != null) {
    var navCmd = router.goBack<EditTodoMessage>();
    return Upd(model, effects: navCmd);
  }
  return new Upd(model);
}
