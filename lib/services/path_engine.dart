import 'dart:math';

import '../core/constants.dart';
import '../data/models/path.dart';
import '../data/models/quest.dart';

class PathEngine {
  PathSnapshot update(PathSnapshot current, QuestFocus focus) {
    final decay = SQConstants.pathDecay;
    var clarity = current.clarity * decay;
    var strength = current.strength * decay;
    var expansion = current.expansion * decay;

    switch (focus) {
      case QuestFocus.clarity:
        clarity += 1.0;
        break;
      case QuestFocus.strength:
        strength += 1.0;
        break;
      case QuestFocus.expansion:
        expansion += 1.0;
        break;
    }

    final values = [clarity, strength, expansion];
    final maxValue = values.reduce(max);
    final sorted = [...values]..sort();
    final second = sorted[1];

    var dominant = PathKind.neutral;
    if (maxValue >= 2.0 && (maxValue - second) >= 0.5) {
      if (maxValue == clarity) dominant = PathKind.clarity;
      if (maxValue == strength) dominant = PathKind.strength;
      if (maxValue == expansion) dominant = PathKind.expansion;
    }

    return current.copyWith(
      clarity: clarity,
      strength: strength,
      expansion: expansion,
      dominant: dominant,
    );
  }
}
