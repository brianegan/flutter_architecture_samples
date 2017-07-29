
class FlutterMvcStrings {
  static final String all = "All";
  static final String active = "Active";
  static final String completed = "Completed";
  static final String hintText = "What needs to be done?";

  String itemsLeft(int numTodos) {
    return '$numTodos item${numTodos != 1 ? 's' : ''} left';
  }
}
