import 'dart:html';

import 'package:wire/wire.dart';

import '../const/TodoFilterValues.dart';
import '../const/TodoViewSignal.dart';

class RouteController {
  RouteController() {
    window.onHashChange.listen((e) {
      checkFilterRouterChanged();
    });
    checkFilterRouterChanged();
  }

  void checkFilterRouterChanged () {
    var filter;
    switch (window.location.hash) {
      case '#/': filter = TodoFilterValue.ALL; break;
      case '#/active': filter = TodoFilterValue.ACTIVE; break;
      case '#/completed': filter = TodoFilterValue.COMPLETED; break;
    }
    if (filter != null) Wire.send(TodoViewSignal.FILTER, filter);
  }
}