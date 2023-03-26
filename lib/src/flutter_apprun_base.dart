import 'package:flutter/widgets.dart';

// typedef EventCallback = void Function([dynamic arg]);
typedef EventCallback = Function;

class AppRun {
  static final AppRun _singleton = AppRun._internal();
  factory AppRun() {
    return _singleton;
  }
  AppRun._internal();
  static final _AppRun _apprun = _AppRun();
  static void on(event, callback) => _apprun.on(event, callback);
  static int run(event, [data]) => _apprun.run(event, data);
  static void off(event, [callback]) => _apprun.off(event, callback);
}

class _AppRun<E> {
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

bool isGlobal(event) => event.toString().startsWith('@');

// mixin AppRunMixin<E, S, W extends StatefulWidget> on State<W> {
//   final _AppRun<E> _localAppRun = _AppRun<E>();
//   final _listeners = {};

//   late S state;
//   late Map update = {};

//   @override
//   void initState() {
//     super.initState();
//     _init();
//   }

//   void _init() {
//     update.forEach((event, action) {
//       void newAction(data) {
//         var newState = data == null ? action(state) : action(state, data);
//         if (newState != null) {
//           setState(() {
//             state = newState;
//           });
//         }
//       }

//       _listeners[event] = newAction;
//       on(event, newAction);
//     });
//   }

//   @override
//   void dispose() {
//     _listeners.forEach((event, listener) {
//       isGlobal(event)
//           ? AppRun.off(event, listener)
//           : _localAppRun.off(event, listener);
//     });
//     super.dispose();
//   }

//   void on(E event, EventCallback callback) {
//     return isGlobal(event)
//         ? AppRun.on(event, callback)
//         : _localAppRun.on(event, callback);
//   }

//   int run(E event, [dynamic data]) {
//     return isGlobal(event)
//         ? AppRun.run(event, data)
//         : _localAppRun.run(event, data);
//   }

//   void off(E event, [EventCallback? callback]) {
//     return isGlobal(event)
//         ? AppRun.off(event, callback)
//         : _localAppRun.off(event, callback);
//   }
// }

abstract class AppRunWidget<T, E> extends StatefulWidget {
  final _AppRun<E> _appRun = _AppRun<E>();
  final T state;
  final Update update;

  AppRunWidget({Key? key, required this.state, required this.update})
      : super(key: key);

  @override
  State<AppRunWidget<T, E>> createState() => _AppRunWidgetState<T, E>();

  void on(E event, EventCallback callback) {
    return isGlobal(event)
        ? AppRun.on(event, callback)
        : _appRun.on(event, callback);
  }

  int run(E event, [dynamic data]) {
    return isGlobal(event) ? AppRun.run(event, data) : _appRun.run(event, data);
  }

  void off(E event, [EventCallback? callback]) {
    return isGlobal(event)
        ? AppRun.off(event, callback)
        : _appRun.off(event, callback);
  }

  Widget build(BuildContext context, state);
}

class _AppRunWidgetState<T, E> extends State<AppRunWidget<T, E>> {
  final _listeners = {};
  late T state;

  @override
  Widget build(BuildContext context) {
    return widget.build(context, state);
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
