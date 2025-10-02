import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/app_message.dart';
import '../controllers/game_controller.dart';
import '../state/game_state.dart';
import '../controllers/notifications_controller.dart';

final gameControllerProvider = NotifierProvider<GameController, GameState>(() => GameController());

// Notifications
final notificationsProvider =
StateNotifierProvider<NotificationsController, List<AppMessage>>(
      (ref) => NotificationsController(),
);