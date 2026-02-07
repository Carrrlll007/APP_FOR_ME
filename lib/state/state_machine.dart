import 'package:uuid/uuid.dart';

import '../data/models/artifact.dart';
import '../data/models/quest.dart';
import '../services/path_engine.dart';
import '../services/xp_engine.dart';
import 'app_event.dart';
import 'app_state.dart';

class StateMachine {
  final XpEngine xpEngine;
  final PathEngine pathEngine;
  static const _uuid = Uuid();

  const StateMachine({required this.xpEngine, required this.pathEngine});

  AppState reduce(AppState state, AppEvent event) {
    if (event is InterferenceDetected) {
      return state.copyWith(mode: SystemMode.interference);
    }

    if (event is ForgeStarted) {
      return state.copyWith(
        mode: SystemMode.forgeActive,
        activeQuest: event.quest,
      );
    }

    if (event is ForgeSuccess) {
      return _applyQuestCompletion(state, event.quest, event.at);
    }

    if (event is ForgeAbort) {
      return state.copyWith(
        mode: SystemMode.recovery,
        degraded: true,
        activeQuest: null,
      );
    }

    if (event is RecoveryTriggered) {
      return state.copyWith(
        mode: SystemMode.recovery,
        degraded: true,
      );
    }

    if (event is QuestCompleted) {
      return _applyQuestCompletion(state, event.quest, event.at);
    }

    if (event is StabilityAchieved) {
      return state.copyWith(mode: SystemMode.stable, degraded: false);
    }

    if (event is EndgameReached) {
      return state.copyWith(mode: SystemMode.endgame);
    }

    if (event is ManualReset) {
      return AppState.initial();
    }

    return state;
  }

  AppState _applyQuestCompletion(AppState state, Quest quest, DateTime at) {
    final result = xpEngine.award(
      state: state,
      quest: quest,
      at: at,
    );
    final updatedPath = pathEngine.update(state.path, quest.focus);
    final artifact = Artifact(
      id: _uuid.v4(),
      at: at,
      descriptor: _descriptorFor(quest),
      questId: quest.id,
      tier: quest.tier,
    );

    return state.copyWith(
      mode: SystemMode.stable,
      totalXp: result.totalXp,
      level: result.level,
      xpIntoLevel: result.xpIntoLevel,
      dailyXp: result.dailyXp,
      lastActionAt: at,
      recentActions: result.recentActions,
      path: updatedPath,
      activeQuest: null,
      artifacts: [...state.artifacts, artifact],
      degraded: false,
    );
  }

  String _descriptorFor(Quest quest) {
    switch (quest.tier) {
      case QuestTier.micro:
        return 'forged shard';
      case QuestTier.light:
        return 'stabilized anomaly';
      case QuestTier.standard:
        return 'cleared interference';
      case QuestTier.forge:
        return 'forge imprint';
      case QuestTier.recovery:
        return 'recovery trace';
    }
  }
}
