// This line imports the extension
import 'package:flutter_driver/driver_extension.dart';
import 'package:redux_sample/main.dart' as app;

void main() {
  // This line enables the extension
  enableFlutterDriverExtension(handler: (message) async {
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    print("$message");
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    return message;
  });

  app.main();
}
