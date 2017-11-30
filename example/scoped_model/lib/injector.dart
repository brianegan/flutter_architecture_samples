import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:todos_repository/todos_repository.dart';

/// Injector for application wide singletons
class Injector extends InheritedWidget {
  final Components _repos;

  Injector({
    Key key,
    @required Widget child,
    final Factory<TodosRepository> todoRepoFactory = _nullFactory,
  })
      : _repos = new Components(todoRepoFactory),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(Injector old) {
    return _repos != old._repos;
  }

  static Components of(BuildContext context) {
    Injector injector = context.inheritFromWidgetOfExactType(Injector);
    return injector._repos;
  }

  /// When factories aren't required, set this as default method returning `null`
  static T _nullFactory<T>() => null;
}

/// Provider function returning a new instance every time it get's called
typedef T Factory<T>();

/// Makes a singleton Factory, always providing the same instance
Factory singleton(Factory f) => new _Singleton(f);

/// Like [Lazy], calling func once and caching the result for future
class _Singleton<T> {
  static final _cache = new Expando();

  final Function _func;

  const _Singleton(this._func);

  T call() {
    var result = _cache[this];
    if (identical(this, result)) return null;
    if (result != null) return result;
    result = _func();
    _cache[this] = (result == null) ? this : result;
    return result;
  }
}


/// Global singletons for the Todo application available via
///
/// `Components components = Injector.of(context);`
class Components {
  final Factory<TodosRepository> _todoRepoFactory;

  Components(this._todoRepoFactory);

  TodosRepository get todoRepository => _todoRepoFactory();
}
