import 'package:bloc/bloc.dart';
import 'package:bloc_library/blocs/tab/tab.dart';
import 'package:bloc_library/models/models.dart';

class TabBloc extends Bloc<TabEvent, AppTab> {
  TabBloc() : super(AppTab.todos) {
    on<UpdateTab>(_onUpdateTab);
  }

  void _onUpdateTab(UpdateTab event, Emitter<AppTab> emit) {
    emit(event.tab);
  }
}
