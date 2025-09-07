import 'package:bloc_library/models/models.dart';
import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';

class TabSelector extends StatelessWidget {
  final AppTab activeTab;
  final void Function(AppTab) onTabSelected;

  const TabSelector({
    super.key,
    required this.activeTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      key: ArchSampleKeys.tabs,
      currentIndex: AppTab.values.indexOf(activeTab),
      onTap: (index) => onTabSelected(AppTab.values[index]),
      items: AppTab.values.map((tab) {
        return BottomNavigationBarItem(
          icon: Icon(
            tab == AppTab.todos ? Icons.list : Icons.show_chart,
            key: tab == AppTab.todos
                ? ArchSampleKeys.todoTab
                : ArchSampleKeys.statsTab,
          ),
          label: tab == AppTab.stats
              ? ArchSampleLocalizations.of(context).stats
              : ArchSampleLocalizations.of(context).todos,
        );
      }).toList(),
    );
  }
}
