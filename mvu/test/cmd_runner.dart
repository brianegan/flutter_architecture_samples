import 'package:dartea/dartea.dart';

///run side-effects and save produced messages to the [producedMessages] list
class CmdRunner<T> {
  final producedMessages = <T>[];

  void run(Cmd<T> cmd) {
    for (var effect in cmd) {
      effect((m) => producedMessages.add(m));
    }
  }

  void invalidate() => producedMessages.clear();
}
