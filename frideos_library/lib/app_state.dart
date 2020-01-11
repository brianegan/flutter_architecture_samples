import 'package:path_provider/path_provider.dart';

import 'package:todos_repository_local_storage/todos_repository_local_storage.dart';

import 'package:frideos/frideos.dart';

import 'package:frideos_library/blocs/stats_bloc.dart';
import 'package:frideos_library/blocs/todos_bloc.dart';
import 'package:frideos_library/models/models.dart';

class AppState extends AppStateModel {
  static final AppState _singletonAppState = AppState._internal();

  AppState._internal();

  factory AppState() {
    return _singletonAppState;
  }

  LocalStorageRepository respository;
  TodosBloc todosBloc;
  StatsBloc statsBloc;
  final tabController = StreamedValue<AppTab>(initialData: AppTab.todos);

  @override
  void init() {
    respository = const LocalStorageRepository(
      localStorage: FileStorage(
        'frideos_library',
        getApplicationDocumentsDirectory,
      ),
    );

    todosBloc = TodosBloc(repository: respository);
    statsBloc = StatsBloc();

    todosBloc.todosSender.setReceiver(statsBloc.todosItems);
  }

  @override
  void dispose() {
    todosBloc.dispose();
    statsBloc.dispose();
    tabController.dispose();
  }
}
