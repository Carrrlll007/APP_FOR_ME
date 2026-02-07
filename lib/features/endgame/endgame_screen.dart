import 'package:flutter/material.dart';

class EndgameScreen extends StatelessWidget {
  const EndgameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('System quiet.', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 6),
        const Text('External operation recommended.'),
      ],
    );
  }
}
