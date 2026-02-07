import '../data/models/artifact.dart';
import '../data/models/path.dart';
import '../data/models/quest.dart';
import '../data/models/system_state_snapshot.dart';

enum SystemMode { idle, interference, forgeActive, recovery, stable, endgame }

class AppState {
  static const _unset = Object();

  final SystemMode mode;
  final int totalXp;
  final int level;
  final int xpIntoLevel;
  final int dailyXp;
  final DateTime? lastActionAt;
  final List<DateTime> recentActions;
  final PathSnapshot path;
  final Quest? activeQuest;
  final List<Artifact> artifacts;
  final bool degraded;

  const AppState({
    required this.mode,
    required this.totalXp,
    required this.level,
    required this.xpIntoLevel,
    required this.dailyXp,
    required this.lastActionAt,
    required this.recentActions,
    required this.path,
    required this.activeQuest,
    required this.artifacts,
    required this.degraded,
  });

  factory AppState.initial() => AppState(
        mode: SystemMode.idle,
        totalXp: 0,
        level: 1,
        xpIntoLevel: 0,
        dailyXp: 0,
        lastActionAt: null,
        recentActions: const [],
        path: PathSnapshot.initial(),
        activeQuest: null,
        artifacts: const [],
        degraded: false,
      );

  factory AppState.fromSnapshot(SystemStateSnapshot snap) {
    return AppState(
      mode: SystemMode.values.firstWhere(
        (e) => e.name == snap.mode,
        orElse: () => SystemMode.idle,
      ),
      totalXp: snap.totalXp,
      level: snap.level,
      xpIntoLevel: snap.xpIntoLevel,
      dailyXp: snap.dailyXp,
      lastActionAt: snap.lastActionAt == null
          ? null
          : DateTime.parse(snap.lastActionAt!),
      recentActions:
          snap.recentActions.map(DateTime.parse).toList(growable: false),
      path: snap.path,
      activeQuest: snap.activeQuest,
      artifacts: snap.artifacts,
      degraded: snap.degraded,
    );
  }

  AppState copyWith({
    SystemMode? mode,
    int? totalXp,
    int? level,
    int? xpIntoLevel,
    int? dailyXp,
    DateTime? lastActionAt,
    List<DateTime>? recentActions,
    PathSnapshot? path,
    Object? activeQuest = _unset,
    List<Artifact>? artifacts,
    bool? degraded,
  }) {
    return AppState(
      mode: mode ?? this.mode,
      totalXp: totalXp ?? this.totalXp,
      level: level ?? this.level,
      xpIntoLevel: xpIntoLevel ?? this.xpIntoLevel,
      dailyXp: dailyXp ?? this.dailyXp,
      lastActionAt: lastActionAt ?? this.lastActionAt,
      recentActions: recentActions ?? this.recentActions,
      path: path ?? this.path,
      activeQuest: activeQuest == _unset ? this.activeQuest : activeQuest as Quest?,
      artifacts: artifacts ?? this.artifacts,
      degraded: degraded ?? this.degraded,
    );
  }
}
