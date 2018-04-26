// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:meta/meta.dart';
import 'package:redux_sample/models/models.dart';

@immutable
class AppState {
  final bool isLoading;
  final List<Todo> todos;
  final AppTab activeTab;
  final VisibilityFilter activeFilter;

  AppState(
      {this.isLoading = false,
      this.todos = const [],
      this.activeTab = AppTab.todos,
      this.activeFilter = VisibilityFilter.all});

  factory AppState.loading() => AppState(isLoading: true);

  AppState copyWith({
    bool isLoading,
    List<Todo> todos,
    AppTab activeTab,
    VisibilityFilter activeFilter,
  }) {
    return AppState(
      isLoading: isLoading ?? this.isLoading,
      todos: todos ?? this.todos,
      activeTab: activeTab ?? this.activeTab,
      activeFilter: activeFilter ?? this.activeFilter,
    );
  }

  @override
  int get hashCode =>
      isLoading.hashCode ^
      todos.hashCode ^
      activeTab.hashCode ^
      activeFilter.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          todos == other.todos &&
          activeTab == other.activeTab &&
          activeFilter == other.activeFilter;

  @override
  String toString() {
    return 'AppState{isLoading: $isLoading, todos: $todos, activeTab: $activeTab, activeFilter: $activeFilter}';
  }
}
