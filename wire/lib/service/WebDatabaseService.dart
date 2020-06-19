import 'dart:html';
import 'dart:convert';

import 'IDatabaseService.dart';

class WebDatabaseService extends IDatabaseService {
  @override
  bool exist(String key) {
    return window.localStorage.containsKey(key);
  }

  @override
  dynamic retrieve(String key) {
    return jsonDecode(window.localStorage[key]);
  }

  @override
  void save(String key, dynamic data) {
    window.localStorage[key] = jsonEncode(data);
  }

  @override
  Future init([String key]) { }
}