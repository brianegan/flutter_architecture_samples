import 'package:built_redux_sample/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';

class FilterButton extends StatelessWidget {
  final PopupMenuItemSelected<VisibilityFilter> onSelected;
  final VisibilityFilter activeFilter;
  final bool visible;

  FilterButton({this.onSelected, this.activeFilter, this.visible, Key key})
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
      opacity: visible ? 1.0 : 0.0,
      duration: new Duration(milliseconds: 150),
      child: new PopupMenuButton<VisibilityFilter>(
        key: ArchSampleKeys.filterButton,
        tooltip: ArchSampleLocalizations.of(context).filterTodos,
        onSelected: onSelected,
        itemBuilder: (BuildContext context) =>
            <PopupMenuItem<VisibilityFilter>>[
              new PopupMenuItem<VisibilityFilter>(
                value: VisibilityFilter.all,
                child: new Text(
                  ArchSampleLocalizations.of(context).showAll,
                  key: ArchSampleKeys.allFilter,
                  style: activeFilter == VisibilityFilter.all
                      ? activeStyle
                      : defaultStyle,
                ),
              ),
              new PopupMenuItem<VisibilityFilter>(
                value: VisibilityFilter.active,
                child: new Text(
                  ArchSampleLocalizations.of(context).showActive,
                  key: ArchSampleKeys.activeFilter,
                  style: activeFilter == VisibilityFilter.active
                      ? activeStyle
                      : defaultStyle,
                ),
              ),
              new PopupMenuItem<VisibilityFilter>(
                value: VisibilityFilter.completed,
                child: new Text(
                  ArchSampleLocalizations.of(context).showCompleted,
                  key: ArchSampleKeys.completedFilter,
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
