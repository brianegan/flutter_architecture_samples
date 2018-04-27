part of edit;

Widget view(BuildContext context, Dispatch<EditTodoMessage> dispatch,
    EditTodoModel model) {
  final localizations = ArchSampleLocalizations.of(context);
  final textTheme = Theme.of(context).textTheme;
  final isEditing = model.id.isNotEmpty;

  return new Scaffold(
    key: ArchSampleKeys.editTodoScreen,
    appBar: new AppBar(
      title: new Text(
        isEditing ? localizations.editTodo : localizations.addTodo,
      ),
    ),
    body: new Padding(
      padding: new EdgeInsets.all(16.0),
      child: new Form(
        autovalidate: true,
        child: new ListView(
          children: [
            new TextFormField(
              controller: model.task,
              autofocus: !isEditing,
              style: textTheme.headline,
              decoration: new InputDecoration(
                hintText: localizations.newTodoHint,
              ),
              validator: (val) {
                return val.trim().isEmpty ? localizations.emptyTodoError : null;
              },
            ),
            new TextFormField(
              controller: model.note,
              maxLines: 10,
              style: textTheme.subhead,
              decoration: new InputDecoration(
                hintText: localizations.notesHint,
              ),
            )
          ],
        ),
      ),
    ),
    floatingActionButton: new FloatingActionButton(
      tooltip: isEditing ? localizations.saveChanges : localizations.addTodo,
      child: new Icon(isEditing ? Icons.check : Icons.add),
      onPressed: () => dispatch(new Save()),
    ),
  );
}
