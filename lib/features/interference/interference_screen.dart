import 'package:flutter/material.dart';

class InterferenceScreen extends StatelessWidget {
  const InterferenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('External interference detected.',
            style: theme.textTheme.headlineSmall),
        const SizedBox(height: 6),
        const Text('Forge available.'),
      ],
    );
  }
}
