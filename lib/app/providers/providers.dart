// lib/app/providers/providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/app_message.dart';
import '../controllers/game_controller.dart';
import '../controllers/notifications_controller.dart';
import '../state/game_state.dart';

final gameControllerProvider =
NotifierProvider<GameController, GameState>(() => GameController());

// Single notifications provider
final notificationsProvider =
StateNotifierProvider<NotificationsController, List<AppMessage>>(
      (ref) => NotificationsController(),
);
