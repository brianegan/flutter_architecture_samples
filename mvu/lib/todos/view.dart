part of todos;

Widget view(
    BuildContext context, Dispatch<TodosMessage> dispatch, TodosModel model) {
  return new Container(
    child: model.loadingError != null
        ? _error(model.loadingError)
        : model.isLoading ? _loading() : _list(dispatch, model),
  );
}

Widget buildExtraActionsMenu(
    Dispatch<TodosMessage> dispatch, TodosModel model) {
  var allComplete = !model.items.any((x) => !x.complete);
  return menu.buildExtraActionsMenu(
      (act) => dispatch(_toMessage(act)), allComplete);
}

Widget buildFilterMenu(
    BuildContext context, Dispatch<TodosMessage> dispatch, TodosModel model) {
  final defaultStyle = Theme.of(context).textTheme.body1;
  final activeStyle = Theme
      .of(context)
      .textTheme
      .body1
      .copyWith(color: Theme.of(context).accentColor);

  return new PopupMenuButton<VisibilityFilter>(
    key: ArchSampleKeys.filterButton,
    tooltip: ArchSampleLocalizations.of(context).filterTodos,
    onSelected: (val) => dispatch(new FilterChanged(val)),
    itemBuilder: (BuildContext context) => <PopupMenuItem<VisibilityFilter>>[
          new PopupMenuItem<VisibilityFilter>(
            key: ArchSampleKeys.allFilter,
            value: VisibilityFilter.all,
            child: new Text(
              ArchSampleLocalizations.of(context).showAll,
              style: model.filter == VisibilityFilter.all
                  ? activeStyle
                  : defaultStyle,
            ),
          ),
          new PopupMenuItem<VisibilityFilter>(
            key: ArchSampleKeys.activeFilter,
            value: VisibilityFilter.active,
            child: new Text(
              ArchSampleLocalizations.of(context).showActive,
              style: model.filter == VisibilityFilter.active
                  ? activeStyle
                  : defaultStyle,
            ),
          ),
          new PopupMenuItem<VisibilityFilter>(
            key: ArchSampleKeys.completedFilter,
            value: VisibilityFilter.completed,
            child: new Text(
              ArchSampleLocalizations.of(context).showCompleted,
              style: model.filter == VisibilityFilter.completed
                  ? activeStyle
                  : defaultStyle,
            ),
          ),
        ],
    icon: new Icon(Icons.filter_list),
  );
}

Widget _error(String error) {
  return new Center(child: new Text(error));
}

Widget _loading() {
  return new Center(
      child: new CircularProgressIndicator(
    key: ArchSampleKeys.todosLoading,
  ));
}

Widget _list(Dispatch<TodosMessage> dispatch, TodosModel model) {
  var filteredList = model.items
      .where((x) =>
          model.filter == VisibilityFilter.all ||
          (model.filter == VisibilityFilter.completed
              ? x.complete
              : !x.complete))
      .toList();

  return new ListView.builder(
    key: ArchSampleKeys.todoList,
    itemCount: filteredList.length,
    itemBuilder: (BuildContext context, int index) =>
        _item(context, dispatch, filteredList[index], model),
  );
}

Widget _item(BuildContext context, Dispatch<TodosMessage> dispatch,
    TodoModel model, TodosModel todos) {
  return new Dismissible(
    key: ArchSampleKeys.todoItem(model.id),
    onDismissed: (_) => dispatch(new RemoveTodo(model)),
    child: new ListTile(
      onTap: () => dispatch(ShowDetailsMessage(model)),
      leading: new Checkbox(
        key: ArchSampleKeys.todoItemCheckbox(model.id),
        value: model.complete,
        onChanged: (val) => dispatch(new UpdateTodo(val, model)),
      ),
      title: new Text(
        model.task,
        key: ArchSampleKeys.todoItemTask(model.id),
        style: Theme.of(context).textTheme.title,
      ),
      subtitle: new Text(
        model.note,
        key: ArchSampleKeys.todoItemNote(model.id),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.subhead,
      ),
    ),
  );
}

TodosMessage _toMessage(menu.ExtraAction action) {
  switch (action) {
    case menu.ExtraAction.toggleAll:
      return new ToggleAllMessage();
    case menu.ExtraAction.clearCompleted:
    default:
      return new CleareCompletedMessage();
  }
}
