part of home;

Upd<HomeModel, HomeMessage> init(AppTab currentTab) {
  var body = _initBody(currentTab);
  var model = new HomeModel((b) => b..body = body.model);
  return new Upd(model, effects: body.effects);
}

Upd<HomeModel, HomeMessage> update(HomeMessage msg, HomeModel model) {
  if (msg is TabChangedMessage) {
    if (msg.value == model.body.tag) {
      return new Upd(model);
    }

    var body = _initBody(msg.value);
    var updated = model.rebuild((b) => b..body = body.model);
    return new Upd(updated, effects: body.effects);
  }

  if (msg is CreateNewTodo) {
    var navCmd = router.goToCreateNewScreen<HomeMessage>();
    return Upd(model, effects: navCmd);
  }

  if (msg is OnNewTodoCreated) {
    if (model.body.tag == AppTab.todos) {
      return Upd(model,
          effects:
              new Cmd.ofMsg(TodosMsg(OnTodoItemChanged(created: msg.entity))));
    } else if (model.body.tag == AppTab.stats) {
      return Upd(model,
          effects: new Cmd.ofMsg(StatsMsg(OnNewTaskCreated(msg.entity))));
    }
  }

  if (msg is TodosMsg && model.body.tag == AppTab.todos) {
    var updatedTodos = todos.update(repoCmds, msg.message, model.body.model);
    var updatedModel =
        model.rebuild((b) => b..body = new TodosBody(updatedTodos.model));
    var effects = Cmd.fmap((m) => new TodosMsg(m), updatedTodos.effects);
    return new Upd(updatedModel, effects: effects);
  }

  if (msg is StatsMsg && model.body.tag == AppTab.stats) {
    var updatedStats = stats.update(repoCmds, msg.message, model.body.model);
    var updatedModel =
        model.rebuild((b) => b..body = new StatsBody(updatedStats.model));
    return new Upd(updatedModel,
        effects: Cmd.fmap((m) => new StatsMsg(m), updatedStats.effects));
  }
  return new Upd(model);
}

Upd<BodyModel, HomeMessage> _initBody(AppTab tag) {
  switch (tag) {
    case AppTab.todos:
      var initedTodos = todos.init(VisibilityFilter.all);
      return new Upd(new TodosBody(initedTodos.model),
          effects: Cmd.fmap((m) => new TodosMsg(m), initedTodos.effects));
    case AppTab.stats:
      var initedStats = stats.init();
      return new Upd(new StatsBody(initedStats.model),
          effects: Cmd.fmap((m) => new StatsMsg(m), initedStats.effects));
  }
  throw new ArgumentError.value(tag);
}
