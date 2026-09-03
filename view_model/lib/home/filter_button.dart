import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';

import '../todo_list_state.dart';

class FilterButton extends StatelessWidget {
  final VisibilityFilter filter;
  final bool isActive;
  final ValueChanged<VisibilityFilter> onSelected;

  const FilterButton({
    super.key,
    required this.filter,
    required this.isActive,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isActive,
      child: AnimatedOpacity(
        opacity: isActive ? 1 : 0,
        duration: const Duration(milliseconds: 150),
        child: PopupMenuButton<VisibilityFilter>(
          key: ArchSampleKeys.filterButton,
          tooltip: ArchSampleLocalizations.of(context).filterTodos,
          initialValue: filter,
          onSelected: onSelected,
          itemBuilder: _items,
          icon: const Icon(Icons.filter_list),
        ),
      ),
    );
  }

  List<PopupMenuItem<VisibilityFilter>> _items(BuildContext context) {
    final activeStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: Theme.of(context).colorScheme.secondary,
    );
    final defaultStyle = Theme.of(context).textTheme.bodyMedium;

    Text label(String text, VisibilityFilter value) {
      return Text(text, style: filter == value ? activeStyle : defaultStyle);
    }

    final localizations = ArchSampleLocalizations.of(context);
    return [
      PopupMenuItem(
        key: ArchSampleKeys.allFilter,
        value: VisibilityFilter.all,
        child: label(localizations.showAll, VisibilityFilter.all),
      ),
      PopupMenuItem(
        key: ArchSampleKeys.activeFilter,
        value: VisibilityFilter.active,
        child: label(localizations.showActive, VisibilityFilter.active),
      ),
      PopupMenuItem(
        key: ArchSampleKeys.completedFilter,
        value: VisibilityFilter.completed,
        child: label(localizations.showCompleted, VisibilityFilter.completed),
      ),
    ];
  }
}
