# `states_rebuilder`

[![pub package](https://img.shields.io/pub/v/states_rebuilder.svg)](https://pub.dev/packages/states_rebuilder)
[![CircleCI](https://circleci.com/gh/GIfatahTH/states_rebuilder.svg?style=svg)](https://circleci.com/gh/GIfatahTH/states_rebuilder)
[![codecov](https://codecov.io/gh/GIfatahTH/states_rebuilder/branch/master/graph/badge.svg)](https://codecov.io/gh/GIfatahTH/states_rebuilder)


A Flutter state management combined with dependency injection solution that allows : 
  * a 100% separation of User Interface (UI) representation from your logic classes
  * an easy control on how your widgets rebuild to reflect the actual state of your application.
Model classes are simple vanilla dart classes without any need for inheritance, notification, streams or annotation and code generation.


`states_rebuilder` is built on the observer pattern for state management.

> **Intent of observer pattern**    
>Define a one-to-many dependency between objects so that when one object changes state (observable object), all its dependents (observer objects) are notified and updated automatically.

`states_rebuilder` state management solution is based on what is called the `ReactiveModel`.

## What is a `ReactiveModel`
* It is an abstract class.
* In the context of observer model (or observable-observer couple), it is the observable part. observer widgets can subscribe to it so that they can be notified to rebuild.
* It exposes two getters to get the latest state (`state` , `value`)
* It offers two methods to mutate the state and notify observer widgets (`setState` and `setValue`). `state`-`stateState` is used for mutable objects, whereas `value`-`setValue` is more convenient for primitives and immutable objects.
* It exposes four getters to track its state status, (`isIdle`, `isWaiting`, `hasError`, and `hasData`).
* And many more ...

In `states_rebuilder`, you write your business logic part with pure dart classes, without worrying on how the UI will interact with it and get notification.
`states_rebuilder` decorate your plain old dart class with a `ReactiveModel` model using the decorator pattern.

> **Intent of decorator pattern**    
> Adds new behaviors to objects by placing these objects inside special wrapper objects that contain the behaviors.

`ReactiveModel` decorates your plain old dart class with the following behaviors: 

The getters are : 
* **state**: returns the registered raw singleton of the model.
* **value**: returns the registered raw singleton of the model.
* **connectionState** : It is of type `ConnectionState` (a Flutter defined enumeration). It takes three values:  
      1- `ConnectionState.none`: Before executing any method of the model.  
      2- `ConnectionState.waiting`: While waiting for the end of an asynchronous task.   
      3- `ConnectionState.done`: After running a synchronous method or the end of a pending asynchronous task.  
* **isIdle** : It's of bool type. it is true if `connectionState` is `ConnectionState.none`
* **isWaiting**: It's of bool type. it is true if `connectionState` is `ConnectionState.waiting`
* **hasError**: It's of bool type. it is true if the asynchronous task ends with an error.
* **error**: Is of type dynamic. It holds the thrown error.
* **hasData**: It is of type bool. It is true if the connectionState is done without any error.

The fields are:
* **joinSingletonToNewData** : It is of type dynamic. It holds data sent from a new reactive instance to the reactive singleton.
* **subscription** : it is of type `StreamSubscription<T>`. It is not null if you inject streams using `Inject.stream` constructor. It is used to control the injected stream.   

The methods are:
* **setState**: return a `Future<void>`. It is used to mutate the state and notify listeners after state mutation.
* **setValue**: return a `Future<void>` It is used to mutate the state and notify listeners after state mutation. It is equivalent to `setState` with the parameter `setValue` set to true. **setValue** is most suitable for immutables whereas **setState** is more convenient for mutable objects.
* **whenConnectionState** Exhaustively switch over all the possible statuses of [connectionState]. Used mostly to return [Widget]s. It has four required parameters (`onIdle`, `onWaiting`, `onData` and `onError`).
* **restToIdle** used to reset the async connection state to `isIdle`.
* **restToHasData** used to reset the async connection state to `hasData`.
* **onError** a global error handler callback.
* **stream** listen to a stream from the state and notify observer widgets when it emits a data.
* **future** link to a future from the state and notify observers when it resolves.

## Local and Global `ReactiveModel`:

ReactiveModels are either local or global. 
In local `ReactiveModel`, the creation of the `ReactiveModel` and subscription and notification are all limited in one place (widget).
In Global `ReactiveModel`, the `ReactiveModel` is created once, and it is available for subscription and notification throughout all the widget tree.

### Local ReactiveModels

Let's start by building the simplest counter app you have ever seen:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //StateBuilder is used to subscribe to ReactiveModel
      home: StateBuilder<int>(
        //Creating a local ReactiveModel that decorate an int value
        //with initial value of 0
        observe: () => RM.create<int>(0),
        //The builder exposes the BuildContext and the instance of the created ReactiveModel
        builder: (context, counterRM) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              //use the value getter to get the latest state stored in the ReactiveModel
              child: Text('${counterRM.value}'),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              //get and increment the value of the counterRM.
              //on mutating the state using the value setter the observers are automatically notified
              onPressed: () => counterRM.value++,
            ),
          );
        },
      ),
    );
  }
}
```
* The Observer pattern:
    * `StateBuilder` widget is one of four observer widgets offered by `states_rebuilder` to subscribe to a `ReactiveModel`.
    *  in `observer` parameter we created and subscribed to a local ReactiveModel the decorated an integer value with initial value of 0.
        With states_rebuilder we can created ReactiveModels form primitives, pure dart classes, futures or streams:
        ```dart
        //create for objects
        final fooRM = RM.create<Foo>(Foo());
        //create from Future
        final futureRM = RM.future<T>(myFuture);
        //create from stream
        final streamRM = RM.stream<T>(myStream);
        //the above statement are shortcuts of the following 
        final fooRM = ReactiveModel<Foo>.create(Foo());
        final futureRM = ReactiveModel<T>.future(futureRM);
        final streamRM = ReactiveModel<T>.stream(streamRM);
        ```
    * The `builder` parameter exposes the BuildContext and the the created instance of the `ReactiveModel`.
    * To notify the subscribed widgets (we have one StateBuilder here), we just incremented the value of the counterRM
        ```dart
        onPressed: () => counterRM.value++,
        ```
* The decorator pattern:
    * ReactiveModel decorates a primitive integer of 0 initial value and adds the following functionality:
        * The 0 is an observable ReactiveModel and widget can subscribe to it.
        * The value getter and setter to increment the 0 and notify observers


In the example above the rebuild is not optimized, because the whole Scaffold rebuild to only change a little text at the center fo the screen.

Let's optimize the rebuild and introduce the concept of ReactiveModel keys (`RMKey`).

```dart
class MyApp extends StatelessWidget {
  //define a ReactiveModel model key of type int and optional initial value
  final RMKey counterRMKey = RMKey<int>(0);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: StateBuilder<int>(
              observe: () => RM.create<int>(0),
              //associate this StateBuilder to the defined key
              rmKey: counterRMKey,
              builder: (context, counterRM) {
                return Text('${counterRM.value}');
              }),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          //increment the counter value and notify observers using the ReactiveModel key
          onPressed: () => counterRMKey.value++,
        ),
      ),
    );
  }
}
```

In a similar fashion on How global key are used in Flutter, we use ReactiveModel key to control a local ReactiveModel from outside its builder method of the widget where it is first created.
First,we instantiate a RMKey :
```dart
final RMKey counterRMKey = RMKey<int>(0);
```
Unlike Flutter global keys, you do not have to use StatefulWidget, because in states_rebuilder the state of RMKey is preserved even if the widget is rebuild.

The next step is to associate the RMKey with a ReactiveModel, as done through the rmKey parameter of the StateBuilder widget.

RMKey has all the functionality of the ReactiveModel is is associate with. You can call setState, setValue, get the state and its status.
```dart
onPressed: () => counterRMKey.value++,
```
For more details on RMKey see here.

As I said, ReactiveModel is a decorator over an object. Among the functionalities add, is the ability to track the asynchronous status of the state.
Let's see with an example:

```dart
//create an immutable object
@immutable
class Counter {
  final int count;

  Counter(this.count);

  Future<Counter> increment() async {
    //simulate a delay
    await Future.delayed(Duration(seconds: 1));
    //simulate an error
    if (Random().nextBool()) {
      throw Exception('A Custom Message');
    }
    return Counter(count + 1);
  }
}

class MyApp extends StatelessWidget {
  //use a RMKey of type Counter
  final counterRMKey = RMKey<Counter>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Center(
          //WhenRebuilder is a widget that is used to subscribe to an observable model.
          //It Exhaustively goes through the four possible status of the state and define the corresponding widget.
          child: WhenRebuilder<Counter>(
            observe: () => RM.create(Counter(0)),
            rmKey: counterRMKey,
            //Before and action
            onIdle: () => Text('Tap to increment the counter'),
            //While waiting for and asynchronous task to end
            onWaiting: () => Center(
              child: CircularProgressIndicator(),
            ),
            //If the asynchronous task ends with error
            onError: (error) => Center(child: Text('$error')),
            //If data is available
            onData: (counter) {
              return Text('${counter.count}');
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          //We use setValue to change the Counter state and notify observers
          onPressed: () async => counterRMKey.setValue(
            () => counterRMKey.value.increment(),
            //set catchError to true
            catchError: true,
          ),
        ),
      ),
    );
  }
}
```
`WhenRebuilder` is the second observer widget after `StateBuilder`. It helps you to define the corresponding view for each of the four state status (`onIdle`, `onWaiting`, `onError` and `onData`).

Notice that we used setValue method to mutate the state. If you use setValue, states_rebuilder automatically handle the asynchronous event for you. 
* This is the rule, if you want to change the state synchronously, use the value setter:
```dart
counterRMKey.value = await counterRMKey.value.increment();
```
whereas if you want to let `states_rebuilder` handle the asynchronous events use `setValue`:
```dart
counterRMKey.setValue(
  () => counterRMKey.value.increment(),
  catchError: true,
),
```
Later in this readme, I will talk about error handling with states_rebuilder. Here I only want to show you how easy error handling is with states_rebuilder.
Let's use the last example and imagine a real scenario where we want to persist the counter value in a database. We want to instantly display the incremented counter, and call an asynchronous method in the background to store the counter. If en error is thrown we want to go back to the last counter value and show a snackBar informing us about the error.

```dart
@immutable
class Counter {
  final int count;

  Counter(this.count);

  //Use stream generator instead of future
  Stream<Counter> increment() async* {
    //Yield the new counter state
    //states_rebuilder rebuilds the UI to display the new state
    yield Counter(count + 1);
    try {
      await fetchSomeThing();
    } catch (e) {
      //If an error, yield the old state
      //states_rebuilder rebuilds the UI to display the old state
      yield this;
      //We have to throw the error to let states_rebuilder handle the error
      throw e;
    }
  }
}

class MyApp extends StatelessWidget {
  final counterRMKey = RMKey<Counter>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: StateBuilder<Counter>(
            observe: () => RM.create(Counter(0)),
            rmKey: counterRMKey,
            builder: (context, counterRM) {
              return Text('${counterRM.value.count}');
            },
          ),
        ),
        floatingActionButton: Builder(builder: (context) {
          return FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async {
              //invoking the stream method from the ReactiveModel.
              //states_rebuild subscribe to the stream and rebuild the observer widget whenever the stream emits
              counterRMKey.stream((c) => c.increment()).onError(
                (context, error) {
                  //side effects here
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$error.message'),
                    ),
                  );
                },
              );
            },
          );
        }),
      ),
    );
  }
}
```
states_rebuild automatically subscribe to a stream and unsubscribe from it if the StateBuilder is disposed. 

Local `ReactiveModel` are the first choice when dealing with flutter's Input and selections widgets (Checkbox, Radio, switch,...), 
here is an example of Slider :
```dart
StateBuilder<double>(
  observe: () => RM.create(0),
  builder: (context, sliderRM) {
    return Slider(
      value: sliderRM.value,
      onChanged: (value) {
        sliderRM.value = value;
      },
    );
  },
),
```

### Global ReactiveModel
There is no difference between local and global ReactiveModel expect of the span of the availability of the ReactiveModel in the widget tree.

Global ReactiveModels are cross pages available model, they can be subscribed to in one part of the widget tree and can make send notification from the other side of the widget tree.

Regardless of the effectiveness of the state management solution, it must rely on a reliable dependency injection system.

`states_rebuilder` uses the service locator pattern, but using it in a way that makes it aware of the widget's lifecycle. This means that models are registered when needed in the `initState` method of a` StatefulWidget` and are unregistered when they are no longer needed in the `dispose` method.
Models once registered are available throughout the widget tree as long as the StatefulWidget that registered them is not disposed. The StatefulWidget used to register and unregister models is the `Injector` widget.


```dart
@immutable
class Counter {
  final int count;

  Counter(this.count);

  Future<Counter> increment() async {
    await fetchSomeThing();
    return Counter(count + 1);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //We use Injector widget to provide a model to the widget tree
    return Injector(
      //inject a list of injectable
      inject: [Inject(() => Counter(0))],
      builder: (context) {
        return MaterialApp(
          home: Scaffold(
            appBar: AppBar(),
            body: Center(
              child: WhenRebuilder<Counter>(
                //Consume the ReactiveModel of the injected Counter model
                observe: () => RM.get<Counter>(),
                onIdle: () => Text('Tap to increment the counter'),
                onWaiting: () => Center(
                  child: CircularProgressIndicator(),
                ),
                onError: (error) => Center(child: Text('$error')),
                onData: (counter) {
                  return Text('${counter.count}');
                },
              ),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              //The ReactiveModel of Counter is available any where is the widget tree.
              onPressed: () async => RM.get<Counter>().setValue(
                    () => RM.get<Counter>().value.increment(),
                    catchError: true,
                  ),
            ),
          ),
        );
      },
    );
  }
}
```

`states_rebuilder` uses the service locator pattern for injecting dependencies using the` injector` with is a StatefulWidget. 

>**Intent of service locator pattern**   
>The purpose of the Service Locator pattern is to return the service instances on demand. This is useful for decoupling service consumers from concrete classes. It uses a central container which on request returns the request instance.

To understand the principle of DI, it is important to consider the following principles:

1. `Injector` adds classes to the container of the service locator in` initState` and deletes them in the `dispose` state. This means that if `Injector` is removed and re-inserted in the widget tree, a new singleton is registered for the injected models. If you injected streams or futures using `Inject.stream` or `Inject.future` and when the `Injector` is disposed and re-inserted, the streams and futures are disposed and reinitialized by `states_rebuilder` and do not fear of any memory leakage.

2. You can use nested injectors. As the `Injector` is a simple StatefulWidget, it can be added anywhere in the widget tree. Typical use is to insert the `Injector` deeper in the widget tree just before using the injected classes.

3. Injected classes are registered lazily. This means that they are not instantiated after injection until they are consumed for the first time.

4. For each injected class, you can consume the registered instance using :
    * `Injector.get` to get the registered raw vanilla dart instance.
      ```dart
      final T model = Injector.get<T>()
      //If the model is registered with custom name :
      final T model = Injector.get<T>(name:'customName');
      ```
      > As a shortcut you can use:
      ```dart
      //feature add in version 1.15.0
      final T model = IN.get<T>() // IN stands for Injector
      ```
    * or the ReactiveModel wrapper of the injected instance using: 
      ```dart
      ReactiveModel<T> modelRM = Injector.getAsReactive<T>()
      ```
      As a shortcut you can use:
      ```dart
      ReactiveModel<T> modelRM = ReactiveModel<T>();
      // Or simply (add in version 1.15.0)
      ReactiveModel<T> modelRM = RM.get<T>();
      //I will use the latter, but the three are equivalent.
      //In tutorials you expect to find any of these.
      ```
  
5. Both the raw instance and the reactive instance are registered lazily, if you consume a class using only `Injector.get` and not` Injector.getAsReactive`, the reactive instance will never be instantiated.

6. You can register classes with concrete types or abstract classes. 

7. You can register under different devolvement environments. This can be done by the help of `Inject.interface` named constructor and by setting the environment flavor `Injector.env` before calling the runApp method. see example below.

That said: 
> It is possible to register a class as a singleton, as a lazy singleton or as a factory simply by choosing where to insert it in the widget tree.

* To save a singleton that will be available for all applications, insert the `Injector` widget in the top widget tree. It is possible to set the `isLazy` parameter to false to instantiate the injected class the time of injection.

* To save a singleton that will be used by a branch of the widget tree, insert the `Injector` widget just above the branch. Each time you get into the branch, a singleton is registered and when you get out of it, the singleton will be destroyed. Making a profit of the behavior, you can clean injected models by defining a `dispose()` method inside them and set the parameter `disposeModels` of the `Injector`to true.

It is important to understand that `states_rebuilder` caches two singletons.
* The raw singleton of the registered model, obtained using `Injector.get` method.
* The reactive singleton of the registered model (the raw model decorated with reactive environment), obtained using `Injector.getAsReactive`.

With `states_rebuilder`, you can create, at any time, a new reactive instance, which is the same raw cashed singleton but decorated with a new reactive environment.

To create a new reactive instance of an injected model use `StateBuilder` with generic type and without defining `models` property.
```dart
StateBuilder<T>(
  builder:(BuildContext context, ReactiveModel<T> newReactiveModel){
    return YourWidget();
  }
)
```

You can also use `ReactiveModel.asNew([dynamic seed])` method: 

```dart
final reactiveModel = RM.get<Model>();
final newReactiveModel = reactiveModel.asNew('mySeed');

// or directly

final newReactiveModel = RM.get<Model>().asNew('mySeed');
```
By setting the seed parameter of the `asNew` method your are sure to get the same new reactive instance even after the widget rebuilds.

The seed parameter is optional, and if not provided, `states_rebuilder` uses a default seed.

>seed here has a similar meaning in random number generator. That is for the same seed we get the same new reactive instance.


**Important notes about reactive singleton and new reactive instances:**
* The reactive singleton and all the new reactive instances share the same raw singleton of the model, but each one decorates it with a different environment.
* Unlike the reactive singleton, new reactive instances are not cached so they are not accessible outside the widget in which they were instantiated.
* To make new reactive instances accessible throughout the widget tree, you have to register it with the `Injector` with a custom name: 

```dart
return Injector(
inject: [
  Inject( () => modelNewRM, name: 'newModel1'),
],
)
// Or
Injector(
inject: [
  Inject<Counter>(() => Counter()),
  Inject(
    () => modelNewRM,
    name: Enum.newModel1,
  ),
],
```
At later time if you want to consume the injected new reactive instance you use:

```dart
// get the injected new reactive instance
ReactiveModel<T> modelRM2 = RM.get<T>(name : 'newModel1');
//Or
ReactiveModel<T> modelRM2 = RM.get<T>(name : Enum.newModel1);
```
* You can not get a new reactive model by using `getAsReactive(context: context)` with a defined context. It will throw because only the reactive singleton that can subscribe a widget using the context.

* With the exception of the raw singleton they share, the reactive singleton and the new reactive instances have an independent reactive environment. That is when a particular reactive instance issues a notification with an error or with `ConnectionState.awaiting`, it will not affect other reactive environments.

* `states_rebuilder` allows reactive instances to share their notification or state with the reactive singleton. This can be done by:   
1- `notifyAllReactiveInstances` parameter of `setState` method. If true, each time a notification is issued by the reactive instance in which `setState` is called, all other reactive instances are notified.   
2- `joinSingletonWith` parameter of `Inject` class. This time, new reactive instances, when issuing a notification, can clone their state to the reactive singleton.
  * If `joinSingletonWith` is set to` JoinSingleton.withNewReactiveInstance`, this means that the reactive singleton will have the state of the new reactive instance issuing the notification.
  * If `joinSingletonWith` is set to `JoinSingleton.withCombinedReactiveInstances`, this means that the singleton will hold a combined state of all the new reactive instances.    
  The combined state priority logic is:   
  Priority 1- The combined `ReactiveModel.hasError` is true if at least one of the new instances has an error    
  Priority 2- The combined `ReactiveModel.connectionState` is awaiting if at least one of the new instances is awaiting.    
  Priority 3- The combined `ReactiveModel.connectionState` is 'none' if at least one of the new instances is 'none'.     
  Priority 4- The combined `ReactiveModel.hasDate` is true if it has no error, it isn't awaiting  and it is not in 'none' state.
* New reactive instances can send data to the reactive singleton. `joinSingletonToNewData` parameter of reactive environment hold the sending message.


# StateBuilder
In addition to its state management responsibility, `StateBuilder` offers a facade that facilitates the management of the widget's lifecycle.
```dart
StateBuilder<T>(
  onSetState: (BuildContext context, ReactiveModel<T> exposedModel){
  /*
  Side effects to be executed after sending notification and before rebuilding the observers. Side effects are navigating, opening the drawer, showing snackBar,...  
  
  It is similar to 'onSetState' parameter of the 'setState' method. The difference is that the `onSetState` of the 'setState' method is called once after executing the 'setState'. But this 'onSetState' is executed each time a notification is sent from one of the observable models this 'StateBuilder' is subscribing.
  
  You can use another nested setState here.
  */
  },
  onRebuildState: (BuildContext context, ReactiveModel<T> exposedModel){
  // The same as in onSetState but called after the end rebuild process.
  },
  initState: (BuildContext context, ReactiveModel<T> exposedModel){
  // Function to execute in initState of the state.
  },
  dispose: (BuildContext context, ReactiveModel<T> exposedModel){
  // Function to execute in dispose of the state.
  },
  didChangeDependencies: (BuildContext context, ReactiveModel<T> exposedModel){
  // Function to be executed  when a dependency of state changes.
  },
  didUpdateWidget: (BuildContext context, ReactiveModel<T> exposedModel, StateBuilder oldWidget){
  // Called whenever the widget configuration changes.
  },
  afterInitialBuild: (BuildContext context, ReactiveModel<T> exposedModel){
  // Called after the widget is first inserted in the widget tree.
  },
  afterRebuild: (BuildContext context, ReactiveModel<T> exposedModel){
  /*
  Called after each rebuild of the widget.

  The difference between onRebuildState and afterRebuild is that the latter is called each time the widget rebuilds, regardless of the origin of the rebuild. 
  Whereas onRebuildState is called only after rebuilds after notifications from the models to which the widget is subscribed.
  */
  },
  // If true all model will be disposed when the widget is removed from the widget tree
  disposeModels: true,

  // A list of observable objects to which this widget will subscribe.
  models: [model1, model2]

  // Tag to be used to filer notification from observable classes.
  // It can be any type of data, but when it is a List, 
  // this widget will be saved with many tags that are the items in the list.
  tag: dynamic

  //Similar to the concept of global key in Flutter, with ReactiveModel key you
  //can control the observer widget associated with it from outside.
  ///[see here for more details](changelog/v-1.15.0.md)
  rmKey : RMKey();

   watch: (ReactiveModel<T> exposedModel) {
    //Specify the parts of the state to be monitored so that the notification is not sent unless this part changes
  },

  builder: (BuildContext context, ReactiveModel<T> exposedModel){
    /// [BuildContext] can be used as the default tag of this widget.

    /// The model is the first instance (model1) in the list of the [models] parameter.
    /// If the parameter [models] is not provided then the model will be a new reactive instance.
  },
  builderWithChild: (BuildContext context, ReactiveModel<T> model, Widget child){
    ///Same as [builder], but can take a child widget exposedModel the part of the widget tree that we do not want to rebuild.
    /// If both [builder] and [builderWithChild] are defined, it will throw.

  },

  //The child widget that is used in [builderWithChild].
  child: MyWidget(),

)
```

`states_rebuilder` uses the observer pattern. Notification can be filtered so that only widgets meeting the filtering criteria will be notified to rebuild. Filtration is done through tags. `StateBuilder` can register with one or more tags and `StatesRebuilder` can notify the observer widgets with a specific list of tags, so that only widgets registered with at least one of these tags will rebuild.

```dart
class Counter extends StatesRebuilder {
  int count = 0;
  increment() {
    count++;
    //notifying the observers with 'Tag1'
    rebuildStates(['Tag1']);
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Counter counterModel = Injector.get(context: context);
    return Column(
      children: <Widget>[
        StateBuilder( // This StateBuilder will be notified
          models: [counterModel],
          tag: ['tag1, tag2'],
          builder: (_, __) => Text('${counterModel.count}'),
        ),
        StateBuilder(
          models: [counterModel],
          tag: 'tag2',
          builder: (_, __) => Text('${counterModel.count}'),
        ),
        StateBuilder(
          models: [counterModel],
          tag: MyEnumeration.tag1,// You can use enumeration
          builder: (_, __) => Text('${counterModel.count}'),
        )
      ],
    );
  }
}
```
# WhenRebuilder and WhenRebuilderOr
`states_rebuilder` offers the the `WhenRebuilder` widget which is a a combination of `StateBuilder` widget and `ReactiveModel.whenConnectionState` method.

instead of verbosely:
```dart
Widget build(BuildContext context) {
    return StateBuilder<PlugIn1>(
      models: [RM.get<PlugIn1>()],
      builder: (_, plugin1RM) {
        return plugin1RM.whenConnectionState(
          onIdle: () => Text('onIDle'),
          onWaiting: () => CircularProgressIndicator(),
          onError: (error) => Text('plugin one has an error $error'),
          onData: (plugin1) => Text('plugin one is ready'),
        );
      },
    );
}
```

You use :

```dart
@override
Widget build(BuildContext context) {
  return WhenRebuilder<PlugIn1>(
    models: [RM.get<PlugIn1>()],
    onIdle: () => Text('onIdle'),
    onWaiting: () => CircularProgressIndicator(),
    onError: (error) => Text('plugin one has an error $error'),
    onData: (plugin1) => Text('plugin one is ready'),
  );
}
```

Also with `WhenRebuilder` you can listen to a list of observable models and go throw all the possible combination statuses of the observable models:

```dart
WhenRebuilder<Model1>(
  //List of observable models
  models: [reactiveModel1, reactiveModel1],
  onIdle: () {
    //Will be invoked if :
    //1- None of the observable models is in the error state, AND
    //2- None of the observable models is in the waiting state, AND
    //3- At least one of the observable models is in the idle state.
  },
  onWaiting: () => {
    //Will be invoked if :
    //1- None of the observable models is in the error state, AND
    //2- At least one of the observable models is in the waiting state.
  },
  onError: (error) => {
    //Will be invoked if :
    //1- At least one of the observable models is in the error state.

    //The error parameter holds the thrown error of the model that has the error
  },
  onData: (data) => {
    //Will be invoked if :
    //1- None of the observable models is in the error state, AND
    //2- None of the observable models is in the waiting state, AND
    //3- None of the observable models is in the idle state, AND
    //4- All the observable models have data
       
    //The data parameter holds the state of the first model in the models' list.
  },
  
  // Tag to be used to filer notification from observable classes.
  // It can be any type of data, but when it is a List, 
  // this widget will be saved with many tags that are the items in the list.
  tag: dynamic
  
  initState: (BuildContext context, ReactiveModel<T> exposedModel){
  // Function to execute in initState of the state.
  },
  dispose: (BuildContext context, ReactiveModel<T> exposedModel){
  // Function to execute in dispose of the state.
  },
),
```
`WhenRebuilderOr` is just like `WhenRebuilder` but with optional `onIdle`, `onWaiting` and `onError` parameters and with required default `builder`..

# OnSetStateListener
`OnSetStateListener` is useful when you want to globally control the notification flow of a list of observable models and execute side effect calls. 

```dart
OnSetStateListener<Model1>(
  //List of observable models
  models: [reactiveModel1, reactiveModel1],
  onSetState: (context, reactiveModel1) {
    _onSetState = 'onSetState';
  },
  onWaiting: (context, reactiveModel1) {
    //Will be invoked if :
    //At least one of the observable models is in the waiting state.
  },
  onData: (context, reactiveModel1) {
    //Will be invoked if :
    //All of the observable models are in the hasData state.
  },
  onError: (context, error) {
    //Will be invoked if :
    //At least one of the observable models is in the error state.
    //The error parameter holds the thrown error of the model that has the error
  },
  // Tag to be used to filer notification from observable classes.
  // It can be any type of data, but when it is a List, 
  // this widget will be saved with many tags that are the items in the list.
  tag: dynamic

   watch: (ReactiveModel<T> exposedModel) {
    //Specify the parts of the state to be monitored so that the notification is not sent unless this part changes
  },
  //Wether to execute [onSetState],[onWaiting], [onError], and/or [onData] in the [State.initState]
  shouldOnInitState:false,
  //It has a child parameter, not a builder parameter.
  child: Container(),
)
```
What makes `OnSetStateListener` different is the fact that is has a child parameter rather than a builder parameter. This means that the child parameter will not rebuild even if observable models send notifications.

# Note on the exposedModel
`StateBuilder<T>`, `WhenRebuilder<T>` and `OnSetStateListener<T>` observer widgets can be set to observer many observable reactive models. The exposed model instance depends on the generic parameter `T`.
ex:
```dart
//first case : generic model is ModelA
StateBuilder<ModelA>(
  models:[modelA, modelB],
  builder:(context, exposedModel){
    //exposedModel is an instance of ReactiveModel<ModelA>.
  }
)
//second case : generic model is ModelB
StateBuilder<ModelB>(
  models:[modelA, modelB],
  builder:(context, exposedModel){
    //exposedModel is an instance of ReactiveModel<ModelB>.
  }
)
//third case : generic model is dynamic
StateBuilder(
  models:[modelA, modelB],
  builder:(context, exposedModel){
    //exposedModel is dynamic and it will change over time to hold the instance of model that emits a notification.
    
    //If modelA emits a notification the exposedModel == ReactiveModel<ModelA>.
    //Wheres if modelB emits a notification the exposedModel == ReactiveModel<ModelB>.
  }
)
```
# Injector
With `Injector` you can inject multiple dependent or independent models (BloCs, Services) at the same time. Also you can inject stream and future.
```dart
Injector( 
  inject: [
    //The order is not mandatory even for dependent models.
    Inject<ModelA>(() => ModelA()),
    Inject(() => ModelB()),//Generic type in inferred.
    Inject(() => ModelC(Injector.get<ModelA>())),// Directly inject ModelA in ModelC constructor
    Inject(() => ModelC(Injector.get())),// Type in inferred.
    Inject<IModelD>(() => ModelD()),// Register with Interface type.
    Inject<IModelE>({ //Inject through interface with environment flavor.
      'prod': ()=>ModelImplA(),
      'test': ()=>ModelImplB(),
    }), // you have to set the `Inject.env = 'prod'` before `runApp` method
    //You can inject streams and future and make them accessible to all the widget tree.
    Inject<bool>.future(() => Future(), initialValue:0),// Register a future.
    Inject<int>.stream(() => Stream()),// Register a stream.
    Inject(() => ModelD(),name:"customName"), // Use custom name

    //Inject and reinject with previous value provided. 
    Inject<ModelA>.previous((ModelA previous){
      return ModelA(id: previous.id);
    })
  ],
  //reinjectOn takes a list of StatesRebuilder models, if any of those models emits a notification all the injected model will be disposed and re-injected.
  reinjectOn : [models]
  // Whether to notify listeners of injected model using 'previous' constructor
  shouldNotifyOnReinjectOn: true;
  .
  .
);
```

* Models are registered lazily by default. That is, they will not be instantiated until they are first used. To instantiate a particular model at the time of registration, you can set the `isLazy` variable of the class `Inject` to false.

* `Injector` is a simple `StatefulWidget`, and models are registered in the `initState` and unregistered in the `dispose` state. (Registered means add to the service locator container).
If you wish to unregister and re-register the injected models after each rebuild you can set the key parameter to be `UniqueKey()`.
In a better alternative is to use the `reinjectOn` parameter which takes a list of `StatesRebuilder` models and unregister and re-register the injected models if any of the latter models emits a notification.

* For more detailed on the use of `Inject.previous` and `reinject` and `shouldNotifyOnReinjectOn` [see more details here](changelog/v-1.15.0.md)

* In addition to its injection responsibility, the `Injector` widget gives you a convenient facade to manage the life cycle of the widget as well as the application:

```dart
Injector( 
  initState: (){
    // Function to execute in initState of the state.
  },
  dispose: (){
    // Function to execute in dispose of the state.
  },
  afterInitialBuild: (BuildContext context){
    // Called after the widget is first inserted in the widget tree.
  },
  appLifeCycle: (AppLifecycleState state){
    /*
    Function to track app life cycle state. It takes as parameter the AppLifeCycleState
    In Android (onCreate, onPause, ...) and in IOS (didFinishLaunchingWithOptions, 
    applicationWillEnterForeground ..)
    */
  },
  // If true all model will be disposed when the widget is removed from the widget tree
  disposeModels: true,
  .
  .
);
```


The `Injector.get` method searches for the registered singleton using the service locator pattern. For this reason, `BuildContext` is not required. The `BuildContext` is optional and it is useful if you want to subscribe to the widget that has the `BuildContext` to the obtained model.

In the `HomePage` class of the example, we can remove `StateBuilder` and use the `BuildContext` to subscribe the widget. 

```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // The BuildContext of this widget is subscribed to the Counter class.
    // Whenever the Counter class issues a notification, this widget will be rebuilt.
    final Counter counterModel = Injector.get(context: context);
    return Center(
      child: Text('${counterModel.count}'),
    );
  }
}
```
Once the context is provided, `states_rebuilder` searches up in the widget tree to find the nearest `Injector` widget that has registered an `Inject` of the type provided and register the context (`Inject` class is associated with `InheritedWidget`). So be careful in case the `InheritedWidget` is not available, especially after navigation.

To deal with such a situation, you can remove the `context` parameter and use the `StateBuilder` widget, or in case you want to keep using the `context` you can use the `reinject` parameter of the `Injector`.
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => Injector(
      //reinject an already injected model
      reinject: [counterModel],
      builder: (context) {
        return PageTwo();
      },
    ),
  ),
);
```

# setState
`setState` is used whenever you want to trigger an event or an action that will mutate the state of the model and ends by issuing a notification to the observers.

```dart
reactiveModel.setState(
  (state) => state.increment(),
  //Filter notification with tags
  filterTags: ['Tag1', Enumeration.Tag2],

  //onData, trigger notification from new reactive models with the seeds in the list,
  seeds:['seed1',Enumeration.Seed2 ],

  //set to true, you want to catch error, and not break the app.
  catchError: true 
  
  watch: (Counter counter) {
    //Specify the parts of the state to be monitored so that the notification is not sent unless this part changes
    return counter.count; //if count value is not changed, no notification will be emitted.
  },
  onSetState: (BuildContext context) {
    /* 
    Side effects to be executed after sending notification and before rebuilding the observers. Side effects are navigating, opening the drawer, showing snackBar , ..

    You can use another nested setState here.
    */
  },
  onRebuildState: (BuildContext context) {
    //The same as in onSetState but called after the end rebuild process.
  },

  onData: (BuildContext context, T model){
    //Callback to be executed if the reactive model has data.
  }

  onError: (BuildContext context, dynamic error){
    //Callback to be executed if the reactive model throws an error.
    //You do not have to set the parameter catchError to true. By defining onError parameter 
    //states_rebuilder catches the error by default.
  }
  
  //When a notification is issued, whether to notify all reactive instances of the model
  notifyAllReactiveInstances: true, 
  /*
  If defined, when a new reactive instance issues a notification, it will change the state of the reactive singleton.
  */
  joinSingleton: true,

  //message to be sent to the reactive singleton
  dynamic joinSingletonToNewData,

  //Whether to set value or not
  bool setValue:false,
),
```

# `value` getter and `setValue` method.
With `states_rebuilder` you can inject with primitive values or enums and make them reactive so that you can mutate their values and notify observer widgets that have subscribed to them.

With `RM<T>.create(T value)` you can create a `ReactiveModel` from a primitive value. The created `ReactiveModel` has the full power the other reactive models created using `Injector` have as en example you can wrap the primitive value with many reactive model instances.

If you change the value (counterRM.value++), setValue will implicitly called to notify observers.

`setValue` watches the change of the value and will not notify observers only if the value has changed.
`setValue` has `onSetState`, `onRebuildState`, `onError`,  `catchError`, `filterTags` , `seeds` and `notifyAllReactiveInstances` the same way they are defined in `setState`:
```dart
reactiveModel.setValue(
  ()=> newValue,
  filterTags: ['Tag1', Enumeration.Tag2],
  //onData, trigger notification from new reactive models with the seeds in the list,
  seeds:['seed1',Enumeration.Seed2 ],

  onSetState: (BuildContext context) {
    /* 
    Side effects to be executed after sending notification and before rebuilding the observers. Side effects are navigating, opening the drawer, showing snackBar , ..

    You can use another nested setState here.
    */
  },
  onRebuildState: (BuildContext context) {
    //The same as in onSetState but called after the end rebuild process.
  },
    
  //set to true, you want to catch error, and not break the app.
  catchError: true,

  onError: (BuildContext context, dynamic error){
    //Callback to be executed if the reactive model throws an error.
    //You do not have to set the parameter catchError to true. By defining onError parameter 
    //states_rebuilder catches the error by default.
  }

  //When a notification is issued, whether to notify all reactive instances of the model
  notifyAllReactiveInstances: true, 
),
```

# StateWithMixinBuilder
`StateWithMixinBuilder` is similar to `StateBuilder` and extends it by adding mixin (practical case is an animation),
```Dart
StateWithMixinBuilder<T>( {
  Key key, 
  dynamic tag, // you define the tag of the state. This is the first way
  List<StatesRebuilder> models, // You give a list of the logic classes (BloC) you want this widget to listen to.
  initState: (BuildContext, String,T) {
     // for code to be executed in the initState of a StatefulWidget
  },
  dispose (BuildContext, String,T) {
    // for code to be executed in the dispose of a StatefulWidget
  }, 
  didChangeDependencies: (BuildContext, String,T) {
    // for code to be executed in the didChangeDependencies of a StatefulWidget
  }, 
  didUpdateWidget: (BuildContext, String,StateBuilder, T){
    // for code to be executed in the didUpdateWidget of a StatefulWidget
  },
  didChangeAppLifecycleState: (String, AppLifecycleState){
    // for code to be executed depending on the life cycle of the app (in Android : onResume, onPause ...).
  },
  afterInitialBuild: (BuildContext, String,T){
    // for code to be executed after the widget is inserted in the widget tree.
  },
  afterRebuild: (BuildContext, String) {
    // for code to be executed after each rebuild of the widget.
  }, 
  @required MixinWith mixinWith
});
```
Available mixins are: singleTickerProviderStateMixin, tickerProviderStateMixin, AutomaticKeepAliveClientMixin and WidgetsBindingObserver.


# Dependency Injection and development flavor
example of development flavor:
```dart
//abstract class
abstract class ConfigInterface {
  String get appDisplayName;
}

// first prod implementation
class ProdConfig implements ConfigInterface {
  @override
  String get appDisplayName => "Production App";
}

//second dev implementation
class DevConfig implements ConfigInterface {
  @override
  String get appDisplayName => "Dev App";
}

//Another abstract class
abstract class IDataBase{}

// first prod implementation
class RealDataBase implements IDataBase {}

// Second prod implementation
class FakeDataBase implements IDataBase {}


//enum for defined flavor
enum Flavor { Prod, Dev }


void main() {
  //Choose yor environment flavor
  Injector.env = Flavor.Prod;

  runApp(
    Injector(
      inject: [
        //Register against an interface with different flavor
        Inject<ConfigInterface>.interface({
          Flavor.Prod: ()=>ProdConfig(),
          Flavor.Dev:()=>DevConfig(),
        }),
        Inject<IDataBase>.interface({
          Flavor.Prod: ()=>RealDataBase(),
          Flavor.Dev:()=>FakeDataBase(),
        }),
      ],
      builder: (_){
        return MyApp(
          appTitle: Injector.get<ConfigInterface>().appDisplayName;
          dataBaseRepo : Injector.get<IDataBase>(),
        );
      },
    )
  );
}
```

# Widget unit texting

The test is an important step in the daily life of a programmer; if not the most important part!

With `Injector`, you can isolate any widget by mocking its dependencies and test it.

Let's suppose we have the widget.
```dart
Import 'my_real_model.dart';
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Injector(
      inject: [Inject(() => MyRealModel())],
      builder: (context) {
        final myRealModelRM = RM.get<MyRealModel>();

        // your widget
      },
    );
  }
}
```
The `MyApp` widget depends on` MyRealModel`. At first glance, this may seem to violate DI principles. How can we mock the "MyRealModel" which is not injected into the constructor of "MyApp"?

To mock `MyRealModel` and test MyApp we set `Injector.enableTestMode` to true :

```dart
testWidgets('Test MyApp class', (tester) async {
  //set enableTestMode to true
  Injector.enableTestMode = true;

  await tester.pumpWidget(
    Injector(
      //Inject the fake model and register it with the real model type
      inject: [Inject<MyRealModel>(() => MyFakeModel())],
      builder: (context) {
        //In my MyApp, Injector.get or Inject.getAsReactive will return the fake model instance
        return MyApp();
      },
    ),
  );

  //My test
});

//fake model implement real model
class MyFakeModel extends MyRealModel {
  // fake implementation
}
```
You can see a real test of the [counter_app_with_error]((states_rebuilder_package/example/test)) and [counter_app_with_refresh_indicator]((states_rebuilder_package/example/test)).

# For further reading:

> [List of article about `states_rebuilder`](https://medium.com/@meltft/states-rebuilder-and-animator-articles-4b178a09cdfa?source=friends_link&sk=7bef442f49254bfe7adc2c798395d9b9)


# Updates
To track the history of updates and feel the context when those updates are introduced, See the following links.

* [1.15.0 update](changelog/v-1.15.0.md) : 
  * Example of using `Inject.previous` with `reinjectOn`;
  * The add shortcuts (`IN.get()`, `RM.get()`, ...);
  * Example of how to use states_rebuilder observer widgets instead of `FutureBuilder` and `StreamBuilder` Flutter widgets;
  * The concept of ReactiveModel keys.
