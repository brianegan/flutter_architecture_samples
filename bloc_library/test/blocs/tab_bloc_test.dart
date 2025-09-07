import 'package:bloc_library/blocs/tab/tab.dart';
import 'package:bloc_library/models/models.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TabBloc', () {
    blocTest<TabBloc, AppTab>(
      'should update the AppTab',
      build: () => TabBloc(),
      act: (TabBloc bloc) async => bloc.add(UpdateTab(AppTab.stats)),
      expect: () => [AppTab.stats],
    );
  });
}
