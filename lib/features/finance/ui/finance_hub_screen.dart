import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FinanceHubScreen extends ConsumerWidget {
  const FinanceHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Finance')),
      body: Center(
        child: Text(
          'Finance Hub - Coming Soon\n\n'
              'Will include:\n'
              '• Weekly Statement\n'
              '• Income Sources\n'
              '• Expenses Breakdown\n'
              '• Budget Planning',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}