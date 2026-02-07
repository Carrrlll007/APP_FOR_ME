import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/system_state_snapshot.dart';
import '../services/event_bus.dart';
import '../services/storage/secure_store.dart';
import 'app_event.dart';
import 'app_state.dart';
import 'state_machine.dart';

class AppController extends StateNotifier<AppState> {
  final EventBus bus;
  final StateMachine machine;
  final SecureStore store;
  late final StreamSubscription<AppEvent> _sub;

  AppController({
    required this.bus,
    required this.machine,
    required this.store,
  }) : super(AppState.initial()) {
    _init();
    _sub = bus.stream.listen(_onEvent);
  }

  Future<void> _init() async {
    final snapshot = await store.readState();
    if (snapshot != null) {
      state = AppState.fromSnapshot(snapshot);
    }
  }

  void _onEvent(AppEvent event) {
    state = machine.reduce(state, event);
    store.writeState(SystemStateSnapshot.fromState(state));
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
