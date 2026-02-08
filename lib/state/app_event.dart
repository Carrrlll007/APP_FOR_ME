import '../data/models/quest.dart';

sealed class AppEvent {
  final DateTime at;
  const AppEvent(this.at);
}

class InterferenceDetected extends AppEvent {
  final int intensity;
  const InterferenceDetected({required DateTime at, this.intensity = 1}) : super(at);
}

class ForgeStarted extends AppEvent {
  final Quest quest;
  const ForgeStarted({required DateTime at, required this.quest}) : super(at);
}

class ForgeSuccess extends AppEvent {
  final Quest quest;
  const ForgeSuccess({required DateTime at, required this.quest}) : super(at);
}

class ForgeAbort extends AppEvent {
  const ForgeAbort({required DateTime at}) : super(at);
}

class QuestCompleted extends AppEvent {
  final Quest quest;
  const QuestCompleted({required DateTime at, required this.quest}) : super(at);
}

class RecoveryTriggered extends AppEvent {
  const RecoveryTriggered({required DateTime at}) : super(at);
}

class StabilityAchieved extends AppEvent {
  const StabilityAchieved({required DateTime at}) : super(at);
}

class EndgameReached extends AppEvent {
  const EndgameReached({required DateTime at}) : super(at);
}

class ManualReset extends AppEvent {
  const ManualReset({required DateTime at}) : super(at);
}
