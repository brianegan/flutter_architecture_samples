import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_library/blocs/blocs.dart';
import 'package:bloc_library/models/todo.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final TodosBloc todosBloc;
  late final StreamSubscription<TodosState> todosSubscription;

  StatsBloc({required this.todosBloc})
    : super(
        todosBloc.state is TodosLoaded
            ? _mapTodosToStats((todosBloc.state as TodosLoaded).todos)
            : StatsLoaded(0, 0),
      ) {
    todosSubscription = todosBloc.stream.listen((state) {
      if (state is TodosLoaded) {
        add(UpdateStats(state.todos));
      }
    });

    on<UpdateStats>(_onUpdateStats);
  }

  void _onUpdateStats(UpdateStats event, Emitter<StatsState> emit) {
    emit(_mapTodosToStats(event.todos));
  }

  static StatsLoaded _mapTodosToStats(List<Todo> todos) {
    var numActive = todos.where((todo) => !todo.complete).toList().length;
    var numCompleted = todos.where((todo) => todo.complete).toList().length;
    return StatsLoaded(numActive, numCompleted);
  }

  @override
  Future<void> close() {
    todosSubscription.cancel();
    return super.close();
  }
}
