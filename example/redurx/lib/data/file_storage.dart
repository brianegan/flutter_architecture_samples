import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:redurx_sample/models/app_state.dart';
import 'package:redurx_sample/models/serializers.dart';
import 'package:redurx_sample/models/todo.dart';

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
