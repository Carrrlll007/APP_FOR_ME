import 'package:flutter/material.dart';

import '../../core/constants.dart';

class GlowDivider extends StatelessWidget {
  const GlowDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.transparent, SQColors.glow, Colors.transparent],
        ),
      ),
    );
  }
}
