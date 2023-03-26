import 'package:flutter/material.dart';
import 'package:flutter_apprun/flutter_apprun.dart';

int initialState = 0;
int add(int state, int delta) => state + delta;
Map update = {
  'add': add,
  '+1': (state) => add(state, 1),
  '-1': (state) => add(state, -1),
};

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter AppRun Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'Flutter AppRun Demo Home Page'),
    );
  }
}

class HomePage extends AppRunWidget {
  final String title;

  HomePage({super.key, required this.title})
      : super(state: initialState, update: update);

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
