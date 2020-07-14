import 'package:key_value_store_flutter/key_value_store_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos_repository_core/todos_repository_core.dart';
import 'package:todos_repository_local_storage/todos_repository_local_storage.dart';

import 'IDatabaseService.dart';

class MobileDatabaseService extends IDatabaseService {
  MobileDatabaseService();

  TodosRepository repository;
  var jsonList = <dynamic>[];

  @override
  Future init([String key]) async {
    repository = LocalStorageRepository(
      localStorage: KeyValueStorage(
        key,
        FlutterKeyValueStore(await SharedPreferences.getInstance()),
      ));
    await repository.loadTodos().then((loadedTodos) {
      loadedTodos.forEach((todoEntry) => {
        jsonList.add({
          'id': todoEntry.id,
          'text': todoEntry.task,
          'note': todoEntry.note,
          'completed': todoEntry.complete
        })
      });
    });
  }

  @override
  bool exist(String key) { return true; }

  @override
  dynamic retrieve(String key) {
    return jsonList;
  }

  @override
  void save(String key, dynamic data) {

  }
}