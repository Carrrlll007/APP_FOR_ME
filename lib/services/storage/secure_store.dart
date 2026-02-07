import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../data/models/system_state_snapshot.dart';

class SecureStore {
  static const _stateKey = 'side_quest_state';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> writeState(SystemStateSnapshot snapshot) async {
    await _storage.write(key: _stateKey, value: snapshot.toJsonString());
  }

  Future<SystemStateSnapshot?> readState() async {
    final raw = await _storage.read(key: _stateKey);
    if (raw == null || raw.isEmpty) return null;
    return SystemStateSnapshot.fromJsonString(raw);
  }
}
