import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:scoped_model_sample/state_container.dart';
import 'package:scoped_model_sample/localization.dart';
import 'package:scoped_model_sample/models.dart';
import 'package:scoped_model_sample/widgets/extra_actions_button.dart';
import 'package:scoped_model_sample/widgets/filter_button.dart';
import 'package:scoped_model_sample/widgets/stats_counter.dart';
import 'package:scoped_model_sample/widgets/todo_list.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen() : super(key: ArchSampleKeys.homeScreen);

  @override
  State<StatefulWidget> createState() {
    return new HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  AppTab activeTab = AppTab.todos;

  @override
  void initState() {
    final container = new ModelFinder<StateContainer>().of(context);

    container.repository.loadTodos().then((loadedTodos) {
      container.setTodos(loadedTodos.map(Todo.fromEntity).toList());
    }).catchError((err) {
      container.setTodos([]);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new ScopedModelDescendant<StateContainer>(
      builder: (context, child, container) {
        return new Scaffold(
          appBar: new AppBar(
            title: new Text(ScopedModelLocalizations.of(context).appTitle),
            actions: [
              new FilterButton(
                isActive: activeTab == AppTab.todos,
                activeFilter: container.state.activeFilter,
                onSelected: container.updateFilter,
              ),
              new ExtraActionsButton(
                allComplete: container.state.allComplete,
                hasCompletedTodos: container.state.hasCompletedTodos,
                onSelected: (action) {
                  if (action == ExtraAction.toggleAllComplete) {
                    container.toggleAll();
                  } else if (action == ExtraAction.clearCompleted) {
                    container.clearCompleted();
                  }
                },
              )
            ],
          ),
          body: activeTab == AppTab.todos ? new TodoList() : new StatsCounter(),
          floatingActionButton: new FloatingActionButton(
            key: ArchSampleKeys.addTodoFab,
            onPressed: () {
              Navigator.pushNamed(context, ArchSampleRoutes.addTodo);
            },
            child: new Icon(Icons.add),
            tooltip: ArchSampleLocalizations.of(context).addTodo,
          ),
          bottomNavigationBar: new BottomNavigationBar(
            key: ArchSampleKeys.tabs,
            currentIndex: AppTab.values.indexOf(activeTab),
            onTap: (index) {
              _updateTab(AppTab.values[index]);
            },
            items: AppTab.values.map((tab) {
              return new BottomNavigationBarItem(
                icon: new Icon(
                  tab == AppTab.todos ? Icons.list : Icons.show_chart,
                  key: tab == AppTab.stats
                      ? ArchSampleKeys.statsTab
                      : ArchSampleKeys.todoTab,
                ),
                title: new Text(
                  tab == AppTab.stats
                      ? ArchSampleLocalizations.of(context).stats
                      : ArchSampleLocalizations.of(context).todos,
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  _updateTab(AppTab tab) {
    setState(() {
      activeTab = tab;
    });
  }
}
