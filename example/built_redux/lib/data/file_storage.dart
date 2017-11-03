import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:built_redux_sample/models/models.dart';
import 'package:built_redux_sample/models/serializers.dart';
import 'package:path_provider/path_provider.dart';

/// Loads and saves a List of Todos using a text file stored on the device.
class FileStorage {
  final String tag;

  const FileStorage(this.tag);

  Future<List<Todo>> loadTodos() async {
    final file = await _getLocalFile();
    final contents = await file.readAsString();

    return serializers
        .deserializeWith(AppState.serializer, JSON.decode(contents))
        .todos
        .toList();
  }

  Future<File> saveTodos(List<Todo> todos) async {
    final file = await _getLocalFile();

    final string = JSON.encode(
      serializers.serializeWith(
        AppState.serializer,
        new AppState.fromTodos(todos),
      ),
    );

    return file.writeAsString(
      string,
    );
  }

  Future<File> _getLocalFile() async {
    final dir = await getApplicationDocumentsDirectory();

    return new File('${dir.path}/FlutterMvcFileStorage__$tag.json');
  }

  Future<FileSystemEntity> clean() async {
    final file = await _getLocalFile();

    return file.delete();
  }
}
