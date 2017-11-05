# flutter_architecture_samples

<img align="right" src="assets/todo-list.png" alt="List of Todos Screen">

[TodoMVC](http://todomvc.com) for Flutter!

Flutter provides a lot of flexibility in deciding how to organize and architect an your apps. While this freedom is very valuable, it can also lead to apps with large classes, inconsistent naming schemes, as well as mismatching or missing architectures. These types of issues can make testing, maintaining and extending your apps difficult.

The Flutter Architecture Samples project demonstrates strategies to help solve or avoid these common problems. This project implements the same app using different architectural concepts and tools.

You can use the samples in this project as a learning reference, or as a starting point for creating your own apps. The focus of this project is on demonstrating how to structure your code, design your architecture, and the eventual impact of adopting these patterns on testing and maintaining your app. You can use the techniques demonstrated here in many different ways to build apps. Your own particular priorities will impact how you implement the concepts in these projects, so you should not consider these samples to be canonical examples. To ensure the focus is kept on the aims described above, the app uses a simple UI.

### Current Samples

  * [Vanilla Example](https://gitlab.com/brianegan/flutter_architecture_samples/tree/master/example/vanilla) - Uses the tools Flutter provides out of the box to manage app state.
  * [Redux Example](https://gitlab.com/brianegan/flutter_architecture_samples/tree/master/example/redux) - Uses the [Redux](https://pub.dartlang.org/packages/redux) library to manage app state and update Widgets
  * [built_redux Example](https://gitlab.com/brianegan/flutter_architecture_samples/tree/master/example/built_redux) - Uses the [built_redux](https://pub.dartlang.org/packages/built_redux) library to manage app state and update Widgets
  
### Why a to-do app?
   
The app in this project aims to be simple enough that you can understand it quickly, but complex enough to showcase difficult design decisions and testing scenarios. For more information, see the [app's specification](https://gitlab.com/brianegan/flutter_architecture_samples/blob/master/app_spec.md).

### Be excellent to each other

This Repo is meant as a discussion platform for various architectures. Let us debate these ideas vigorously, but let us be excellent to each other in the process! 

While healthy debate and contributions are very welcome, trolls are not. Read the [code of conduct](https://gitlab.com/brianegan/flutter_architecture_samples/blob/master/code-of-conduct.md) for detailed information. 

### Contributing new samples

We'd love to have more samples added! Please read the [CONTRIBUTING](https://gitlab.com/brianegan/flutter_architecture_samples/blob/master/CONTRIBUTING.md) file for guidance :)

### License

All code in this repo is MIT licensed.

## Attribution

All of these ideas and even some of the language are directly influenced by two projects:

  - [TodoMVC](http://todomvc.com) - A Todo App implemented in various JS frameworks
  - [Android Architecture Blueprints](https://github.com/googlesamples/android-architecture) - A similar concept, but for Android! The UI and app spec was highly inspired by their example. 