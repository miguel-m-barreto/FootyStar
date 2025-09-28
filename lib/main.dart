import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ui/app_shell.dart';

void main() {
  runApp(const ProviderScope(child: FootyStarApp()));
}

class FootyStarApp extends StatelessWidget {
  const FootyStarApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Footy Star',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
        useMaterial3: true,
      ),
      home: const AppShell(),
    );
  }
}
