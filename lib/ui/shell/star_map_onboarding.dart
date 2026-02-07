import 'package:flutter/material.dart';

import '../widgets/glass_panel.dart';

class StarMapOnboarding extends StatelessWidget {
  const StarMapOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Star-Map Calibration',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        const Text('Adjusting signal cadence.'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: const [
            _Node(label: 'Weather'),
            _Node(label: 'Mass'),
            _Node(label: 'Noise'),
            _Node(label: 'Motion'),
            _Node(label: 'Light'),
          ],
        ),
      ],
    );
  }
}

class _Node extends StatelessWidget {
  final String label;

  const _Node({required this.label});

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      radius: 14,
      child: Text(label),
    );
  }
}
