import 'package:meta/meta.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

@immutable
class User {
  final String displayName;

  User({required this.displayName});

  UserEntity toEntity() =>
      UserEntity(displayName: displayName, id: '', photoUrl: '');

  static User fromEntity(UserEntity entity) =>
      User(displayName: entity.displayName);

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
