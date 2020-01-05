import 'package:frideos/frideos.dart';

import 'package:frideos_library/models/models.dart';

class StatsBloc {
  StatsBloc() {
    todosItems.onChange((todos) {
      numActive.value =
          todos?.fold(0, (sum, todo) => !todo.complete ? ++sum : sum);

      numComplete.value =
          todos?.fold(0, (sum, todo) => todo.complete ? ++sum : sum);
    });
  }
  // This will receive the todos from the TodoBloc.
  final todosItems = StreamedList<Todo>();

  final numActive = StreamedValue<int>();
  final numComplete = StreamedValue<int>();

  void dispose() {
    todosItems.dispose();
    numActive.dispose();
    numComplete.dispose();
  }
}
