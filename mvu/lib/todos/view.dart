part of todos;

Widget view(
    BuildContext context, Dispatch<TodosMessage> dispatch, TodosModel model) {
  return Container(
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
  final activeStyle = Theme.of(context)
      .textTheme
      .body1
      .copyWith(color: Theme.of(context).accentColor);

  return PopupMenuButton<VisibilityFilter>(
    key: ArchSampleKeys.filterButton,
    tooltip: ArchSampleLocalizations.of(context).filterTodos,
    onSelected: (val) => dispatch(FilterChanged(val)),
    itemBuilder: (BuildContext context) => <PopupMenuItem<VisibilityFilter>>[
      PopupMenuItem<VisibilityFilter>(
        key: ArchSampleKeys.allFilter,
        value: VisibilityFilter.all,
        child: Text(
          ArchSampleLocalizations.of(context).showAll,
          style:
              model.filter == VisibilityFilter.all ? activeStyle : defaultStyle,
        ),
      ),
      PopupMenuItem<VisibilityFilter>(
        key: ArchSampleKeys.activeFilter,
        value: VisibilityFilter.active,
        child: Text(
          ArchSampleLocalizations.of(context).showActive,
          style: model.filter == VisibilityFilter.active
              ? activeStyle
              : defaultStyle,
        ),
      ),
      PopupMenuItem<VisibilityFilter>(
        key: ArchSampleKeys.completedFilter,
        value: VisibilityFilter.completed,
        child: Text(
          ArchSampleLocalizations.of(context).showCompleted,
          style: model.filter == VisibilityFilter.completed
              ? activeStyle
              : defaultStyle,
        ),
      ),
    ],
    icon: Icon(Icons.filter_list),
  );
}

Widget _error(String error) {
  return Center(child: Text(error));
}

Widget _loading() {
  return Center(
      child: CircularProgressIndicator(
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

  return ListView.builder(
    key: ArchSampleKeys.todoList,
    itemCount: filteredList.length,
    itemBuilder: (BuildContext context, int index) =>
        _item(context, dispatch, filteredList[index], model),
  );
}

Widget _item(BuildContext context, Dispatch<TodosMessage> dispatch,
    TodoModel model, TodosModel todos) {
  return Dismissible(
    key: ArchSampleKeys.todoItem(model.id),
    onDismissed: (_) => dispatch(RemoveTodo(model)),
    child: ListTile(
      onTap: () => dispatch(ShowDetailsMessage(model)),
      leading: Checkbox(
        key: ArchSampleKeys.todoItemCheckbox(model.id),
        value: model.complete,
        onChanged: (val) => dispatch(UpdateTodo(val, model)),
      ),
      title: Text(
        model.task,
        key: ArchSampleKeys.todoItemTask(model.id),
        style: Theme.of(context).textTheme.title,
      ),
      subtitle: Text(
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
      return ToggleAllMessage();
    case menu.ExtraAction.clearCompleted:
    default:
      return CleareCompletedMessage();
  }
}
