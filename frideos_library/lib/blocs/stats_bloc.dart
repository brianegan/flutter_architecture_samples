import 'package:frideos/frideos_dart.dart';

import 'package:frideos_library/models/models.dart';

class StatsBloc {
  final todosItems = StreamedList<Todo>(initialData: List<Todo>());

  StatsBloc() {
    print('-------STATS BLOC INIT--------');
    todosItems.onChange((todos) {
      numActive.value =
          todos?.fold(0, (sum, todo) => !todo.complete ? ++sum : sum);

      numComplete.value =
          todos?.fold(0, (sum, todo) => todo.complete ? ++sum : sum);
    });
  }

  final numActive = StreamedValue<int>();
  final numComplete = StreamedValue<int>();

  dispose() {
    print('-------STATS BLOC DISPOSE--------');
    numActive.dispose();
    numComplete.dispose();
  }
}
