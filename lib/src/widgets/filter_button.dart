import 'package:flutter/material.dart';
import 'package:flutter_mvc/flutter_mvc.dart';

class FilterButton extends StatelessWidget {
  final PopupMenuItemSelected<VisibilityFilter> onSelected;
  final VisibilityFilter activeFilter;

  FilterButton({this.onSelected, this.activeFilter, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.body1;
    final activeStyle = Theme
        .of(context)
        .textTheme
        .body1
        .copyWith(color: Theme.of(context).accentColor);

    return new PopupMenuButton<VisibilityFilter>(
      tooltip: FlutterMvcStrings.filterTodos,
      onSelected: onSelected,
      itemBuilder: (BuildContext context) => <PopupMenuItem<VisibilityFilter>>[
            new PopupMenuItem<VisibilityFilter>(
              value: VisibilityFilter.all,
              child: new Text(
                FlutterMvcStrings.all,
                style: activeFilter == VisibilityFilter.all
                    ? activeStyle
                    : defaultStyle,
              ),
            ),
            new PopupMenuItem<VisibilityFilter>(
              value: VisibilityFilter.active,
              child: new Text(
                FlutterMvcStrings.active,
                style: activeFilter == VisibilityFilter.active
                    ? activeStyle
                    : defaultStyle,
              ),
            ),
            new PopupMenuItem<VisibilityFilter>(
              value: VisibilityFilter.completed,
              child: new Text(
                FlutterMvcStrings.completed,
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
