part of stats;

Widget buildExtraActionsMenu(
    Dispatch<StatsMessage> dispatch, StatsModel model) {
  var allComplete = !model.items.any((x) => !x.complete);
  return menu.buildExtraActionsMenu(
      (act) => dispatch(_toMessage(act)), allComplete);
}

Widget view(
    BuildContext context, Dispatch<StatsMessage> dispatch, StatsModel model) {
  return model.loading
      ? new Center(
          key: ArchSampleKeys.statsLoading,
          child: new CircularProgressIndicator(
            key: ArchSampleKeys.statsLoading,
          ))
      : new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Padding(
                padding: new EdgeInsets.only(bottom: 8.0),
                child: new Text(
                  ArchSampleLocalizations.of(context).completedTodos,
                  style: Theme.of(context).textTheme.title,
                ),
              ),
              new Padding(
                padding: new EdgeInsets.only(bottom: 24.0),
                child: new Text(
                  '${model.completedCount}',
                  key: ArchSampleKeys.statsNumCompleted,
                  style: Theme.of(context).textTheme.subhead,
                ),
              ),
              new Padding(
                padding: new EdgeInsets.only(bottom: 8.0),
                child: new Text(
                  ArchSampleLocalizations.of(context).activeTodos,
                  style: Theme.of(context).textTheme.title,
                ),
              ),
              new Padding(
                padding: new EdgeInsets.only(bottom: 24.0),
                child: new Text(
                  "${model.activeCount}",
                  key: ArchSampleKeys.statsNumActive,
                  style: Theme.of(context).textTheme.subhead,
                ),
              )
            ],
          ),
        );
}

StatsMessage _toMessage(menu.ExtraAction action) {
  switch (action) {
    case menu.ExtraAction.toggleAll:
      return new ToggleAllMessage();
    case menu.ExtraAction.clearCompleted:
    default:
      return new CleareCompletedMessage();
  }
}