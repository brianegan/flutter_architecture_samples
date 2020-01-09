// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:convert';

import 'package:key_value_store/key_value_store.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

/// Loads and saves a List of Todos using a provided KeyValueStore, which works
/// on mobile and web.
class LocalStorage {
  final String key;
  final KeyValueStore store;
  final JsonCodec codec;

  const LocalStorage(this.key, this.store, [this.codec = json]);

  List<TodoEntity> loadTodos() {
    return codec
        .decode(store.getString(key))['todos']
        .cast<Map<String, Object>>()
        .map<TodoEntity>(TodoEntity.fromJson)
        .toList(growable: false);
  }

  Future<bool> saveTodos(List<TodoEntity> todos) {
    return store.setString(
      key,
      codec.encode({
        'todos': todos.map((todo) => todo.toJson()).toList(),
      }),
    );
  }
}
