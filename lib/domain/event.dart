enum EventType { economic, sporting, personal }

class GameEvent {
  final String id;
  final EventType type;
  final String title;
  final String description;
  final void Function(_EventContext ctx) apply; //mutes state via context
  const GameEvent({required this.id, required this.type, required this.title, required this.description, required this.apply});
}

// reduced context to apply effects on the state
class _EventContext {
  int cashDelta = 0;
  double teamMoraleDelta = 0;
  double squadFatigueDelta = 0;
}
