import 'package:uuid/uuid.dart';

import 'models/quest.dart';

class QuestSamples {
  static final _uuid = Uuid();

  static Quest forge() => Quest(
        id: _uuid.v4(),
        title: 'Rhythm Anchor',
        tier: QuestTier.forge,
        focus: QuestFocus.strength,
        durationSec: 30,
      );

  static Quest recovery() => Quest(
        id: _uuid.v4(),
        title: 'Signal Reset',
        tier: QuestTier.recovery,
        focus: QuestFocus.clarity,
        durationSec: 25,
      );
}
