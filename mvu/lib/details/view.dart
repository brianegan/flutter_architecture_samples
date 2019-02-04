part of details;

Widget view(BuildContext context, Dispatch<DetailsMessage> dispatch,
    DetailsModel model) {
  final localizations = ArchSampleLocalizations.of(context);

  return new Scaffold(
    key: ArchSampleKeys.todoDetailsScreen,
    appBar: new AppBar(
      title: new Text(localizations.todoDetails),
      actions: [
        new IconButton(
          tooltip: localizations.deleteTodo,
          icon: new Icon(Icons.delete),
          key: ArchSampleKeys.deleteTodoButton,
          onPressed: () => dispatch(new Remove()),
        )
      ],
    ),
    body: new Padding(
      padding: new EdgeInsets.all(16.0),
      child: new ListView(
        children: [
          new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              new Padding(
                padding: new EdgeInsets.only(right: 8.0),
                child: new Checkbox(
                  key: ArchSampleKeys.detailsTodoItemCheckbox,
                  value: model.todo.complete,
                  onChanged: (_) => dispatch(new ToggleCompleted()),
                ),
              ),
              new Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    new Padding(
                      padding: new EdgeInsets.only(
                        top: 8.0,
                        bottom: 16.0,
                      ),
                      child: new Text(
                        model.todo.task,
                        key: ArchSampleKeys.detailsTodoItemTask,
                        style: Theme.of(context).textTheme.headline,
                      ),
                    ),
                    new Text(
                      model.todo.note,
                      key: ArchSampleKeys.detailsTodoItemNote,
                      style: Theme.of(context).textTheme.subhead,
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    floatingActionButton: new FloatingActionButton(
      key: ArchSampleKeys.editTodoFab,
      tooltip: localizations.editTodo,
      child: new Icon(Icons.edit),
      onPressed: () => dispatch(Edit()),
    ),
  );
}
