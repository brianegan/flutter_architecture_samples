import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:todos_app_core/todos_app_core.dart';

import '../../../localization.dart';
import '../../../service/todos_state.dart';
import '../../common/enums.dart';
import '../../exceptions/error_handler.dart';
import 'extra_actions_button.dart';
import 'filter_button.dart';
import 'stats_counter.dart';
import 'todo_list.dart';

//states_rebuilder is based on the concept fo ReactiveModels.
//ReactiveModels can be local or global.
class HomeScreen extends StatelessWidget {
  //Create a reactive model key to handle app tab navigation.
  //ReactiveModel keys are used for local ReactiveModels (similar to Flutter global key)
  final _activeTabRMKey = RMKey(AppTab.todos);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StatesRebuilderLocalizations.of(context).appTitle),
        actions: [
          //As FilterButton should respond to the active tab, the activeTab reactiveModel is
          //injected throw the constructor using the ReactiveModels key,
          FilterButton(activeTabRM: _activeTabRMKey),
          ExtraActionsButton(),
        ],
      ),
      //WhenRebuilderOr is one of four widget used by states_rebuilder to subscribe to observable ReactiveModels
      body: WhenRebuilderOr<AppTab>(
        //subscribe this widget to many observables.
        //This widget will rebuild when the loadTodos future method resolves and,
        //when the state of the active AppTab is changed
        observeMany: [
          //Here get a new reactiveModel of the injected TodosStore
          //we use the HomeScreen seed so that if other pages emits a notification this widget will not be notified
          () => RM.get<TodosState>().asNew(HomeScreen)
            //using the cascade operator, we call the todosLoad method informing states_rebuilder that is is a future
            ..setState(
              (t) => TodosState.loadTodos(t),
              //Invoke the error callBack to handle the error
              onError: ErrorHandler.showErrorDialog,
            ),
          //Her we subscribe to the activeTab ReactiveModel key
          () => _activeTabRMKey,
        ],
        //When any of the observed model is waiting for a future to resolve or stream to begin,
        //this onWaiting method is called,
        onWaiting: () {
          return Center(
            child: CircularProgressIndicator(
              key: ArchSampleKeys.todosLoading,
            ),
          );
        },
        //WhenRebuilderOr has other optional callBacks (onData, onIdle, onError).
        //the builder is the default one.
        builder: (context, _activeTabRM) {
          return _activeTabRM.state == AppTab.todos
              ? TodoList()
              : StatsCounter();
        },
      ),
      floatingActionButton: FloatingActionButton(
        key: ArchSampleKeys.addTodoFab,
        onPressed: () {
          Navigator.pushNamed(context, ArchSampleRoutes.addTodo);
        },
        child: Icon(Icons.add),
        tooltip: ArchSampleLocalizations.of(context).addTodo,
      ),
      //StateBuilder is the second of three widget used to subscribe to observables
      bottomNavigationBar: StateBuilder<AppTab>(
          //Here we create a local ReactiveModel of type AppTab with default state of AppTab.todos)
          observe: () => RM.create(AppTab.todos),
          //To control or use the value of this local ReactiveModel outside this Widget,
          //we use key in the same fashion Flutter gobble key is used.
          //Here we associated the already defined ReactiveModel key with this widget.
          rmKey: _activeTabRMKey,
          //The builder method exposes the BuildContext and the ReactiveModel model of type defined in
          // the generic type of the StateBuilder
          builder: (context, _activeTabRM) {
            return BottomNavigationBar(
              key: ArchSampleKeys.tabs,
              currentIndex: AppTab.values.indexOf(_activeTabRM.state),
              onTap: (index) {
                //mutate the state of the private field _activeTabRM,
                //observing widget will be notified to rebuild
                //We have three observing widgets : this StateBuilder, the WhenRebuilderOr,
                //ond the StateBuilder defined in the FilterButton widget
                _activeTabRM.state = AppTab.values[index];
              },
              items: AppTab.values.map(
                (tab) {
                  return BottomNavigationBarItem(
                    icon: Icon(
                      tab == AppTab.todos ? Icons.list : Icons.show_chart,
                      key: tab == AppTab.stats
                          ? ArchSampleKeys.statsTab
                          : ArchSampleKeys.todoTab,
                    ),
                    title: Text(
                      tab == AppTab.stats
                          ? ArchSampleLocalizations.of(context).stats
                          : ArchSampleLocalizations.of(context).todos,
                    ),
                  );
                },
              ).toList(),
            );
          }),
    );
  }
}
