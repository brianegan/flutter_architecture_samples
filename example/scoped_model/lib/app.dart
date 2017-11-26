import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:scoped_model_sample/localization.dart';
import 'package:scoped_model_sample/models.dart';
import 'package:scoped_model_sample/screens/add_edit_screen.dart';
import 'package:scoped_model_sample/screens/home_screen.dart';
import 'package:scoped_model_sample/state_container.dart';
import 'package:todos_repository/src/repository.dart';
import 'package:todos_repository/src/file_storage.dart';
import 'package:path_provider/path_provider.dart';

class ScopedModelApp extends StatelessWidget {
  final AppState state;
  final TodosRepository repository;

  ScopedModelApp({
    AppState state,
    this.repository = const TodosRepository(
      fileStorage: const FileStorage(
        'scoped_model_todos',
        getApplicationDocumentsDirectory,
      ),
    ),
  })
      : this.state = state ?? new AppState.loading();

  @override
  Widget build(BuildContext context) {
    return new ScopedModel<StateContainer>(
      model: new StateContainer(
        state: state,
        repository: repository,
      ),
      child: new MaterialApp(
        title: new ScopedModelLocalizations().appTitle,
        theme: ArchSampleTheme.theme,
        localizationsDelegates: [
          new ArchSampleLocalizationsDelegate(),
          new ScopedModelLocalizationsDelegate(),
        ],
        routes: {
          ArchSampleRoutes.home: (context) => new HomeScreen(),
          ArchSampleRoutes.addTodo: (context) => new AddEditScreen(),
        },
      ),
    );
  }
}
