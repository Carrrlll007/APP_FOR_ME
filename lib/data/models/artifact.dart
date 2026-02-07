import 'quest.dart';

class Artifact {
  final String id;
  final DateTime at;
  final String descriptor;
  final String questId;
  final QuestTier tier;

  const Artifact({
    required this.id,
    required this.at,
    required this.descriptor,
    required this.questId,
    required this.tier,
  });
}
