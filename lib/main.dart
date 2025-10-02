import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ui/screens/shell_tabs.dart';

void main() => runApp(const ProviderScope(child: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Footy Star',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF1E88E5)),
      home: const ShellTabs(),
    );
  }
}
