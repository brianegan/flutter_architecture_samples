import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:signals_sample/todo_list_controller.dart';
import 'package:todos_app_core/todos_app_core.dart';

class FilterButton extends StatelessWidget {
  final bool isActive;

  const FilterButton({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TodoListController>();

    return IgnorePointer(
      ignoring: !isActive,
      child: AnimatedOpacity(
        opacity: isActive ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 150),
        child: Watch((context) {
          return PopupMenuButton<VisibilityFilter>(
            key: ArchSampleKeys.filterButton,
            tooltip: ArchSampleLocalizations.of(context).filterTodos,
            initialValue: controller.filter.value,
            onSelected: (filter) => controller.filter.value = filter,
            itemBuilder: (BuildContext context) => _items(context, controller),
            icon: const Icon(Icons.filter_list),
          );
        }),
      ),
    );
  }

  List<PopupMenuItem<VisibilityFilter>> _items(
    BuildContext context,
    TodoListController controller,
  ) {
    final activeStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: Theme.of(context).colorScheme.secondary,
    );
    final defaultStyle = Theme.of(context).textTheme.bodyMedium;

    return [
      PopupMenuItem<VisibilityFilter>(
        key: ArchSampleKeys.allFilter,
        value: VisibilityFilter.all,
        child: Text(
          ArchSampleLocalizations.of(context).showAll,
          style: controller.filter.value == VisibilityFilter.all
              ? activeStyle
              : defaultStyle,
        ),
      ),
      PopupMenuItem<VisibilityFilter>(
        key: ArchSampleKeys.activeFilter,
        value: VisibilityFilter.active,
        child: Text(
          ArchSampleLocalizations.of(context).showActive,
          style: controller.filter.value == VisibilityFilter.active
              ? activeStyle
              : defaultStyle,
        ),
      ),
      PopupMenuItem<VisibilityFilter>(
        key: ArchSampleKeys.completedFilter,
        value: VisibilityFilter.completed,
        child: Text(
          ArchSampleLocalizations.of(context).showCompleted,
          style: controller.filter.value == VisibilityFilter.completed
              ? activeStyle
              : defaultStyle,
        ),
      ),
    ];
  }
}
