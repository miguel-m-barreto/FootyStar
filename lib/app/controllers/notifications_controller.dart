import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/app_message.dart';

class NotificationsController extends StateNotifier<List<AppMessage>> {
  NotificationsController() : super(const []);

  void push(AppMessage msg) {
    state = [msg, ...state];
  }

  void markRead(String id) {
    state = [
      for (final m in state)
        if (m.id == id) m.copyWith(read: true) else m
    ];
  }

  void clearAll() => state = const [];
}
