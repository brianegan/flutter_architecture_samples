import 'package:states_rebuilder_sample/domain/exceptions/validation_exception.dart';
import 'package:states_rebuilder_sample/service/exceptions/persistance_exception.dart';

class ErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is ValidationException) {
      return error.message;
    }

    if (error is PersistanceException) {
      return error.message;
    }

    throw (error);
  }
}
