import 'package:todos_repository/todos_repository.dart';

List<TodoEntity> createTodos({bool complete}) => [
      new TodoEntity('Buy milk', '1', 'soy', complete ?? false),
      new TodoEntity('Buy bread', '2', 'italian one', complete ?? true),
      new TodoEntity('Buy meat', '3', 'or chicken', complete ?? false),
      new TodoEntity(
          'Buy water', '4', 'carbonated and still', complete ?? true),
      new TodoEntity('Read book', '5', 'interesting one', complete ?? false),
      new TodoEntity('Watch football', '6', '', complete ?? true),
      new TodoEntity('Sleep', '7', 'well', complete ?? false),
    ];

List<TodoEntity> createTodosForStats(int activeCount, int completedCount) {
  var result = List<TodoEntity>();
  for (int i = 0; i < activeCount; i++) {
    var todo = TodoEntity('todo $i', '$i', 'note for todo #$i', false);
    result.add(todo);
  }
  var totalLength = result.length + completedCount;
  for (int i = result.length; i < totalLength; i++) {
    var todo = TodoEntity('todo $i', '$i', 'note for todo #$i', true);
    result.add(todo);
  }
  return result;
}
