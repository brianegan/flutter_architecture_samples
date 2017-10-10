import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter_mvc/src/localizations/messages_all.dart';

class ArchitectureLocalizations {
  ArchitectureLocalizations(this.locale);

  final Locale locale;

  static Future<ArchitectureLocalizations> load(Locale locale) {
    return initializeMessages(locale.toString()).then((Null value) {
      return new ArchitectureLocalizations(locale);
    });
  }

  static ArchitectureLocalizations of(BuildContext context) {
    return Localizations.of<ArchitectureLocalizations>(
        context, ArchitectureLocalizations);
  }

  String get todos => Intl.message(
        'Todos',
        name: 'todos',
        args: [],
        locale: locale.toString(),
      );

  String get stats => Intl.message(
        'Stats',
        name: 'stats',
        args: [],
        locale: locale.toString(),
      );

  String get showAll => Intl.message(
        'Show All',
        name: 'showAll',
        args: [],
        locale: locale.toString(),
      );

  String get showActive => Intl.message(
        'Show Active',
        name: 'showActive',
        args: [],
        locale: locale.toString(),
      );

  String get showCompleted => Intl.message(
        'Show Completed',
        name: 'showCompleted',
        args: [],
        locale: locale.toString(),
      );

  String get newTodoHint => Intl.message(
        'What needs to be done?',
        name: 'newTodoHint',
        args: [],
        locale: locale.toString(),
      );

  String get markAllComplete => Intl.message(
        'Mark all complete',
        name: 'markAllComplete',
        args: [],
        locale: locale.toString(),
      );

  String get markAllIncomplete => Intl.message(
        'Mark all incomplete',
        name: 'markAllIncomplete',
        args: [],
        locale: locale.toString(),
      );

  String get clearCompleted => Intl.message(
        'Clear completed',
        name: 'clearCompleted',
        args: [],
        locale: locale.toString(),
      );

  String get addTodo => Intl.message(
        'Add Todo',
        name: 'addTodo',
        args: [],
        locale: locale.toString(),
      );

  String get editTodo => Intl.message(
        'Edit Todo',
        name: 'editTodo',
        args: [],
        locale: locale.toString(),
      );

  String get saveChanges => Intl.message(
        'Save changes',
        name: 'saveChanges',
        args: [],
        locale: locale.toString(),
      );

  String get filterTodos => Intl.message(
        'Filter Todos',
        name: 'filterTodos',
        args: [],
        locale: locale.toString(),
      );

  String get deleteTodo => Intl.message(
        'Delete Todo',
        name: 'deleteTodo',
        args: [],
        locale: locale.toString(),
      );

  String get todoDetails => Intl.message(
        'Todo Details',
        name: 'todoDetails',
        args: [],
        locale: locale.toString(),
      );

  String get emptyTodoError => Intl.message(
        'Please enter some text',
        name: 'emptyTodoError',
        args: [],
        locale: locale.toString(),
      );

  String get notesHint => Intl.message(
        'Additional Notes...',
        name: 'notesHint',
        args: [],
        locale: locale.toString(),
      );

  String get completedTodos => Intl.message(
        'Completed Todos',
        name: 'completedTodos',
        args: [],
        locale: locale.toString(),
      );

  String get activeTodos => Intl.message(
        'Active Todos',
        name: 'activeTodos',
        args: [],
        locale: locale.toString(),
      );

  String todoDeleted(String task) => Intl.message(
        'Deleted "$task"',
        name: 'todoDeleted',
        args: [],
        locale: locale.toString(),
      );

  String get undo => Intl.message(
        'Undo',
        name: 'undo',
        args: [],
        locale: locale.toString(),
      );

  String get deleteTodoConfirmation => Intl.message(
        'Delete this todo?',
        name: 'deleteTodoConfirmation',
        args: [],
        locale: locale.toString(),
      );

  String get delete => Intl.message(
        'Delete',
        name: 'delete',
        args: [],
        locale: locale.toString(),
      );

  String get cancel => Intl.message(
        'Cancel',
        name: 'cancel',
        args: [],
        locale: locale.toString(),
      );
}

class ArchitectureLocalizationsDelegate
    extends LocalizationsDelegate<ArchitectureLocalizations> {
  @override
  Future<ArchitectureLocalizations> load(Locale locale) =>
      ArchitectureLocalizations.load(locale);

  @override
  bool shouldReload(ArchitectureLocalizationsDelegate old) => false;
}
