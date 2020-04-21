class PersistanceException extends Error {
  final String message;
  PersistanceException(this.message);
  @override
  String toString() {
    return message.toString();
  }
}
