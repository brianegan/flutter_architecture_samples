// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

/// Loads and saves a List of Todos using a provided KeyValueStore, which works
/// on mobile and web. On mobile, it uses the SharedPreferences package, on web
/// it uses window.localStorage.
///
/// Can be used as it's own repository, or mixed together with other storage
/// solutions, such as the the WebClient, which can be seen in the
/// LocalStorageRepository.
class KeyValueStorage implements TodosRepository {
  final String key;
  final SharedPreferences sharedPreferences;
  final JsonCodec codec;

  const KeyValueStorage(this.key, this.sharedPreferences, [this.codec = json]);

  @override
  Future<List<TodoEntity>> loadTodos() async {
    final todos = sharedPreferences.getString(key);

    if (todos == null) {
      throw Exception('No todos found for key: $key');
    }

    return codec
        .decode(todos)['todos']
        .cast<Map<String, dynamic>>()
        .map<TodoEntity>(TodoEntity.fromJson)
        .toList(growable: false);
  }

  @override
  Future<bool> saveTodos(List<TodoEntity> todos) {
    return sharedPreferences.setString(
      key,
      codec.encode({
        'todos': todos.map((todo) => todo.toJson()).toList(),
      }),
    );
  }
}
