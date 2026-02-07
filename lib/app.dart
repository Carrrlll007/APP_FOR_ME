import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/glass_theme.dart';
import 'state/providers.dart';
import 'ui/shell/shell_scaffold.dart';

class SideQuestApp extends ConsumerWidget {
  const SideQuestApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(appControllerProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Side-Quest',
      theme: GlassTheme.dark,
      home: const ShellScaffold(),
    );
  }
}
