# `states_rebuilder`

[![pub package](https://img.shields.io/pub/v/states_rebuilder.svg)](https://pub.dev/packages/states_rebuilder)
[![CircleCI](https://circleci.com/gh/GIfatahTH/states_rebuilder.svg?style=svg)](https://circleci.com/gh/GIfatahTH/states_rebuilder)
[![codecov](https://codecov.io/gh/GIfatahTH/states_rebuilder/branch/master/graph/badge.svg)](https://codecov.io/gh/GIfatahTH/states_rebuilder)


A Flutter state management combined with dependency injection solution that allows : 
  * a 100% separation of User Interface (UI) representation from your logic classes
  * an easy control on how your widgets rebuild to reflect the actual state of your application.
Model classes are simple vanilla dart classes without any need for inheritance, notification, streams or annotation and code generation.


`states_rebuilder` is built on the observer pattern for state management and on the service locator pattern for dependency injection.

> **Intent of observer pattern**    
>Define a one-to-many dependency between objects so that when one object changes state (observable object), all its dependents (observer objects) are notified and updated automatically.

>**Intent of service locator pattern**   
>The purpose of the Service Locator pattern is to return the service instances on demand. This is useful for decoupling service consumers from concrete classes. It uses a central container which on request returns the request instance.

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
          //It Exhaustively goes throw the four possible status of the state and define the corresponding widget.
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

