import '../core/constants.dart';
import '../data/models/quest.dart';
import '../state/app_state.dart';

class XpResult {
  final int gained;
  final int totalXp;
  final int level;
  final int xpIntoLevel;
  final int dailyXp;
  final List<DateTime> recentActions;

  const XpResult({
    required this.gained,
    required this.totalXp,
    required this.level,
    required this.xpIntoLevel,
    required this.dailyXp,
    required this.recentActions,
  });
}

class XpEngine {
  static int xpRequiredForLevel(int level) {
    if (level <= 1) return 40;
    if (level == 2) return 60;
    if (level == 3) return 90;
    if (level == 4) return 130;

    var required = 130;
    for (var l = 5; l <= level; l++) {
      required = (required * 1.25).round();
    }
    return required;
  }

  XpResult award({
    required AppState state,
    required Quest quest,
    required DateTime at,
  }) {
    final base = _baseXp(quest.tier);

    final isSameDay = _isSameDay(state.lastActionAt, at);
    var dailyXp = isSameDay ? state.dailyXp : 0;

    final recent = _trimRecent(state.recentActions, at);
    final rapidCount = recent
        .where((t) => at.difference(t) <= SQConstants.rapidWindow)
        .length;

    var multiplier = 1.0;
    if (dailyXp >= SQConstants.dailySoftCap) {
      multiplier *= 0.5;
    }
    if (rapidCount >= 3) {
      multiplier *= 0.5;
    }

    var gained = (base * multiplier).round();
    if (gained < 1) gained = 1;

    dailyXp += gained;

    final updatedRecent = [...recent, at];

    final progress = _applyLevels(
      level: state.level,
      xpIntoLevel: state.xpIntoLevel,
      gained: gained,
    );

    return XpResult(
      gained: gained,
      totalXp: state.totalXp + gained,
      level: progress.level,
      xpIntoLevel: progress.xpIntoLevel,
      dailyXp: dailyXp,
      recentActions: updatedRecent,
    );
  }

  int _baseXp(QuestTier tier) {
    switch (tier) {
      case QuestTier.micro:
        return 5;
      case QuestTier.light:
        return 10;
      case QuestTier.standard:
        return 20;
      case QuestTier.forge:
        return 25;
      case QuestTier.recovery:
        return 8;
    }
  }

  bool _isSameDay(DateTime? last, DateTime now) {
    if (last == null) return false;
    return last.year == now.year &&
        last.month == now.month &&
        last.day == now.day;
  }

  List<DateTime> _trimRecent(List<DateTime> recent, DateTime now) {
    return recent
        .where((t) => now.difference(t) <= const Duration(hours: 24))
        .toList();
  }

  _LevelProgress _applyLevels({
    required int level,
    required int xpIntoLevel,
    required int gained,
  }) {
    var currentLevel = level;
    var currentXp = xpIntoLevel + gained;
    var required = xpRequiredForLevel(currentLevel);

    while (currentXp >= required) {
      currentXp -= required;
      currentLevel += 1;
      required = xpRequiredForLevel(currentLevel);
    }

    return _LevelProgress(level: currentLevel, xpIntoLevel: currentXp);
  }
}

class _LevelProgress {
  final int level;
  final int xpIntoLevel;

  const _LevelProgress({required this.level, required this.xpIntoLevel});
}
