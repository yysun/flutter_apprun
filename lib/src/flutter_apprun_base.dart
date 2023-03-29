import 'package:flutter/widgets.dart';

// typedef EventCallback = void Function([dynamic arg]);
typedef EventCallback = Function;

final app = AppRun();

class AppRun<E> {
  static AppRun of(BuildContext context) => context.widget is AppRunWidget
      ? (context.widget as AppRunWidget)._app
      : app;

  final _events = {};
  void on(E event, EventCallback callback) {
    _events[event] ??= <EventCallback>[];
    _events[event]!.add(callback);
  }

  int run(E event, [dynamic data]) {
    var list = _events[event];
    assert(list != null && list.length > 0, 'Event $event is not registered.');
    if (list == null) return 0;
    for (var callback in list) {
      callback(data);
    }
    return list.length;
  }

  void off(E event, [EventCallback? callback]) {
    var list = _events[event];
    if (list == null) return;
    if (callback == null) {
      _events[event] = null;
    } else {
      list.remove(callback);
    }
  }
}

// typedef Action<S> = S Function(S state, [dynamic data]);
// typedef Update<E, S> = Map<E, Action<S>>;

typedef Update = Map;
typedef View<T> = Widget Function(BuildContext context, T state);

bool isGlobal(event) => event.toString().startsWith('@');

class AppRunWidget<T, E> extends StatefulWidget {
  final AppRun<E> _app = AppRun<E>();
  final T state;
  final Update update;
  final View<T> builder;

  AppRunWidget(
      {Key? key,
      required this.state,
      required this.update,
      required this.builder})
      : super(key: key);

  @override
  State<AppRunWidget<T, E>> createState() => _AppRunWidgetState<T, E>();

  void on(E event, EventCallback callback) {
    return isGlobal(event) ? app.on(event, callback) : _app.on(event, callback);
  }

  int run(E event, [dynamic data]) {
    return isGlobal(event) ? app.run(event, data) : _app.run(event, data);
  }

  void off(E event, [EventCallback? callback]) {
    return isGlobal(event)
        ? app.off(event, callback)
        : _app.off(event, callback);
  }
}

class _AppRunWidgetState<T, E> extends State<AppRunWidget<T, E>> {
  final _listeners = {};
  late T state;

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, state);
  }

  @override
  void initState() {
    super.initState();
    state = widget.state;
    _init();
  }

  void _init() {
    widget.update.forEach((event, action) {
      void newAction(data) {
        var newState = data == null ? action(state) : action(state, data);
        if (newState != null) {
          setState(() {
            state = newState;
          });
        }
      }

      _listeners[event] = newAction;
      widget.on(event, newAction);
    });
  }

  @override
  void dispose() {
    _listeners.forEach((event, listener) {
      widget.off(event, listener);
    });
    super.dispose();
  }
}
