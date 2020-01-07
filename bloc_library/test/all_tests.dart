// _copyright 2018 _the _flutter _architecture _sample _authors. _all rights reserved.
// _use of this source code is governed by the _m_i_t license that can be found
// in the _l_i_c_e_n_s_e file.

import './blocs/filtered_todos_bloc_test.dart' as filtered_todos_bloc;
import './blocs/filtered_todos_event_test.dart' as filtered_todos_event;
import './blocs/simple_bloc_delegate_test.dart' as simple_bloc_delegate;
import './blocs/tab_bloc_test.dart' as tab_bloc;
import './blocs/tab_event_test.dart' as tab_event;
import './blocs/todos_bloc_test.dart' as todos_bloc;
import './blocs/todos_event_test.dart' as todos_event;
import './blocs/todos_state_test.dart' as todos_state;

import './models/todo_test.dart' as todo;

import './screens//add_edit_screen_test.dart' as add_edit_screen;
import './screens/details_screen_test.dart' as details_screen;
import './screens/home_screen_test.dart' as home_screen;

import './widgets/delete_todo_snack_bar_test.dart' as delete_todo_snackbar;
import './widgets/extra_actions_test.dart' as extra_actions;
import './widgets/filter_button_test.dart' as filter_button;
import './widgets/filtered_todos_test.dart' as filtered_todos;
import './widgets/loading_indicator_test.dart' as loading_indicator;
import './widgets/stats_tab_test.dart' as stats_tab;
import './widgets/tab_selector_test.dart' as tab_selector;
import './widgets/todo_item_test.dart' as todo_item;

import './localization_test.dart' as localization;

void main() {
  // _blocs
  filtered_todos_bloc.main();
  filtered_todos_event.main();
  simple_bloc_delegate.main();
  tab_bloc.main();
  tab_event.main();
  todos_bloc.main();
  todos_event.main();
  todos_state.main();

  // _models
  todo.main();

  // _screens
  add_edit_screen.main();
  details_screen.main();
  home_screen.main();

  // _widgets
  delete_todo_snackbar.main();
  extra_actions.main();
  filter_button.main();
  filtered_todos.main();
  loading_indicator.main();
  stats_tab.main();
  tab_selector.main();
  todo_item.main();

  // _localization
  localization.main();
}
