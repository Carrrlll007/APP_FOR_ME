import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/event_bus.dart';
import '../services/path_engine.dart';
import '../services/storage/secure_store.dart';
import '../services/xp_engine.dart';
import 'app_controller.dart';
import 'app_state.dart';
import 'state_machine.dart';

final eventBusProvider = Provider<EventBus>((ref) {
  final bus = EventBus();
  ref.onDispose(bus.dispose);
  return bus;
});

final xpEngineProvider = Provider<XpEngine>((ref) => XpEngine());

final pathEngineProvider = Provider<PathEngine>((ref) => PathEngine());

final storageProvider = Provider<SecureStore>((ref) => SecureStore());

final stateMachineProvider = Provider<StateMachine>((ref) => StateMachine(
      xpEngine: ref.read(xpEngineProvider),
      pathEngine: ref.read(pathEngineProvider),
    ));

final appControllerProvider =
    StateNotifierProvider<AppController, AppState>((ref) {
  final controller = AppController(
    bus: ref.read(eventBusProvider),
    machine: ref.read(stateMachineProvider),
    store: ref.read(storageProvider),
  );
  ref.onDispose(controller.dispose);
  return controller;
});
