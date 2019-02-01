// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:meta/meta.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

@immutable
class User {
  final String displayName;

  User(this.displayName);

  UserEntity toEntity() => UserEntity(displayName: displayName);

  static User fromEntity(UserEntity entity) => User(entity.displayName);

  @override
  String toString() {
    return 'User{displayName: $displayName}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          displayName == other.displayName;

  @override
  int get hashCode => displayName.hashCode;
}
