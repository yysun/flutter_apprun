[![Pub.dev package](https://img.shields.io/badge/pub.dev-flutter_apprun-blue)](https://pub.dev/packages/flutter_apprun)
[![GitHub repository](https://img.shields.io/badge/GitHub-flutter_apprun--dart-blue?logo=github)](https://github.com/yysun/flutter_apprun)

# Flutter AppRun
A lightweight, easy-to-use, event-driven state management system, highly inspired by [AppRun JS](https://apprun.js.org).


## Features

* Use events to drive state changes.
* Use pure functions to update the state, easy to test state changes.
* The events also drive UI updates, no need to use `setState` to update the state.
* Global event bus, you can use events to communicate between widgets.
* Fully support asynchronous state changes.

## Getting started

Install it using pub:
```
dart pub add flutter_apprun
```

And import the package:
```dart
import 'package:flutter_apprun/flutter_apprun.dart';
```

## Usage

Extend the AppRunWidget class to create your widget:

```dart
// Define the initial state
int initialState = 0;

// Define the update map
int add(int state, int delta) => state + delta;
Map update = {
  'add': add,
  '+1': (state) => add(state, 1),
  '-1': (state) => add(state, -1),
};

// Extend the AppRunWidget class to create your widget
class HomePage extends AppRunWidget {
  final String title;

  // Pass the initial state and update map to the super class
  HomePage({super.key, required this.title})
      : super(state: initialState, update: update);

  // Display the state
  @override
  Widget build(BuildContext context, state) {
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
            // onPressed: () => run('add', -1),
            onPressed: () => run('-1'),
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
          FloatingActionButton(
            heroTag: 'plus',
            // onPressed: () => run('add', 1),
            onPressed: () => run('+1'),
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ],
      ),
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