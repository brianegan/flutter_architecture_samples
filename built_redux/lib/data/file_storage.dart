// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:built_redux_sample/models/models.dart';
import 'package:built_redux_sample/models/serializers.dart';

/// Loads and saves a List of Todos using a text file stored on the device.
class FileStorage {
  final String tag;
  final Future<Directory> Function() getDirectory;

  const FileStorage(
    this.tag,
    this.getDirectory,
  );

  /// LoadTodos
  Future<List<Todo>> loadTodos() async {
    final file = await _getLocalFile();
    final contents = await file.readAsString();

    return serializers
        .deserializeWith(AppState.serializer, json.decode(contents))
        .todos
        .toList();
  }

  Future<File> saveTodos(List<Todo> todos) async {
    final file = await _getLocalFile();

    return file.writeAsString(
      json.encode(
        serializers.serializeWith(
          AppState.serializer,
          AppState.fromTodos(todos),
        ),
      ),
    );
  }

  Future<File> _getLocalFile() async {
    final dir = await getDirectory();

    return File('${dir.path}/FlutterMvcFileStorage__$tag.json');
  }

  Future<FileSystemEntity> clean() async {
    final file = await _getLocalFile();

    return file.delete();
  }
}
