import 'package:flutter/material.dart';
import 'package:vanilla/app.dart';
import 'package:vanilla/data/file_storage.dart';
import 'package:vanilla/data/todos_service.dart';
import 'package:vanilla/data/web_service.dart';

void main() {
  runApp(
    new VanillaApp(
      service: new TodosService(
        fileStorage: new FileStorage("vanilla"),
        webService: new WebService(),
      ),
    ),
  );
}
