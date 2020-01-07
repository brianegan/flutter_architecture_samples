part of edit;

Upd<EditTodoModel, EditTodoMessage> init(TodoEntity todo) {
  var model = EditTodoModel((b) => b
    ..id = todo != null ? todo.id : ''
    ..note = TextEditingController(text: todo != null ? todo.note : '')
    ..task = TextEditingController(text: todo != null ? todo.task : ''));
  return Upd(model);
}

Upd<EditTodoModel, EditTodoMessage> update(
    CmdRepository repo, EditTodoMessage msg, EditTodoModel model) {
  if (msg is Save && model.task.text.isNotEmpty) {
    var updateCmd = model.id.isEmpty
        ? repo.createCmd((t) => OnSaved(t), model.task.text, model.note.text)
        : repo.updateDetailsCmd(
            (t) => OnSaved(t), model.id, model.task.text, model.note.text);
    return Upd(model, effects: updateCmd);
  }
  if (msg is OnSaved && msg.todo != null) {
    var navCmd = router.goBack<EditTodoMessage>();
    return Upd(model, effects: navCmd);
  }
  return Upd(model);
}
