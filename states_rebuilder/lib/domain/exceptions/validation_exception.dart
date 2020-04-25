class ValidationException extends Error {
  final String message;

  ValidationException(this.message);
  @override
  String toString() {
    return message;
  }
}
