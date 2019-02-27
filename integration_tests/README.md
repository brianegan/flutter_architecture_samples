# Integration tests

The Integration (aka end to end tests) that should be run against every sample app.

## Key Concepts

  * `flutter_driver` is used to drive the tests.
  * The tests are structured using the Page Object Model

## Drive tests with `flutter_driver`

In order to run tests on against your app, you need to use the `flutter_driver`. This tool allows you to find Widgets on screen and send commands to them. This allows you to tap on Widgets, scroll through lists, or get the text of a Text Widget.

To run the tests
  1. cd \<app>/ (e.g. `cd vanilla/`)
  2. flutter drive --target test_driver/todo_app.dart

To get started with Flutter Driver, please check out the following links:

  * [How to write an integration test in Flutter](http://cogitas.net/write-integration-test-flutter/) by [Natalie Masse Hooper](https://twitter.com/NatJM)
  * Visit the [Flutter Testing](https://flutter.io/testing/#integration-testing) page.

## Organize Code with the Page Object Model

In order to make tests more readable and maintainable, this test suite demonstrates how to structure tests using the Page Object Model (POM) pattern. What is the Page Object Model? It's best to demonstrate through code.

Let's take a pretty standard test and refactor it using the POM pattern. This is a simplified example, for a more complete example please view the files in the `lib` folder.

```dart
test("Should wait for the list to load then tap on the first todo", () async {
  final driver = await FlutterDriver.connect();
  final todoListFinder = find.byValueKey('__todoList__');
  final detailsScreenFinder = find.byValueKey('__detailsScreen__');
  final backButtonFinder = find.byTooltip('Back');
  final firstTodoListItemFinder = find.byValueKey('__todoListItem_1_task__')

  expect(
    driver.waitFor(todoListFinder),
    completes,
  );

  expect(await driver.getText(firstTodoListItemFinder), isNotEmpty);

  await driver.tap(firstTodoListItemFinder);

  expect(driver.waitFor(detailsScreenFinder), completes);

  await driver.tap(backButtonFinder);

  expect(driver.waitFor(todoListFinder), completes);
});
```

It's not bad, but it's not great either. First, it's a bit difficult to read this test and fully understand the intention behind each step without adding comments.

Second, what if the UI changes a bit? We would need to find each test that references these parts of the UI and update each one! This demonstrates a lack of separation between test code and driver commands.

The Page Object Model helps solve these problems. Let's take a look at this same test written with the Page Object Model pattern.

```dart
test("Should wait for the list to load then tap on the first todo", () async {
  final driver = await FlutterDriver.connect();
  final homeScreen = new HomeTestScreen(driver);

  expect(await homeScreen.isReady, isTrue);
  expect(await homeScreen.todo("1"), isNotEmpty);

  final detailsScreen = firstTodo.tap();

  expect(await detailsScreen.isReady, isTrue);

  await detailsScreen.tapBackButton();

  expect(await homeScreen.isReady, isTrue);
});

class HomeTestScreen {
  final _todoListFinder = find.byValueKey('__todoList__');
  final FlutterDriver driver;

  HomeTestScreen(this.driver);

  Future<bool> get isReady {
    return driver
      .waitFor(_todoListFinder)
      .then((_) => true)
      .catchError((_) => false);
  }

  TodoItemElement todo(String id) {
    return new TodoItemElement(driver, id);
  }
}

class DetailsTestScreen {
  final _detailsScreenFinder = find.byValueKey('__detailsScreen__');
  final _backButtonFinder = find.byTooltip('Back');
  final FlutterDriver driver;

  DetailsTestScreen(this.driver);

  Future<bool> get isReady {
    return driver
      .waitFor(_detailsScreenFinder)
      .then((_) => true)
      .catchError((_) => false);
  }

  void tapBackButton() {
    driver.tap(_backButtonFinder);
  }
}

class TodoItemElement {
  final FlutterDriver driver;
  final String id;

  TodoItemElement(this.driver, this.id);

  SerializableFinder get _taskFinder =>
    find.byValueKey('__todoListItem_${id}_task__');

  Future<String> get task => driver.getText(_taskFinder);

  DetailsTestScreen tap() {
    driver.tap(_taskFinder);

    return new DetailsTestScreen(driver);
  }
}
```

As you can see, we've ended up with more code, but we've gained a few things:

  1. The tests themselves are now easier to read.
  2. We can reuse these classes throughout our tests. Overall, this will *reduce* the amount of code you need to write in tests!
  3. If these Widget change a bit in your app, such as after a redesign, you can update the classes themselves to reflect the changes. In many cases, this will result in little to no changes to your actual tests!

## Missing Features

For now, there are a few things that aren't properly tested.

  - Adding / Editing Todos: There is no way to send text input via `flutter_driver`
  - Checkboxes: There is no way to tell if a Checkbox is checked or not.
