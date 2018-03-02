# flutter_architecture_samples

<img align="right" src="assets/todo-list.png" alt="List of Todos Screen">

[TodoMVC](http://todomvc.com) for Flutter!

Flutter provides a lot of flexibility in deciding how to organize and architect your apps. While this freedom is very valuable, it can also lead to apps with large classes, inconsistent naming schemes, as well as mismatching or missing architectures. These types of issues can make testing, maintaining and extending your apps difficult.

The Flutter Architecture Samples project demonstrates strategies to help solve or avoid these common problems. This project implements the same app using different architectural concepts and tools.

You can use the samples in this project as a learning reference, or as a starting point for creating your own apps. The focus of this project is on demonstrating how to structure your code, design your architecture, and the eventual impact of adopting these patterns on testing and maintaining your app. You can use the techniques demonstrated here in many different ways to build apps. Your own particular priorities will impact how you implement the concepts in these projects, so you should not consider these samples to be canonical examples. To ensure the focus is kept on the aims described above, the app uses a simple UI.

### Current Samples

To run the samples, please use the `beta` channel and Dart 1 for now. We'll update to Dart 2 soon!

  * [Lifting State Up (Vanilla) Example](example/vanilla) - Uses the tools Flutter provides out of the box to manage app state.
  * [InheritedWidget Example](example/inherited_widget) - Uses an InheritedWidget to pass app state down the widget hierarchy.
  * [Redux Example](example/redux) - Uses the [Redux](https://pub.dartlang.org/packages/redux) library to manage app state and update Widgets
  * [built_redux Example](example/built_redux) - Uses the [built_redux](https://pub.dartlang.org/packages/built_redux) library to enforce immutability and manage app state
  * [scoped_model Example](example/scoped_model) - Uses the [scoped_model](https://pub.dartlang.org/packages/scoped_model) library to hold app state and notify Widgets of Updates
  
### Supporting Code

  * [integration_tests](example/integration_tests) - Demonstrates how to write selenium-style integration (aka end to end) tests using the Page Object Model. This test suite is run against all samples.
  * [todos_repository](example/todos_repository) - Demonstrates the repository pattern and testing strategies for working with the filesystem. Used to provide local storage and mock web storage to samples.     
  
### Why a todo app?
   
The app in this project aims to be simple enough that you can understand it quickly, but complex enough to showcase difficult design decisions and testing scenarios. For more information, see the [app's specification](app_spec.md).

### Be excellent to each other

This Repo is meant as a discussion platform for various architectures. Let us debate these ideas vigorously, but let us be excellent to each other in the process! 

While healthy debate and contributions are very welcome, trolls are not. Read the [code of conduct](code-of-conduct.md) for detailed information. 

### Contributing

Feel free to join in the discussion, file issues, and we'd love to have more samples added! Please read the [CONTRIBUTING](CONTRIBUTING.md) file for guidance :)

### License

All code in this repo is MIT licensed.

## Attribution

All of these ideas and even some of the language are directly influenced by two projects:

  - [TodoMVC](http://todomvc.com) - A Todo App implemented in various JS frameworks
  - [Android Architecture Blueprints](https://github.com/googlesamples/android-architecture) - A similar concept, but for Android! The UI and app spec was highly inspired by their example. 
