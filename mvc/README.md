# MVC
MVC was first conceived some forty years ago by a visiting scientist at Xerox Palo Alto Research Laboratory (PARC) in California by the name of, Trygve Reenskaug. Most of the more recent design patterns are reflections of this original. It is hoped, this sample app will successfully convey how one might implement MVC when developing software.

Note, the publicly available package, [mvc_pattern](https://pub.dartlang.org/packages/mvc_pattern), is used to demonstrate the Model-View-Controller design pattern in this particular architecture pattern sample.

##### The MVC Design Pattern and Other Architectures
Like other design patterns, MVC aims to decouple major aspects generally found in software applications. In the case of MVC, it is three particular features: the Interface, the Event Handling, and the Data. This will generally allow for more efficient and modular code, more code reuse and parallel development. Like most things, it ‘makes life easier’ if you break things down into its separate working parts. The bigger the software application; the bigger the importance to implement such design patterns.

## MVC in a nutshell:
* Controller responses to system and user events--controlling what's displayed.
* View is concerned primarily with 'how' it's displayed.
* Model is the Controller’s data source for what's displayed or not.

In many MVC arrangements, the View knows how to ‘talk to’ the Controller, and the Controller knows how to ‘talk to’ the Model. However, the View and the Model each have no idea of the other’s existence.
![pac pattern](https://camo.githubusercontent.com/a5b152ecc2f2b96b8019941a7382f47f4ac4c2b6/68747470733a2f2f692e696d6775722e636f6d2f723443317932382e706e67)

(View calls Controller functions; Controller calls Model functions.)

Such a characteristic allows one, for example, to switch out and put in a different Model with little consequence. The 'new' Model need only conform to the API requirements so the Controller can ‘talk to’ it correctly. Conceivably, in turn, a 'new' View could be introduced aligned with the same functions names (same api) so it too correctly 'talks to' the Controller. Each is decoupled from the other two to such a degree that modification of any one component should not adversely effect the other two.

However, the 'lines of communication' can be changed depending on the application's particular needs, but the 'separation of responsibilities' generally remain the same.

![mvc pattern](https://user-images.githubusercontent.com/32497443/47087587-6614ed00-d1ea-11e8-8fc3-ced0ac6af12a.jpg)
![controllermodels](https://user-images.githubusercontent.com/32497443/47764873-a457e500-dc9d-11e8-8d89-2f1b8521335e.jpeg)
## Flutter and MVC
With the understanding that ‘the Interface’, 'the event handling' and ‘the data’ are now to be separated when using this design pattern, it's currently concluded in this MVC package that the **build()** function found in a typical **Stateful** or **Stateless** Widget will represent 'the View', while anything 'called' inside that function or any 'events' occurring within that function will execute code typically found in 'the Controller.'

In this sample app, for example, the add_edit_screen.dart file involved in adding or editing a 'ToDo' item, is highlighted below where the 'Controller' is referenced. Most references are found within the **build()** function. If, for example, the user presses a button to add or save a 'ToDo' item, the Controller is called upon (see last arrow) to repsond to the event.
![add_edit_screen](https://user-images.githubusercontent.com/32497443/47756814-fedf4a00-dc79-11e8-95b5-13f3b864ce1c.jpg)
## Begin Your MVC App
In the screenshot below, you see the implementation of the MVC library package. The class, MVCApp, extends the class, AppMVC, found in the MVC library package. In this one screenshot, you can also see both the Controller and the View. The class, MVCApp, instantiates the Controller as a parameter to its superclass's constructor while the View is essentially the Widget returned from the **build()** function.
![02mvcapp](https://user-images.githubusercontent.com/32497443/47758418-559c5200-dc81-11e8-961e-1a18548216c4.jpg)
In the main.dart file, you see the usual **runApp()** function:
![01main dart](https://user-images.githubusercontent.com/32497443/47758766-db6ccd00-dc82-11e8-9f83-29c57ad73aa2.jpg)
## The Controller
Looking at just the first few lines of the Controller, you can see a lot is happening here. For example, you can see the [dependency injection](https://en.wikipedia.org/wiki/Dependency_injection) in the form of a list of import statements taking in only what the Controller depends on to fulfill its function. And so, it's here where the Model is instantiated as it is only here where it is readily used. The View has no knowledge of the Model nor does it need to at this point.
![controller](https://user-images.githubusercontent.com/32497443/48212521-c5799f00-e349-11e8-9280-e25bb49086a7.png)
However, note the variable, model, is static and is not 'library-private' (no leading underscore). This allows the developer, if they wish, to externally reference the Model so to access its public functions and properties. Depending on the circumstances, this may be desired. At this point, the developer has that option. Of course, adding an underscore would then change those 'lines of communication'.

The 'VisibiltyFilter' is concerned with 'what' type of 'ToDo' items are displayed (what is displayed) at any one time in this 'ToDo' app. As it happens, this concern is also one of the responsibilities of the Controller, and so this 'filter' is implemented only in the Controller.

Finally, note the Controller uses a factory constructor. This allows for the Controller to be instantiated once, but referenced everywhere if need be. However, the developer has the option to use a getter instead to access the Controller. Again, doing so allows for easy access to the Controller throughout the rest of the application:
![concon](https://user-images.githubusercontent.com/32497443/47794282-8a96bc00-dcf6-11e8-8a7e-3a602649e753.jpg)
## The Controller and its Model
The Controller is fully listed below, and you can see highlighted where the Model is called to retrieve, save and update the data source (whatever that data source may be). The View nor the Controller 'knows' what type of data source it is, or what type of database the data resides in. They don't need to. The Model takes care of that.
![controller](https://user-images.githubusercontent.com/32497443/48216483-d5e24780-e352-11e8-8e2c-47e12fac8ba6.png)
##### What's in a name? (or API?)
Looking closely at the code, you can see the Controller's public functions have names that don't always match the Model functions they, in turn, call. This is part of the decoupling that's possible with this design pattern. For instanct, the View need only know the names of the Controller's public functions and public fields (the Controller's API). Retain the Controller's API (In other words, keep those public function names consistant over time), and the Model is able to be changed more freely. Only the Controller would then have to address any Model changes. It's no concern to any other part of the application thus encouraging modular coding.
##### How about the Model?
Looking at the Model in this sample (see below), and you can see that it itself has its own Model to work with---unbeknownst to the rest of the application. For this app, this Model serves to 'convert' the data format from its own data source to a format eventually used by the View.
##### I Scooped the Scoped Model!
For full disclosure, I may have taken liberties as I chose to abscond the 'Model' and 'localization' code from Brian Egan's own 'Scoped Model' contribution to possibly accentuate my own. Again, to demonstrate how a MVC's Model, at times, may be used 'to convert' a data source to a format suitable to own its application.
![model](https://user-images.githubusercontent.com/32497443/47763415-0234fe80-dc97-11e8-9967-c7a5cef11e32.jpg)
##### Map the Data
 We're just using a Map for the View instead of a Middle man class, like a TodoViewModel. In this 'ToDo' app sample, the data is displayed using Dart's own [Map](https://www.dartlang.org/guides/language/language-tour#maps) built-in type (see below). However, the 'repository' offered by all of us contributing to this [Flutter Architecture Samples](http://fluttersamples.com/) project does not. Instead, it uses the class, [TodoEntity](https://github.com/brianegan/flutter_architecture_samples/blob/master/todos_repository/lib/src/todo_entity.dart). I decided to demonstrate this 'conduit' role sometimes play by a Model. Of course, the rest of the sample app is unaware of the conversion therefore required.
![add_edit_screen2](https://user-images.githubusercontent.com/32497443/47791412-08a39480-dcf0-11e8-864c-69c0725e625d.jpg)
##### The Model is the Conduit
Again, in this particular 'ToDo' app sample, the MVC implementation has the Model play the role of 'conduit.' It lies between the data repository supplied by the makers of this project and the rest of this application.
![conroller2models](https://user-images.githubusercontent.com/32497443/47765618-30b7d700-dca1-11e8-98b0-2d1ee2c5a112.jpeg)
Looking at the class, TodoListModel, which is called by our Model class, you can see it is concerned with that data repository. It imports only that which it depends on, and changes the 'format' of the data where appropriate.
![todo_list_model](https://user-images.githubusercontent.com/32497443/47764056-d7987500-dc99-11e8-90d0-e62b60546993.jpg)
In turn, the class, Todo, is called by the class, TodoListModel. It mirrors the project's class, TodoEntity, and is used 'to bridge' information between those two classes. Again, this modular approach hides this fact from the rest of the application.
![models](https://user-images.githubusercontent.com/32497443/47764337-10851980-dc9b-11e8-8e89-61d009f5cd0d.jpg)
```dart
```


Further information on the MVC package can be found in the article, [‘Flutter + MVC at Last!’](https://medium.com/p/275a0dc1e730/)
[![online article](https://user-images.githubusercontent.com/32497443/47087365-c9524f80-d1e9-11e8-85e5-6c8bbabb18cc.png)](https://medium.com/flutter-community/flutter-mvc-at-last-275a0dc1e730)

[Repository (GitHub)](https://github.com/AndriousSolutions/mvc_pattern)

[API Docs](https://pub.dartlang.org/documentation/mvc_pattern/latest/mvc_pattern/mvc_pattern-library.html)
