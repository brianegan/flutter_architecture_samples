import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter_mvc/src/models.dart';
import 'package:path_provider/path_provider.dart';

class FlutterMvcFileStorage {
  final String tag;

  FlutterMvcFileStorage(this.tag);

  Future<AppState> loadAppState() async {
    final file = await _getLocalFile();
    final string = await file.readAsString();

    return AppState.fromJson(new JsonDecoder().convert(string));
  }

  Future saveAppState(AppState state) async {
    final file = await _getLocalFile();

    return file.writeAsString(new JsonEncoder().convert(state.toJson()));
  }

  Future<File> _getLocalFile() async {
    final dir = await getApplicationDocumentsDirectory();

    return new File('${dir.path}/FlutterMvcFileStorage__$tag.json');
  }
}
