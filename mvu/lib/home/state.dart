part of home;

Upd<HomeModel, HomeMessage> init(AppTab currentTab) {
  var body = _initBody(currentTab);
  var model = HomeModel((b) => b..body = body.model);
  return Upd(model, effects: body.effects);
}

Upd<HomeModel, HomeMessage> update(HomeMessage msg, HomeModel model) {
  if (msg is TabChangedMessage) {
    if (msg.value == model.body.tag) {
      return Upd(model);
    }

    var body = _initBody(msg.value);
    var updated = model.rebuild((b) => b..body = body.model);
    return Upd(updated, effects: body.effects);
  }

  if (msg is CreateNewTodo) {
    var navCmd = router.goToCreateNewScreen<HomeMessage>();
    return Upd(model, effects: navCmd);
  }

  if (msg is OnNewTodoCreated) {
    if (model.body.tag == AppTab.todos) {
      return Upd(model,
          effects: Cmd.ofMsg(TodosMsg(OnTodoItemChanged(created: msg.entity))));
    } else if (model.body.tag == AppTab.stats) {
      return Upd(model,
          effects: Cmd.ofMsg(StatsMsg(OnNewTaskCreated(msg.entity))));
    }
  }

  if (msg is TodosMsg && model.body.tag == AppTab.todos) {
    var updatedTodos = todos.update(repoCmds, msg.message, model.body.model);
    var updatedModel =
        model.rebuild((b) => b..body = TodosBody(updatedTodos.model));
    var effects = Cmd.fmap((m) => TodosMsg(m), updatedTodos.effects);
    return Upd(updatedModel, effects: effects);
  }

  if (msg is StatsMsg && model.body.tag == AppTab.stats) {
    var updatedStats = stats.update(repoCmds, msg.message, model.body.model);
    var updatedModel =
        model.rebuild((b) => b..body = StatsBody(updatedStats.model));
    return Upd(updatedModel,
        effects: Cmd.fmap((m) => StatsMsg(m), updatedStats.effects));
  }
  return Upd(model);
}

Upd<BodyModel, HomeMessage> _initBody(AppTab tag) {
  switch (tag) {
    case AppTab.todos:
      var initedTodos = todos.init(VisibilityFilter.all);
      return Upd(TodosBody(initedTodos.model),
          effects: Cmd.fmap((m) => TodosMsg(m), initedTodos.effects));
    case AppTab.stats:
      var initedStats = stats.init();
      return Upd(StatsBody(initedStats.model),
          effects: Cmd.fmap((m) => StatsMsg(m), initedStats.effects));
  }
  throw ArgumentError.value(tag);
}
