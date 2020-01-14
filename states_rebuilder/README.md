# states_rebuilder_sample

This sample is an implementation of the todoMVC app using `states_rebuilder` package as a state management technique.

For more information and tutorials on how states_rebuilder work please check out the [official documentation](https://github.com/GIfatahTH/states_rebuilder).

# key concepts of the architecture

* The app is divided into there layers in the form of onion layers : the innermost is Domain, the middle is Service, and the outer layer for UI and external services which has three parts (UI, data_source, and infrastructure).

The folders structure is :

```lib -    
  |-domain  
  |  |-entities      
  |  |-exceptions       
  |-service (application service)       
  |      |-interfaces (to be implemented by data_source)     
  |      |-exceptions    
  |      |-common   
  |-data_source   
  |-ui   
  |  |-pages    
  |  |-exceptions (handle exception)      
  |  |-common    
```

## domain
Contains enterprise wide business logic. It encapsulates entities, value_objects, exceptions. In case of todoMVC we need one entity `Todo`.

* Entity is a mutable object with an ID. It should contain all the logic It controls. Entity is validated just before persistance, ie, in toMap() method.

* Domain objects must throw exceptions defined in the exception folders:

## service
Contains service application use cases business logic. It defines a set of API to be consumed by the outer layer (UI and infrastructure).
* Service layer defines a set of interfaces, outer layer (data_source and infrastructure) must implement.

* Service objects must throw exceptions defined in the exception folder in the service layer:


>Domain and Service layer are the core portable part of your app. It does not depend on any concrete implementation of external service (data_source) and can be share a cross many UI frameworks.


# key concepts of states_rebuilder

1. With states_rebuilder you can achieve a clear separation between UI and business logic;
2. Your business logic is made up of pure dart classes without the need to refer to external packages or frameworks (NO extension, NO notification, NO annotation);
```dart
class Foo {
 //Vanilla dart class
 //NO inheritance form external libraries
 //NO notification
 //No annotation
}
```
3. You make a singleton of your logical class available to the widget tree by injecting it using the Injector widget.
```dart
Injector(
 inject : [Inject(()=>Foo())]
 builder : (context) => MyChildWidget()
)
```
Injector is a StatefulWidget. It can be used any where in the widget tree. 
4. From any child widget of the Injector widget, you can get the registered raw singleton using the static method `Injector.get<T>()` method;
```dart
final Foo foo = Injector.get<Foo>();
```
5. To get the registered singleton wrapped with a reactive environment, you use the static method 
`Injector.getAsReactive<T>()` method:
```dart
final ReactiveModel<Foo> foo = Injector.getAsReactive<Foo>();
```
In fact, for each injected model, states_rebuilder registers two singletons:
- The raw singleton of the model
- The reactive singleton of the model which is the raw singleton wrapped with a reactive environment:
The reactive environment adds getters, fields, and methods to modify the state, track the state of the reactive environment and notify the widgets which are subscribed to it.
6. To subscribe a widget as observer, we use `StateBuilder` widget or define the context parameter in `Injector.getAsReactive<Foo>(context:context)`.
7. The `setState` method is where actions that mutate the state and send notifications are defined.
What happens is that from the user interface, we use the `setState` method to mutate the state and notify subscribed widgets after the state mutation. In the `setState`, we can define a callback for all the side effects to be executed after the state change and just before rebuilding subscribed widgets using `onSetState`, `onData` and `onError` parameter(or `onRebuild` so that the code executes after the reconstruction). From inside `onSetState`, we can call another `setState` to mutate the state and notify the user interface with another call `onSetState` (`onRebuild`) and so on …

For more information and tutorials on how states_rebuilder work please check out the [official documentation](https://github.com/GIfatahTH/states_rebuilder).