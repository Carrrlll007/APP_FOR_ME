import 'package:flutter/material.dart';

import '../../ui/shell/star_map_onboarding.dart';

class IdleScreen extends StatelessWidget {
  const IdleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Systems idle.', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 6),
        const Text('Awaiting signal.'),
        const SizedBox(height: 18),
        const StarMapOnboarding(),
      ],
    );
  }
}
