import 'package:flutter/material.dart';
import 'package:flutter_mvc/flutter_mvc.dart';
import 'package:vanilla/models.dart';

class FilterButton extends StatelessWidget {
  final PopupMenuItemSelected<VisibilityFilter> onSelected;
  final VisibilityFilter activeFilter;
  final bool isActive;

  FilterButton({this.onSelected, this.activeFilter, this.isActive, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isActive) return new Container();

    final defaultStyle = Theme.of(context).textTheme.body1;
    final activeStyle = Theme
        .of(context)
        .textTheme
        .body1
        .copyWith(color: Theme.of(context).accentColor);

    return new PopupMenuButton<VisibilityFilter>(
      tooltip: ArchitectureLocalizations.of(context).filterTodos,
      onSelected: onSelected,
      itemBuilder: (BuildContext context) => <PopupMenuItem<VisibilityFilter>>[
            new PopupMenuItem<VisibilityFilter>(
              value: VisibilityFilter.all,
              child: new Text(
                ArchitectureLocalizations.of(context).showAll,
                style: activeFilter == VisibilityFilter.all
                    ? activeStyle
                    : defaultStyle,
              ),
            ),
            new PopupMenuItem<VisibilityFilter>(
              value: VisibilityFilter.active,
              child: new Text(
                ArchitectureLocalizations.of(context).showActive,
                style: activeFilter == VisibilityFilter.active
                    ? activeStyle
                    : defaultStyle,
              ),
            ),
            new PopupMenuItem<VisibilityFilter>(
              value: VisibilityFilter.completed,
              child: new Text(
                ArchitectureLocalizations.of(context).showCompleted,
                style: activeFilter == VisibilityFilter.completed
                    ? activeStyle
                    : defaultStyle,
              ),
            ),
          ],
      icon: new Icon(Icons.filter_list),
    );
  }
}
