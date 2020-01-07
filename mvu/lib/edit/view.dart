part of edit;

Widget view(BuildContext context, Dispatch<EditTodoMessage> dispatch,
    EditTodoModel model) {
  final localizations = ArchSampleLocalizations.of(context);
  final textTheme = Theme.of(context).textTheme;
  final isEditing = model.id.isNotEmpty;

  return Scaffold(
    key: ArchSampleKeys.editTodoScreen,
    appBar: AppBar(
      title: Text(
        isEditing ? localizations.editTodo : localizations.addTodo,
      ),
    ),
    body: Padding(
      padding: EdgeInsets.all(16.0),
      child: Form(
        autovalidate: true,
        child: ListView(
          children: [
            TextFormField(
              key: ArchSampleKeys.taskField,
              controller: model.task,
              autofocus: !isEditing,
              style: textTheme.headline,
              decoration: InputDecoration(
                hintText: localizations.newTodoHint,
              ),
              validator: (val) {
                return val.trim().isEmpty ? localizations.emptyTodoError : null;
              },
            ),
            TextFormField(
              key: ArchSampleKeys.noteField,
              controller: model.note,
              maxLines: 10,
              style: textTheme.subhead,
              decoration: InputDecoration(
                hintText: localizations.notesHint,
              ),
            )
          ],
        ),
      ),
    ),
    floatingActionButton: FloatingActionButton(
      key: isEditing ? ArchSampleKeys.saveTodoFab : ArchSampleKeys.saveNewTodo,
      tooltip: isEditing ? localizations.saveChanges : localizations.addTodo,
      child: Icon(isEditing ? Icons.check : Icons.add),
      onPressed: () => dispatch(Save()),
    ),
  );
}
