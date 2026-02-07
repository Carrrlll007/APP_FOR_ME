import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../../data/quest_samples.dart';
import '../../state/app_event.dart';
import '../../state/providers.dart';
import '../../ui/widgets/glow_divider.dart';

class ForgeScreen extends ConsumerStatefulWidget {
  const ForgeScreen({super.key});

  @override
  ConsumerState<ForgeScreen> createState() => _ForgeScreenState();
}

class _ForgeScreenState extends ConsumerState<ForgeScreen>
    with SingleTickerProviderStateMixin {
  static const int _sessionSeconds = 30;
  static const int _requiredHits = 6;
  static const double _hitWindow = 0.12;
  static const Duration _pulseDuration = Duration(seconds: 4);

  late final AnimationController _pulse;
  Timer? _timer;

  int _remaining = _sessionSeconds;
  int _hits = 0;
  int _taps = 0;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: _pulseDuration)
      ..repeat();
    _startSession();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulse.dispose();
    super.dispose();
  }

  void _startSession() {
    _timer?.cancel();
    _remaining = _sessionSeconds;
    _hits = 0;
    _taps = 0;
    _completed = false;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_remaining <= 1) {
        timer.cancel();
        _finalize();
        return;
      }
      setState(() => _remaining -= 1);
    });
  }

  void _finalize() {
    if (_completed) return;
    _completed = true;

    final bus = ref.read(eventBusProvider);
    final state = ref.read(appControllerProvider);
    final quest = state.activeQuest ?? QuestSamples.forge();
    final now = DateTime.now();

    if (_hits >= _requiredHits) {
      bus.emit(ForgeSuccess(at: now, quest: quest));
    } else {
      bus.emit(ForgeAbort(at: now));
    }
  }

  void _registerTap() {
    if (_completed) return;
    final phase = _pulse.value;
    final nearPeak = phase >= (1.0 - _hitWindow) || phase <= _hitWindow;
    setState(() {
      _taps += 1;
      if (nearPeak) _hits += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Forge active.', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 6),
        const Text('30 seconds. Match the pulse.'),
        const SizedBox(height: 12),
        const GlowDivider(),
        const SizedBox(height: 16),
        Expanded(
          child: Center(
            child: GestureDetector(
              onTap: _registerTap,
              child: AnimatedBuilder(
                animation: _pulse,
                builder: (context, child) {
                  final scale = 0.8 + (_pulse.value * 0.3);
                  final cue = _pulse.value < 0.5 ? 'Inhale' : 'Exhale';
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                SQColors.glow.withOpacity(0.35),
                                SQColors.glow.withOpacity(0.02),
                                Colors.transparent,
                              ],
                            ),
                            border: Border.all(
                              color: SQColors.glow.withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        cue,
                        style: theme.textTheme.titleSmall
                            ?.copyWith(letterSpacing: 1.2),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _HudChip(label: 'Time', value: '${_remaining}s'),
            _HudChip(label: 'Sync', value: '$_hits/$_requiredHits'),
            _HudChip(label: 'Input', value: '$_taps'),
          ],
        ),
      ],
    );
  }
}

class _HudChip extends StatelessWidget {
  final String label;
  final String value;

  const _HudChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: SQColors.glass.withOpacity(0.12),
        border: Border.all(color: SQColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(color: Colors.white70),
          ),
          Text(value, style: theme.textTheme.titleSmall),
        ],
      ),
    );
  }
}
