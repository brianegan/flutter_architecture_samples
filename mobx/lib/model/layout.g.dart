// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'layout.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars

mixin _$LayoutStore on _LayoutStore, Store {
  final _$activeTabAtom = Atom(name: '_LayoutStore.activeTab');

  @override
  TabType get activeTab {
    _$activeTabAtom.context.enforceReadPolicy(_$activeTabAtom);
    _$activeTabAtom.reportObserved();
    return super.activeTab;
  }

  @override
  set activeTab(TabType value) {
    _$activeTabAtom.context.conditionallyRunInAction(() {
      super.activeTab = value;
      _$activeTabAtom.reportChanged();
    }, _$activeTabAtom, name: '${_$activeTabAtom.name}_set');
  }

  final _$_LayoutStoreActionController = ActionController(name: '_LayoutStore');

  @override
  dynamic updateTab(TabType tab) {
    final _$actionInfo = _$_LayoutStoreActionController.startAction();
    try {
      return super.updateTab(tab);
    } finally {
      _$_LayoutStoreActionController.endAction(_$actionInfo);
    }
  }
}
