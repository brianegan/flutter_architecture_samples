class UserEntity {
  final String id;
  final String displayName;
  final String photoUrl;

  UserEntity({
    required this.id,
    required this.displayName,
    required this.photoUrl,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          displayName == other.displayName &&
          photoUrl == other.photoUrl;

  @override
  int get hashCode => id.hashCode ^ displayName.hashCode ^ photoUrl.hashCode;

  @override
  String toString() {
    return 'UserEntity{id: $id, displayName: $displayName, photoUrl: $photoUrl}';
  }
}
