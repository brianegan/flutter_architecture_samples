// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved. 
// Use of this source code is governed by the MIT license that can be found 
// in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:todos_repository/src/todo_entity.dart';

/// Loads and saves a List of Todos using a text file stored on the device.
///
/// Note: This class has no direct dependencies on any Flutter dependencies.
/// Instead, the `getDirectory` method should be injected. If you're calling
/// this from the
class FileStorage {
  final String tag;
  final Future<Directory> Function() getDirectory;

  const FileStorage(
    this.tag,
    this.getDirectory,
  );

  Future<List<TodoEntity>> loadTodos() async {
    final file = await _getLocalFile();
    final string = await file.readAsString();
    final json = new JsonDecoder().convert(string);
    final todos = (json['todos'] as List<Map<String, dynamic>>)
        .map((todo) => TodoEntity.fromJson(todo))
        .toList();

    return todos;
  }

  Future<File> saveTodos(List<TodoEntity> todos) async {
    final file = await _getLocalFile();

    return file.writeAsString(new JsonEncoder().convert({
      'todos': todos.map((todo) => todo.toJson()).toList(),
    }));
  }

  Future<File> _getLocalFile() async {
    final dir = await getDirectory();

    return new File('${dir.path}/ArchSampleStorage__$tag.json');
  }

  Future<FileSystemEntity> clean() async {
    final file = await _getLocalFile();

    return file.delete();
  }
}
