# Application Specification

We have created this short spec to help you create awesome and consistent todo apps. Make sure to not only read it but to understand it as well.

## Reference Application

The [vanilla](https://gitlab.com/brianegan/flutter_mvc/example/vanilla/) implementation should be used as the reference app and as a base when implementing a new todo app. Before implementing your own, we recommend that you interact with some of the other apps to see how they're built and how they behave. If something is unclear or could be improved, [let us know](https://gitlab.com/brianegan/flutter_mvc/issues).

Your app should look and behave exactly like the template and the other examples.

### README

All examples must include a README describing the framework, the general implementation, and the build process if required. Please check the [vanilla](https://gitlab.com/brianegan/flutter_mvc/example/vanilla/) implementation for an example.

### Code

- Format your code with `dartfmt`
- Use the `.analysis_options.yaml` from the vanilla implementation and ensure there are no analysis errors
- Use the Theme and Widgets provided by the base package for the visual look, unless it makes sense to demonstrate an alternative practice.
- Your app should work on both Android and iOS 

## Functionality

### No todos

When there are no todos, the `MarkAll`, `TodoList` and `Footer` should be hidden.

### New todo

New todos are entered in the `TextField` at the top of the app. The `TextField` should be focused when the app starts. Pressing Enter creates the todo, appends it to the todo list, and clears the TextField. Make sure to `.trim()` the input and then check that it's not empty before creating a new todo.

### Mark all as complete

This checkbox toggles all the todos to the same state as itself. Make sure to clear the checked state after the "Clear completed" button is clicked. The "Mark all as complete" checkbox should also be updated when single todo items are checked/unchecked. Eg. When all the todos are checked it should also get checked.

### Item

A todo item has three possible interactions:

1. Clicking the checkbox marks the todo as complete.

2. Double-clicking the `Todo` activates editing mode, which shows a `TextField` that allows the user to update the todo.

3. Swiping removes a todo from the list

### Editing

When editing mode is activated it will hide the checkbox and bring forward an input that contains the todo title, which should be focused.

### Counter

Displays the number of active todos in a pluralized form. Make sure to pluralize the `item` word correctly: `0 items`, `1 item`, `2 items`. Example: **2** items left.

### Clear completed button

Removes completed todos when clicked. Should be hidden when there are no completed todos.

### Persistence

Your app should persist the todos and current route. If the framework has capabilities for persisting data, use that. Otherwise, use the provided `TodoStorage` class.

### Routing

Routing is required for all implementations. The following routes should be implemented: `/` (all - default), `/active` and `/completed`. When the route changes, the todo list should be filtered and the appropriate tab should be toggled. When an item is updated while in a filtered state, it should be updated accordingly. E.g. if the filter is `Active` and the item is checked, it should be hidden.