import 'dart:async';

import '../state/app_event.dart';

class EventBus {
  final StreamController<AppEvent> _controller =
      StreamController<AppEvent>.broadcast();

  Stream<AppEvent> get stream => _controller.stream;

  void emit(AppEvent event) => _controller.add(event);

  void dispose() => _controller.close();
}
