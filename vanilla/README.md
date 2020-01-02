# vanilla example

The vanilla example uses only the core Widgets and Classes that Flutter provides out of the box to manage state. The most important of these: the `StatefulWidget`.

## Key Concepts

  * Share State by Lifting State Up - If two Widgets need access to the same state (aka data), "lift" the state up to a parent `StatefulWidget` that passes the state down to each child Widget that needs it.
  * Updating State with callbacks - To update state, pass a callback function from the Parent `StatefulWidget` to the child widgets.
  * Local persistence - The list of todos is serialized to JSON and stored as a file on disk whenever the State is updated.
  * Testing - Pull Business logic out of Widgets into Plain Old Dart Object (PODOs).

## Share State by Lifting State Up

Let's start with a Simple Example. Say our app had only 1 Tab: The `List of Todos Tab`.

 ```
+------------+
|            |
|   List     |
|   of       |
|   Todos    |
|   Tab      |
|            |
+------------+
```

Now, we add a sibling Widget: The `Stats Tab`! But wait, it needs access to the List of Todos so it can calculate how many of them are active and how many are complete. So how do we share that data? 

It can be difficult for siblings to pass their state to each other. For example, say both Widgets were displayed side-by-side at the same time: How would Flutter know when to re-build the `Stats Tab` to reflect the latest count when the List of Todos changes?

```
+-------------+                 +-------------+
|             |                 |             |
|             | Gimme dem Todos |             |
|   List of   | <-------------- +   Stats     |
|   Todos     |                 |   Tab       |
|   Tab       |    No. Mine.    |             |
|             + --------------> |             |
|             |                 |             |
+-------------+                 +-------------+
```

So how do we share state between these two sibling Widgets? Let's Lift the state up to a Parent Widget and pass it down to each child that needs it!

```
     +-------------------------+
     |   Keeper of the Todos   |
     |    (StatefulWidget)     |
     +-----+--------------+----+
           |              |
+----------|--+       +---|---------+
|          v  |       |   v         |
|   List of   |       |   Stats     |
|   Todos     |       |   Tab       |
|             |       |             |
+-------------+       +-------------+
```

Now, when we change the List of Todos in the `Keeper of the Todos` widget, both children will reflect the updated State! This concept scales to an entire app. Any time you need to share State between Widgets or Routes, lift it up to a common parent Widget. Here's a diagram of what our app state actually looks like!

```
   +------------------------------------------+
   |                                          |
   |      VanillaApp (StatefulWidget)         |
   |                                          |
   |    Manages List<Todo> and "isLoading"    |
   |                                          |
   +---------+---------------------------+----+
             |                           |
+------------|---------------+  +--------|--------+
|            v               |  |        v        |
|     Main Tabs Screen       |  | Add Todo Screen |
|        (Stateful)          |  |   (Stateless)   |
|                            |  |                 |
|   Manages current tab and  |  |                 |
|     Visibility filter      |  |                 |
|                            |  |                 |
| +----------+  +----------+ |  |                 |
| |          |  |          | |  |                 |
| | List     |  |          | |  |                 |
| | of       |  |  Stats   | |  |                 |
| | Todos    |  |  Tab     | |  |                 |
| | Tab      |  |          | |  |                 |
| +----+-----+  +----------+ |  |                 |
|      |                     |  |                 |
+------|---------------------+  +-----------------+
       |
+------|---------+
|      v         |
|                |
|  Todo Details  |
|  Screen        |
|                |
+------+---------+
       |
+------|---------+
|      v         |
|                |
|   Edit Todo    |
|   Screen       |
|                |
+----------------+
```

Careful Observers might note: We don't lift *all* state up to the parent in this pattern. Only the State that's shared! The Main Tabs Screen can handle which tab is currently active on its own, for example, because this state isn't relevant to other Widgets!

## Updating State with callbacks

Ok, so now we have an idea of how to pass data down from parent to child, but how do we update the list of Todos from these different screens / Routes / Widgets?

We'll also **pass callback functions** from the parent to the children as well. These callback functions are responsible for updating the State at the Parent Widget and calling `setState` so Flutter knows it needs to rebuild!

In this app, we have a few callbacks we will pass down:

  1. AddTodo callback
  2. RemoveTodo Callback
  3. UpdateTodo Callback
  4. MarkAllComplete callback
  5. ClearComplete callback

In this app, we pass the `AddTodo` callback from our `VanillaApp` Widget to the `Add Todo Screen`. Now all our `Add Todo Screen` needs to do is call the `AddTodo` callback with a new `Todo` when a user finishes filling in the form. This will send the `Todo` up to the `VanillaApp` so it can handle how it adds the new todo to the list!

This demonstrates a core concept of State management in Flutter: Pass data and callback functions down from a parent to a child, and use invoke those callbacks in the Child to send data back up to the parent.

To make this concrete, Let's see how our callbacks flow in the this app.

```
   +----------------------------------------------------+
   |                                                    |
   |      VanillaApp (StatefulWidget)                   |
   |                                                    |
   |    Manages List<Todo> and "isLoading"              |
   |                                             ^      |
   +---------+----------------------+------------|------+
             |                      |            |
             | UpdateTodo           | AddTodo    | Invoke AddTodo
             | RemoveTodo           |            | Callback, sending
             | MarkAllComplete      |            | Data up to the  
             | ClearComplete        |            | parent.
             |                      |            |
+------------|---------------+  +---|------------+-+
|            v               |  |   v              |
|     Main Tabs Screen       |  | Add Todo Screen  |
|        (Stateful)          |  |   (Stateless)    |
|                            |  |                  |
|   Manages current tab and  |  |                  |
|     Visibility filter      |  |                  |
|                            |  |                  |
| +----------+  +----------+ |  |                  |
| |          |  |          | |  |                  |
| | List     |  |          | |  |                  |
| | of       |  |  Stats   | |  |                  |
| | Todos    |  |  Tab     | |  |                  |
| | Tab      |  |          | |  |                  |
| +----+-----+  +----------+ |  |                  |
|      |                     |  |                  |
+------|---------------------+  +------------------+
       |
       | UpdateTodo
       | RemoveTodo
       |
+------|---------+
|      v         |
|                |
|  Todo Details  |
|  Screen        |
|                |
+------+---------+
       |
       | UpdateTodo
       |
+------|---------+
|      v         |
|                |
|   Edit Todo    |
|   Screen       |
|                |
+----------------+
```

## Testing

There are a few Strategies for testing:

  1. Store state and the state mutations (methods) within a `StatefulWidget`
  2. Extract this State and logic out into a "Plain Old Dart Objects" (PODOs) and test those. The `StatefulWidget` can then delegate to this object.
  
So which should you choose? For View-related State: Option #1. For App State / Business Logic: Option #2.

While Option #1 works because Flutter provides a nice set of Widget testing utilities out of the box, Option #2 will generally prove easier to test because it has no Flutter dependencies and does not require you to test against a Widget tree, but simply against an Object.  

## Addendum

Since Flutter is quite similar to React with regards to State management, many of the resources on the React site are pertinent when thinking about State in flutter. In fact, the ideas in this example were lifted directly from the React site:

  * [Lifting State Up in React](https://reactjs.org/docs/lifting-state-up.html)
  * [Thinking in React](https://reactjs.org/docs/thinking-in-react.html)
