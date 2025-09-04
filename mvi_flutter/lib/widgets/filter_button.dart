import 'package:flutter/material.dart';
import 'package:mvi_base/mvi_base.dart';
import 'package:todos_app_core/todos_app_core.dart';

class FilterButton extends StatelessWidget {
  final PopupMenuItemSelected<VisibilityFilter> onSelected;
  final VisibilityFilter activeFilter;
  final bool isActive;

  FilterButton({
    super.key,
    required this.onSelected,
    required this.activeFilter,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.bodyMedium!;
    final activeStyle = defaultStyle.copyWith(
      color: Theme.of(context).colorScheme.secondary,
    );
    final button = _Button(
      onSelected: onSelected,
      activeFilter: activeFilter,
      activeStyle: activeStyle,
      defaultStyle: defaultStyle,
    );

    return AnimatedOpacity(
      opacity: isActive ? 1.0 : 0.0,
      duration: Duration(milliseconds: 150),
      child: isActive ? button : IgnorePointer(child: button),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.onSelected,
    required this.activeFilter,
    required this.activeStyle,
    required this.defaultStyle,
  });

  final PopupMenuItemSelected<VisibilityFilter> onSelected;
  final VisibilityFilter activeFilter;
  final TextStyle activeStyle;
  final TextStyle defaultStyle;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<VisibilityFilter>(
      key: ArchSampleKeys.filterButton,
      tooltip: ArchSampleLocalizations.of(context).filterTodos,
      onSelected: onSelected,
      itemBuilder: (BuildContext context) {
        return <PopupMenuItem<VisibilityFilter>>[
          PopupMenuItem<VisibilityFilter>(
            key: ArchSampleKeys.allFilter,
            value: VisibilityFilter.all,
            child: Text(
              ArchSampleLocalizations.of(context).showAll,
              style: activeFilter == VisibilityFilter.all
                  ? activeStyle
                  : defaultStyle,
            ),
          ),
          PopupMenuItem<VisibilityFilter>(
            key: ArchSampleKeys.activeFilter,
            value: VisibilityFilter.active,
            child: Text(
              ArchSampleLocalizations.of(context).showActive,
              style: activeFilter == VisibilityFilter.active
                  ? activeStyle
                  : defaultStyle,
            ),
          ),
          PopupMenuItem<VisibilityFilter>(
            key: ArchSampleKeys.completedFilter,
            value: VisibilityFilter.completed,
            child: Text(
              ArchSampleLocalizations.of(context).showCompleted,
              style: activeFilter == VisibilityFilter.completed
                  ? activeStyle
                  : defaultStyle,
            ),
          ),
        ];
      },
      icon: Icon(Icons.filter_list),
    );
  }
}
