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
      ? Center(
          key: ArchSampleKeys.statsLoading,
          child: CircularProgressIndicator(
            key: ArchSampleKeys.statsLoading,
          ))
      : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  ArchSampleLocalizations.of(context).completedTodos,
                  style: Theme.of(context).textTheme.title,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 24.0),
                child: Text(
                  '${model.completedCount}',
                  key: ArchSampleKeys.statsNumCompleted,
                  style: Theme.of(context).textTheme.subhead,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  ArchSampleLocalizations.of(context).activeTodos,
                  style: Theme.of(context).textTheme.title,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 24.0),
                child: Text(
                  '${model.activeCount}',
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
      return ToggleAllMessage();
    case menu.ExtraAction.clearCompleted:
    default:
      return CleareCompletedMessage();
  }
}
