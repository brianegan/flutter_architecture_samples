import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';
import 'package:vanilla/models.dart';

class FilterButton extends StatelessWidget {
  final PopupMenuItemSelected<VisibilityFilter> onSelected;
  final VisibilityFilter activeFilter;
  final bool isActive;

  FilterButton({this.onSelected, this.activeFilter, this.isActive, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.body1;
    final activeStyle = Theme
        .of(context)
        .textTheme
        .body1
        .copyWith(color: Theme.of(context).accentColor);

    return new AnimatedOpacity(
      opacity: isActive ? 1.0 : 0.0,
      duration: new Duration(milliseconds: 150),
      child: new PopupMenuButton<VisibilityFilter>(
        key: ArchSampleKeys.filterButton,
        tooltip: ArchSampleLocalizations.of(context).filterTodos,
        onSelected: onSelected,
        itemBuilder: (BuildContext context) =>
            <PopupMenuItem<VisibilityFilter>>[
              new PopupMenuItem<VisibilityFilter>(
                key: ArchSampleKeys.allFilter,
                value: VisibilityFilter.all,
                child: new Text(
                  ArchSampleLocalizations.of(context).showAll,
                  style: activeFilter == VisibilityFilter.all
                      ? activeStyle
                      : defaultStyle,
                ),
              ),
              new PopupMenuItem<VisibilityFilter>(
                key: ArchSampleKeys.activeFilter,
                value: VisibilityFilter.active,
                child: new Text(
                  ArchSampleLocalizations.of(context).showActive,
                  style: activeFilter == VisibilityFilter.active
                      ? activeStyle
                      : defaultStyle,
                ),
              ),
              new PopupMenuItem<VisibilityFilter>(
                key: ArchSampleKeys.completedFilter,
                value: VisibilityFilter.completed,
                child: new Text(
                  ArchSampleLocalizations.of(context).showCompleted,
                  style: activeFilter == VisibilityFilter.completed
                      ? activeStyle
                      : defaultStyle,
                ),
              ),
            ],
        icon: new Icon(Icons.filter_list),
      ),
    );
  }
}
