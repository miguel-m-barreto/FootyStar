import 'package:flutter/material.dart';

class NationalStandingsScreen extends StatelessWidget {
  const NationalStandingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('National Standings')),
      body: const Center(
        child: Text('National rankings will be shown here'),
      ),
    );
  }
}