import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';

class ExtraActionsButton extends StatelessWidget {
  final bool hasActiveTodos;
  final VoidCallback onClearCompleted;
  final VoidCallback onToggleAll;

  const ExtraActionsButton({
    super.key,
    required this.hasActiveTodos,
    required this.onClearCompleted,
    required this.onToggleAll,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ExtraAction>(
      key: ArchSampleKeys.extraActionsButton,
      onSelected: (action) {
        switch (action) {
          case ExtraAction.toggleAllComplete:
            onToggleAll();
          case ExtraAction.clearCompleted:
            onClearCompleted();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          key: ArchSampleKeys.toggleAll,
          value: ExtraAction.toggleAllComplete,
          child: Text(
            hasActiveTodos
                ? ArchSampleLocalizations.of(context).markAllComplete
                : ArchSampleLocalizations.of(context).markAllIncomplete,
          ),
        ),
        PopupMenuItem(
          key: ArchSampleKeys.clearCompleted,
          value: ExtraAction.clearCompleted,
          child: Text(ArchSampleLocalizations.of(context).clearCompleted),
        ),
      ],
    );
  }
}

enum ExtraAction { toggleAllComplete, clearCompleted }
