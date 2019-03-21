class ExtraActionsButtonViewModel {
  final bool allComplete;
  final bool hasCompletedTodos;

  ExtraActionsButtonViewModel(this.allComplete, this.hasCompletedTodos);
}

enum ExtraAction { toggleAllComplete, clearCompleted }
