[![Pub.dev package](https://img.shields.io/badge/pub.dev-flutter_apprun-blue)](https://pub.dev/packages/flutter_apprun)
[![GitHub repository](https://img.shields.io/badge/GitHub-flutter_apprun--dart-blue?logo=github)](https://github.com/yysun/flutter_apprun)

# Flutter AppRun
A lightweight, easy-to-use, event-driven state management system, highly inspired by [AppRun JS](https://apprun.js.org).


## Features

* Use events to drive state changes, easy to understand.
* Use pure functions to update the state, easy to test state changes.
* The events also drive UI updates, no need to use `setState`.
* The local events are scoped to the widget, no need to worry about the global events.
* The global events are used to communicate between widgets, no need to use `Provider` or `Bloc`.
* Fully support asynchronous state changes.

## Getting started

Install it using pub:
```
flutter pub add flutter_apprun
```

And import the package:
```dart
import 'package:flutter_apprun/flutter_apprun.dart';
```

## Usage

Use `AppRunWidget` in your widget tree.

```dart
AppRunWidget(
  state: initialState,
  update: update,
  builder: (BuildContext context, state) {
    return ... // widget tree biuld from the state
  }
)
```

* The `state` is the initial state
* The `update` is the collection of event handlers.
* The `builder` is to display the state, which is called whenever the state changes.
* Use `app.run` to trigger global events.
* Use `AppRun.of(context).run` to trigger local events.



## Example

A counter page with two buttons to increment and decrement the counter.

```dart
// Define the initial state
int initialState = 0;

// Define the event handler collection in a map
int add(int state, int delta) => state + delta;
Map update = {
  '@add': add,                      // global event
  '+1': (state) => add(state, 1),   // local event
  '-1': (state) => add(state, -1),  // local event
};

// Use the AppRunWidget in your widget tree
class HomePage extends StatelessWidget {
  final String title;

  const HomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppRunWidget(
      state: initialState,
      update: update,
      builder: (BuildContext context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '$state',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                heroTag: 'minus',
                // onPressed: () => app.run('@add', -1),  // global event
                onPressed: () => AppRun.of(context).run('-1'), // local event
                tooltip: 'Decrement',
                child: const Icon(Icons.remove),
              ),
              FloatingActionButton(
                heroTag: 'plus',
                // onPressed: () => app.run('@add', 1), // global event
                onPressed: () => AppRun.of(context).run('+1'), // local event
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

## License

MIT License

## Additional information

* [AppRun JS](https://apprun.js.org)
* [AppRun Architecture](https://apprun.js.org/docs/architecture/)


Copyright (c) 2023, Yiyi Sun