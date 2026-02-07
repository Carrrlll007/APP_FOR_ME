import 'package:flutter/material.dart';

class RecoveryScreen extends StatelessWidget {
  const RecoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recovery path engaged.', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 6),
        const Text('Minimal actions. Guaranteed success.'),
      ],
    );
  }
}
