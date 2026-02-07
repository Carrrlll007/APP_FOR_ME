import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/path.dart';
import '../../services/xp_engine.dart';
import '../../state/app_state.dart';
import '../../state/providers.dart';
import '../widgets/glass_panel.dart';

class StatusHud extends ConsumerWidget {
  const StatusHud({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appControllerProvider);

    return GlassPanel(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _HudBlock(label: 'Mode', value: _modeLabel(state.mode)),
          _HudBlock(label: 'Level', value: 'L${state.level}'),
          _HudBlock(
            label: 'XP',
            value:
                '${state.xpIntoLevel}/${XpEngine.xpRequiredForLevel(state.level)}',
          ),
          _HudBlock(label: 'Path', value: _pathLabel(state.path.dominant)),
        ],
      ),
    );
  }

  String _modeLabel(SystemMode mode) {
    switch (mode) {
      case SystemMode.idle:
        return 'IDLE';
      case SystemMode.interference:
        return 'INTERFERENCE';
      case SystemMode.forgeActive:
        return 'FORGE';
      case SystemMode.recovery:
        return 'RECOVERY';
      case SystemMode.stable:
        return 'STABLE';
      case SystemMode.endgame:
        return 'ENDGAME';
    }
  }

  String _pathLabel(PathKind kind) {
    switch (kind) {
      case PathKind.clarity:
        return 'Clarity';
      case PathKind.strength:
        return 'Strength';
      case PathKind.expansion:
        return 'Expansion';
      case PathKind.neutral:
        return 'Neutral';
    }
  }
}

class _HudBlock extends StatelessWidget {
  final String label;
  final String value;

  const _HudBlock({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(color: Colors.white70),
        ),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(letterSpacing: 0.6),
        ),
      ],
    );
  }
}
