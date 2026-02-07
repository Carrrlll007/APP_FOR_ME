enum QuestTier { micro, light, standard, forge, recovery }

enum QuestFocus { clarity, strength, expansion }

class Quest {
  final String id;
  final String title;
  final QuestTier tier;
  final QuestFocus focus;
  final int durationSec;

  const Quest({
    required this.id,
    required this.title,
    required this.tier,
    required this.focus,
    required this.durationSec,
  });
}
