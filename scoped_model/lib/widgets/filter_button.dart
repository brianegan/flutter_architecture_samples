import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:scoped_model_sample/todo_list_model.dart';
import 'package:todos_app_core/todos_app_core.dart';

class FilterButton extends StatelessWidget {
  final bool isActive;

  const FilterButton({required this.isActive, super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isActive ? 1.0 : 0.0,
      duration: Duration(milliseconds: 150),
      child: ScopedModelDescendant<TodoListModel>(
        builder: (BuildContext context, Widget? child, TodoListModel model) {
          return PopupMenuButton<VisibilityFilter>(
            key: ArchSampleKeys.filterButton,
            tooltip: ArchSampleLocalizations.of(context).filterTodos,
            onSelected: (filter) {
              model.activeFilter = filter;
            },
            itemBuilder: (BuildContext context) => _items(context, model),
            icon: Icon(Icons.filter_list),
          );
        },
      ),
    );
  }

  List<PopupMenuItem<VisibilityFilter>> _items(
    BuildContext context,
    TodoListModel model,
  ) {
    final defaultStyle = Theme.of(context).textTheme.bodyMedium;
    final activeStyle = defaultStyle?.copyWith(
      color: Theme.of(context).colorScheme.secondary,
    );

    return [
      PopupMenuItem<VisibilityFilter>(
        key: ArchSampleKeys.allFilter,
        value: VisibilityFilter.all,
        child: Text(
          ArchSampleLocalizations.of(context).showAll,
          style: model.activeFilter == VisibilityFilter.all
              ? activeStyle
              : defaultStyle,
        ),
      ),
      PopupMenuItem<VisibilityFilter>(
        key: ArchSampleKeys.activeFilter,
        value: VisibilityFilter.active,
        child: Text(
          ArchSampleLocalizations.of(context).showActive,
          style: model.activeFilter == VisibilityFilter.active
              ? activeStyle
              : defaultStyle,
        ),
      ),
      PopupMenuItem<VisibilityFilter>(
        key: ArchSampleKeys.completedFilter,
        value: VisibilityFilter.completed,
        child: Text(
          ArchSampleLocalizations.of(context).showCompleted,
          style: model.activeFilter == VisibilityFilter.completed
              ? activeStyle
              : defaultStyle,
        ),
      ),
    ];
  }
}
