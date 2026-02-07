import '../data/models/quest.dart';

sealed class AppEvent {
  final DateTime at;
  const AppEvent(this.at);
}

class InterferenceDetected extends AppEvent {
  final int intensity;
  const InterferenceDetected({required super.at, this.intensity = 1});
}

class ForgeStarted extends AppEvent {
  final Quest quest;
  const ForgeStarted({required super.at, required this.quest});
}

class ForgeSuccess extends AppEvent {
  final Quest quest;
  const ForgeSuccess({required super.at, required this.quest});
}

class ForgeAbort extends AppEvent {
  const ForgeAbort({required super.at});
}

class QuestCompleted extends AppEvent {
  final Quest quest;
  const QuestCompleted({required super.at, required this.quest});
}

class RecoveryTriggered extends AppEvent {
  const RecoveryTriggered({required super.at});
}

class StabilityAchieved extends AppEvent {
  const StabilityAchieved({required super.at});
}

class EndgameReached extends AppEvent {
  const EndgameReached({required super.at});
}

class ManualReset extends AppEvent {
  const ManualReset({required super.at});
}
