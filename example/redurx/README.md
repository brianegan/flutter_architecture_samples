# ReduRx

An example Todo app created with [built_value](https://pub.dartlang.org/packages/built_value), [redurx](https://pub.dartlang.org/packages/redurx), and [flutter_redurx](https://pub.dartlang.org/packages/flutter_redurx).

## Key Concepts

  * `built_value` is **not required** you're free to represent your State by other ways.
  * It is Redux-based, not a attempt to be a Redux port.
  * Unnecessary rebuilds are intolerable, that is why `where` is explicitly set by who knows about the State: you!
  * **Actions** holds it's own **reducers**.
