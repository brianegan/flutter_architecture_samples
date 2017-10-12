# vanilla example

The vanilla example uses only the core Widgets and Classes that Flutter provides out of the box to manage state. The most important of these: the `StatefulWidget`.

## Key Concepts

  * Share State by Lifting State Up - If two Widgets need access to the same state (aka data), "lift" the state up to a parent `StatefulWidget` that passes the state down to each child Widget that needs it.
  * Updating State - To update state, pass a function from the Parent `StatefulWidget` to the child widget.
  * Local persistence - The list of todos is serialized to JSON and stored as a file on disk whenever the State is updated. 

## Lifting State

Let's start with a Simple Example. Say our app had only 1 Tab: The `List of Todos Tab`.

 ```
+------------+
|            |
|            |
|            |
|   List     |
|   of       |
|   Todos    |
|   Tab      |
|            |
|            |
+------------+
```

Now, we add a sibling Widget: The `Stats Tab`! But wait, it needs access to the List of Todos so it can calculate how many of them are active and how many are complete. So how do we share that data? 

It can be difficult for siblings to pass their state to each other. For example, what if you call `setState` in the `List of Todos Tab` to add a Todo: How would Flutter know it also needs to re-build the `Stats Tab` to reflect the latest count?

```
+-------------+                 +-------------+
|             |                 |             |
|             |                 |             |
|             |                 |             |
|             | Gimme dem Todos |             |
|   List of   | <-------------- +   Stats     |
|   Todos     |                 |   Tab       |
|   Tab       |                 |             |
|             |    No. Mine.    |             |
|             + --------------> |             |
|             |                 |             |
|             |                 |             |
+-------------+                 +-------------+
```

So how do we share state between these two Widgets? Let's Lift the state up to a Parent Widget and pass it down to each child that needs it!

```
     +-------------------------+
     |                         |
     |   Keeper of the Todos   |
     |    (StatefulWidget)     |
     |                         |
     +-----+--------------+----+
           |              |
           |              |
+----------|--+       +---|---------+
|          |  |       |   |         |
|          v  |       |   v         |
|             |       |             |
|             |       |             |
|   List of   |       |   Stats     |
|   Todos     |       |   Tab       |
|   Tab       |       |             |
|             |       |             |
|             |       |             |
|             |       |             |
|             |       |             |
+-------------+       +-------------+
```

Now, when we change the List of Todos in the `Keeper of the Todos` widget, both children will reflect the updated State! This concept scales to an entire app. Any time you need to share State between Widgets or Routes, pull it up to a parent Widget. Here's a diagram of what our app actually looks like!

```
   +------------------------------------------+
   |                                          |
   |      VanillaApp (StatefulWidget)         |
   |                                          |
   |    Contains List<Todo> and other State   |
   |                                          |
   +------------------------------------------+
             |                           |
+------------|---------------+  +--------|--------+
|            v               |  |        v        |
|                            |  |                 |
|      Main  Tabs Screen     |  | Add Todo Screen |
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
       |
+------|---------+
|      v         |
|                |
|   Edit Todo    |
|   Screen       |
|                |
+----------------+

```