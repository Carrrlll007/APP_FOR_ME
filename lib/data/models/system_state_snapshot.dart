import 'dart:convert';

import 'artifact.dart';
import 'path.dart';
import 'quest.dart';
import '../../state/app_state.dart';

class SystemStateSnapshot {
  final String mode;
  final int totalXp;
  final int level;
  final int xpIntoLevel;
  final int dailyXp;
  final String? lastActionAt;
  final List<String> recentActions;
  final PathSnapshot path;
  final List<Artifact> artifacts;
  final Quest? activeQuest;
  final bool degraded;

  const SystemStateSnapshot({
    required this.mode,
    required this.totalXp,
    required this.level,
    required this.xpIntoLevel,
    required this.dailyXp,
    required this.lastActionAt,
    required this.recentActions,
    required this.path,
    required this.artifacts,
    required this.activeQuest,
    required this.degraded,
  });

  factory SystemStateSnapshot.fromState(AppState state) {
    return SystemStateSnapshot(
      mode: state.mode.name,
      totalXp: state.totalXp,
      level: state.level,
      xpIntoLevel: state.xpIntoLevel,
      dailyXp: state.dailyXp,
      lastActionAt: state.lastActionAt?.toIso8601String(),
      recentActions:
          state.recentActions.map((e) => e.toIso8601String()).toList(),
      path: state.path,
      artifacts: state.artifacts,
      activeQuest: state.activeQuest,
      degraded: state.degraded,
    );
  }

  String toJsonString() => jsonEncode(toJson());

  Map<String, dynamic> toJson() => {
        'mode': mode,
        'totalXp': totalXp,
        'level': level,
        'xpIntoLevel': xpIntoLevel,
        'dailyXp': dailyXp,
        'lastActionAt': lastActionAt,
        'recentActions': recentActions,
        'path': path.toJson(),
        'artifacts': artifacts.map(_artifactToJson).toList(),
        'activeQuest': activeQuest == null ? null : _questToJson(activeQuest!),
        'degraded': degraded,
      };

  factory SystemStateSnapshot.fromJsonString(String raw) {
    return SystemStateSnapshot.fromJson(jsonDecode(raw));
  }

  factory SystemStateSnapshot.fromJson(Map<String, dynamic> json) {
    return SystemStateSnapshot(
      mode: json['mode'] as String? ?? SystemMode.idle.name,
      totalXp: json['totalXp'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      xpIntoLevel: json['xpIntoLevel'] as int? ?? 0,
      dailyXp: json['dailyXp'] as int? ?? 0,
      lastActionAt: json['lastActionAt'] as String?,
      recentActions: (json['recentActions'] as List<dynamic>? ?? [])
          .cast<String>(),
      path: json['path'] == null
          ? PathSnapshot.initial()
          : PathSnapshot.fromJson(json['path'] as Map<String, dynamic>),
      artifacts: (json['artifacts'] as List<dynamic>? ?? [])
          .map((e) => _artifactFromJson(e as Map<String, dynamic>))
          .toList(),
      activeQuest: json['activeQuest'] == null
          ? null
          : _questFromJson(json['activeQuest'] as Map<String, dynamic>),
      degraded: json['degraded'] as bool? ?? false,
    );
  }

  static Map<String, dynamic> _artifactToJson(Artifact a) => {
        'id': a.id,
        'at': a.at.toIso8601String(),
        'descriptor': a.descriptor,
        'questId': a.questId,
        'tier': a.tier.name,
      };

  static Artifact _artifactFromJson(Map<String, dynamic> json) => Artifact(
        id: json['id'] as String,
        at: DateTime.parse(json['at'] as String),
        descriptor: json['descriptor'] as String,
        questId: json['questId'] as String,
        tier: QuestTier.values.firstWhere(
          (e) => e.name == json['tier'],
          orElse: () => QuestTier.micro,
        ),
      );

  static Map<String, dynamic> _questToJson(Quest q) => {
        'id': q.id,
        'title': q.title,
        'tier': q.tier.name,
        'focus': q.focus.name,
        'durationSec': q.durationSec,
      };

  static Quest _questFromJson(Map<String, dynamic> json) => Quest(
        id: json['id'] as String,
        title: json['title'] as String,
        tier: QuestTier.values.firstWhere(
          (e) => e.name == json['tier'],
          orElse: () => QuestTier.micro,
        ),
        focus: QuestFocus.values.firstWhere(
          (e) => e.name == json['focus'],
          orElse: () => QuestFocus.clarity,
        ),
        durationSec: json['durationSec'] as int? ?? 30,
      );
}
