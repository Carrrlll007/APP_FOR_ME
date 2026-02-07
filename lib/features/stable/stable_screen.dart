import 'package:flutter/material.dart';

class StableScreen extends StatelessWidget {
  const StableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Systems stable.', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 6),
        const Text('External operation recommended.'),
      ],
    );
  }
}
