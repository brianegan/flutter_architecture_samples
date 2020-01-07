part of details;

Widget view(BuildContext context, Dispatch<DetailsMessage> dispatch,
    DetailsModel model) {
  final localizations = ArchSampleLocalizations.of(context);

  return Scaffold(
    key: ArchSampleKeys.todoDetailsScreen,
    appBar: AppBar(
      title: Text(localizations.todoDetails),
      actions: [
        IconButton(
          tooltip: localizations.deleteTodo,
          icon: Icon(Icons.delete),
          key: ArchSampleKeys.deleteTodoButton,
          onPressed: () => dispatch(Remove()),
        )
      ],
    ),
    body: Padding(
      padding: EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Checkbox(
                  key: ArchSampleKeys.detailsTodoItemCheckbox,
                  value: model.todo.complete,
                  onChanged: (_) => dispatch(ToggleCompleted()),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 8.0,
                        bottom: 16.0,
                      ),
                      child: Text(
                        model.todo.task,
                        key: ArchSampleKeys.detailsTodoItemTask,
                        style: Theme.of(context).textTheme.headline,
                      ),
                    ),
                    Text(
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
    floatingActionButton: FloatingActionButton(
      key: ArchSampleKeys.editTodoFab,
      tooltip: localizations.editTodo,
      child: Icon(Icons.edit),
      onPressed: () => dispatch(Edit()),
    ),
  );
}
