import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:footy_star/core/l10n/app_localizations.dart';

import '../../../app/providers/providers.dart';
import '../models/match_moment.dart';

class MatchMomentsScreen extends ConsumerWidget {
  const MatchMomentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final s = ref.watch(gameControllerProvider);
    final moments = s.lastMatchMoments;

    return Scaffold(
      appBar: AppBar(title: const Text('Moments')), // swap to l10n when you add the key
      body: moments.isEmpty
          ? Center(child: Text(l10n.noFixturesScheduled)) // simple placeholder
          : buildMoments(moments),
    );
  }
}

/// Simple list for match moments (debug-friendly; plain EN text)
ListView buildMoments(List<MatchMoment> moments) {
  return ListView.separated(
    itemCount: moments.length,
    separatorBuilder: (_, __) => const Divider(height: 1),
    itemBuilder: (_, i) {
      final m = moments[i];
      String text;
      switch (m.type) {
        case MomentType.kickOff:
          text = "Kick-off ${m.args['home']} vs ${m.args['away']}";
          break;
        case MomentType.halfTime:
          text = "Half-time";
          break;
        case MomentType.fullTime:
          text = "Full-time";
          break;
        case MomentType.buildUp:
          text = "Build-up";
          break;
        case MomentType.chance:
          text = "Chance: ${m.args['att']} (xG ${m.args['xg']})";
          break;
        case MomentType.shotOnTarget:
          text = "Shot on target by ${m.args['att']}";
          break;
        case MomentType.shotOffTarget:
          text = "Shot off target by ${m.args['att']}";
          break;
        case MomentType.save:
          text = "Save by ${m.args['gk']}";
          break;
        case MomentType.goal:
          final ast = m.args['assist'];
          text = (ast == null || (ast is String && ast.isEmpty))
              ? "GOAL! ${m.args['scorer']}"
              : "GOAL! ${m.args['scorer']} (ast ${m.args['assist']})";
          break;
        case MomentType.foul:
          text = "Foul";
          break;
        case MomentType.yellow:
          text = "Yellow: ${m.args['player']}";
          break;
        case MomentType.red:
          text = "Red: ${m.args['player']}";
          break;
        case MomentType.injury:
          text = "Injury";
          break;
      }
      return ListTile(
        leading: Text("${m.minute}'"),
        title: Text(text),
        subtitle: Text(m.key), // handy for i18n debugging
      );
    },
  );
}
