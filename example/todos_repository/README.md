# todos_repository

An app-agnostic data source that can be used by sample apps to fetch and persist data. 

## Getting Started

The code is in `example/todos_repository/lib/`.

The tests can be run from the command line

```
cd flutter_architecture_samples/example/todos_repository
flutter test
```

## Key Concepts

  * Provides a clean interface to the data layer
  * Does not expose *how* the data is fetched and stored
  * Can be a pure Dart library or a Flutter library 
  
## Provides a clean interface to the data layer

The goal of the repository pattern is to provide a clean interface to the data layer of your application. The data layer manages how things are fetched and stored, but should not expose how those things happen. 

The term "Data Layer" comes from the "Clean Architecture Pattern." In this pattern, we separate our app into layers. Each Layer should only talk to the layer after it.

   * Presentation Layer -- Flutter Widgets! Is given data from the Domain Layer and converts it into a UI. Tested with `flutter_test`.
   * Domain Layer -- How we manage App State changes and communicate those to the data layer. Can generally be written and tested as a pure Dart code.
   * Data layer -- Provides a single interface to the storage mechanisms (in-memory, on disk, web, etc).

## Does not expose *how* the data is fetched and stored

It does not expose the in-memory, web client, or file storage mechanisms directly, but internally manages how to perform these tasks.

This separation provides several benefits:

  * We could change the underlying File Storage mechanism without requiring any of of the Flutter apps to change. Currently, the file storage works by saving json to disk. We could instead use Firebase or an SQLLite database and the apps would never know the difference!
  * We can control the the fallback logic in a central place. E.g. We first try to read todos from memory, then from disk, then from the web. We can always change the way this works.
  * We can compose several different types of data sources together into a single, easy-to-consume Entity.
  
## Dart Library or Flutter Library?

Generally speaking, if a library can be a pure Dart library, it probably should be. This makes it far easier to reuse because it has far fewer dependencies and easier to test because you do not have to mock out the Flutter environment.

For example, in order to test the File Storage part of this library, we have two options:

  1. Make this a pure Dart Lib
     - The `FileStorage` class takes a `getDirectory` function that will provide the correct `Directory` for the given situation. 
     - In Flutter, we'll pass through the `path_provider` function `getApplicationDocumentDirectory`. 
     - In tests, we'll pass through a function that provides a temporary directory on disk.
  2. Make this a Flutter library
      - In this case, the library will require `path_provider` directly.
      - In your flutter app, everything should "just work" since you're depending on the environment directly.
      - In tests, you need to mock the `MethodChannel` and return a temporary directory on disk for the correct situation.
    
Overall, it's not too much more difficult to test these one way or the other. However, if you can avoid pulling in large dependencies, such as Flutter, you should. This will make it easier to use this library in other, pure Dart libs, or even in web projects, and will still function perfectly within your Flutter projects.
