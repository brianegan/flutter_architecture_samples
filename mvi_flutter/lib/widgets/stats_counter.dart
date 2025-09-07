import 'package:flutter/material.dart';
import 'package:mvi_base/mvi_base.dart';
import 'package:mvi_flutter_sample/dependency_injection.dart';
import 'package:todos_app_core/todos_app_core.dart';

class StatsCounter extends StatefulWidget {
  final MviPresenter<StatsModel> Function()? initPresenter;

  const StatsCounter({
    super.key = ArchSampleKeys.statsCounter,
    this.initPresenter,
  });

  @override
  StatsCounterState createState() {
    return StatsCounterState();
  }
}

class StatsCounterState extends State<StatsCounter> {
  late final MviPresenter<StatsModel> presenter;

  @override
  void didChangeDependencies() {
    presenter = widget.initPresenter != null
        ? widget.initPresenter!()
        : StatsPresenter(Injector.of(context).todosInteractor);

    presenter.setUp();

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    presenter.tearDown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StatsModel>(
      stream: presenter,
      initialData: presenter.latest,
      builder: (context, snapshot) {
        final data = snapshot.data!;

        switch (data) {
          case StatsModelLoading():
            return const SizedBox.shrink();
          case StatsModelLoaded():
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      ArchSampleLocalizations.of(context).completedTodos,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 24.0),
                    child: Text(
                      '${data.numComplete}',
                      key: ArchSampleKeys.statsNumCompleted,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      ArchSampleLocalizations.of(context).activeTodos,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 24.0),
                    child: Text(
                      '${data.numActive}',
                      key: ArchSampleKeys.statsNumActive,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            );
        }
      },
    );
  }
}
