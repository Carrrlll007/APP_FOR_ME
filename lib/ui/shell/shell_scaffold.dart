import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../../data/quest_samples.dart';
import '../../services/event_bus.dart';
import '../../state/app_event.dart';
import '../../state/app_state.dart';
import '../../state/providers.dart';
import '../../features/idle/idle_screen.dart';
import '../../features/interference/interference_screen.dart';
import '../../features/forge/forge_screen.dart';
import '../../features/recovery/recovery_screen.dart';
import '../../features/stable/stable_screen.dart';
import '../../features/endgame/endgame_screen.dart';
import '../widgets/glass_panel.dart';
import 'status_hud.dart';

class ShellScaffold extends ConsumerWidget {
  const ShellScaffold({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appControllerProvider);
    final bus = ref.read(eventBusProvider);

    final screen = _screenFor(state.mode);

    return Scaffold(
      body: Stack(
        children: [
          const _Background(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const StatusHud(),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GlassPanel(
                      padding: const EdgeInsets.all(20),
                      child: screen,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _ControlStrip(state: state, bus: bus),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _screenFor(SystemMode mode) {
    switch (mode) {
      case SystemMode.idle:
        return const IdleScreen();
      case SystemMode.interference:
        return const InterferenceScreen();
      case SystemMode.forgeActive:
        return const ForgeScreen();
      case SystemMode.recovery:
        return const RecoveryScreen();
      case SystemMode.stable:
        return const StableScreen();
      case SystemMode.endgame:
        return const EndgameScreen();
    }
  }
}

class _Background extends StatelessWidget {
  const _Background();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [SQColors.background, SQColors.background2],
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: const Alignment(-0.8, -0.6),
            child: _GlowBlob(color: SQColors.glow.withOpacity(0.25)),
          ),
          Align(
            alignment: const Alignment(0.8, 0.6),
            child: _GlowBlob(color: SQColors.accent.withOpacity(0.2)),
          ),
        ],
      ),
    );
  }
}

class _GlowBlob extends StatelessWidget {
  final Color color;

  const _GlowBlob({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, Colors.transparent],
        ),
      ),
    );
  }
}

class _ControlStrip extends StatelessWidget {
  final AppState state;
  final EventBus bus;

  const _ControlStrip({required this.state, required this.bus});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final quest = state.activeQuest ?? QuestSamples.forge();

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        _ActionButton(
          label: 'Signal',
          onTap: () => bus.emit(InterferenceDetected(at: now)),
        ),
        _ActionButton(
          label: 'Forge',
          onTap: () =>
              bus.emit(ForgeStarted(at: now, quest: QuestSamples.forge())),
        ),
        _ActionButton(
          label: 'Complete',
          onTap: () => bus.emit(QuestCompleted(at: now, quest: quest)),
        ),
        _ActionButton(
          label: 'Recovery',
          onTap: () => bus.emit(RecoveryTriggered(at: now)),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ActionButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassPanel(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        radius: 14,
        child: Text(label),
      ),
    );
  }
}
