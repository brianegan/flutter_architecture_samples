import 'package:mobx/mobx.dart';
import 'package:mobx_sample/model/todo_list.dart';

part 'layout.g.dart';

class LayoutStore = _LayoutStore with _$LayoutStore;

abstract class _LayoutStore with Store {
  @observable
  TabType activeTab = TabType.todos;

  @action
  updateTab(TabType tab) {
    activeTab = tab;
  }
}
