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
3. With states_rebuilder you can manage immutable as well as mutable state.

In this demo implementation, I choose to use immutable state, you can find the same app implemented with mutable state in the example folder of the [official repo in github](https://github.com/GIfatahTH/states_rebuilder).

In this implementation, I add the requirement that when a todo is added, deleted or updated, it will be instantly displayed in the user interface, so that the user will not notice any delay, and the async method `saveTodo` will be called in the background to persist the change. If the `saveTodo` method fails, the old state is returned and displayed back with a` SnackBar` containing the error message.

The idea is simple:
1- Write your immutable `TodosState` class using pure dart without any use of external libraries.
  ```dart
    @immutable
    class TodosState {
      TodosState({
        ITodosRepository todoRepository,
        List<Todo> todos,
        VisibilityFilter activeFilter,
      })  : _todoRepository = todoRepository,
            _todos = todos,
            _activeFilter = activeFilter;

    //....
    }
  ```
2- Inject the `TodosState` using the `Injector` widget,
  ```dart
    return Injector(
    inject: [
      Inject(
        () => TodosState(
          todos: [],
          activeFilter: VisibilityFilter.all,
          todoRepository: repository,
        ),
      )
    ],
  ```
3- use one of the available observer widgets offered by states_rebuilder to subscribed to the `TodosState` `ReactiveModel`.
  ```dart
       return StateBuilder<TodosState>(
          observe: () => RM.get<TodosState>(),
          builder: (context, todosStoreRM) {
              //...

          }
      )  
  ```
4- to notify the observing widgets use: 
  * for sync method: use `setValue` method or the `value` setter.
    ```dart
    onSelected: (filter) {

      activeFilterRM.setValue(
        () => filter,
        onData: (context, data) {
          RM.get<TodosState>().value =
              RM.get<TodosState>().value.copyWith(activeFilter: filter);
        },
      );
    ```
  * for async future method: use future method.
  ```dart
        body: WhenRebuilderOr<AppTab>(
        observeMany: [
            () => RM.get<TodosState>().asNew(HomeScreen)
                      ..future((t) => t.loadTodos())
                      .onError(ErrorHandler.showErrorDialog),
            () => _activeTabRMKey,
        ]

        //...
      )  
  ```
  * for async stream method: use stream method.
    ```dart
        onSelected: (action) {

          RM.get<TodosState>()
            .stream(
                (action == ExtraAction.toggleAllComplete)
                    ? (t) => t.toggleAll()
                    : (t) => t.clearCompleted(),
              )
            .onError(ErrorHandler.showErrorSnackBar);
        }
    ```

