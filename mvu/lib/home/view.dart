part of home;

Widget view(
    BuildContext context, Dispatch<HomeMessage> dispatch, HomeModel model) {
  return Scaffold(
    key: ArchSampleKeys.homeScreen,
    appBar: AppBar(
      title: Text(MvuLocalizations().appTitle),
      actions: _getAppBarActions(context, dispatch, model.body),
    ),
    body: Builder(builder: (ctx) => _body(ctx, dispatch, model.body)),
    floatingActionButton: FloatingActionButton(
      key: ArchSampleKeys.addTodoFab,
      onPressed: () => dispatch(CreateNewTodo()),
      child: Icon(Icons.add),
      tooltip: ArchSampleLocalizations.of(context).addTodo,
    ),
    bottomNavigationBar: _bottomNavigation(context, dispatch, model.body.tag),
  );
}

List<Widget> _getAppBarActions(
    BuildContext context, Dispatch<HomeMessage> dispatch, BodyModel body) {
  if (body.tag == AppTab.todos) {
    var extraActions =
        todos.buildExtraActionsMenu((m) => dispatch(TodosMsg(m)), body.model);
    var filterMenu = todos.buildFilterMenu(
        context, (m) => dispatch(TodosMsg(m)), body.model);
    return [filterMenu, extraActions];
  }
  if (body.tag == AppTab.stats) {
    var extraActions =
        stats.buildExtraActionsMenu((m) => dispatch(StatsMsg(m)), body.model);
    return [extraActions];
  }
  return [Container()];
}

Widget _bottomNavigation(
    BuildContext context, Dispatch<HomeMessage> dispatch, AppTab current) {
  return BottomNavigationBar(
    key: ArchSampleKeys.tabs,
    currentIndex: AppTab.values.indexOf(current),
    onTap: ((i) => dispatch(TabChangedMessage(AppTab.values[i]))),
    items: AppTab.values.map((tab) {
      return BottomNavigationBarItem(
        icon: Icon(
          tab == AppTab.todos ? Icons.list : Icons.show_chart,
          key: tab == AppTab.todos
              ? ArchSampleKeys.todoTab
              : ArchSampleKeys.statsTab,
        ),
        title: Text(tab == AppTab.stats
            ? ArchSampleLocalizations.of(context).stats
            : ArchSampleLocalizations.of(context).todos),
      );
    }).toList(),
  );
}

Widget _body(
    BuildContext context, Dispatch<HomeMessage> dispatch, BodyModel body) {
  snackbar.init(context);
  switch (body.tag) {
    case AppTab.todos:
      return todos.view(context, (m) => dispatch(TodosMsg(m)), body.model);
    case AppTab.stats:
      return stats.view(context, (m) => dispatch(StatsMsg(m)), body.model);
  }
  return Text('Unknown tag: ${body.tag}');
}
