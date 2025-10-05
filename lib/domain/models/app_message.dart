class AppMessage {
  final String id;
  final String title;
  final String body;
  final DateTime ts;
  final bool read;

  const AppMessage({
    required this.id,
    required this.title,
    required this.body,
    required this.ts,
    this.read = false,
  });

  AppMessage copyWith({String? title, String? body, DateTime? ts, bool? read}) {
    return AppMessage(
      id: id,
      title: title ?? this.title,
      body: body ?? this.body,
      ts: ts ?? this.ts,
      read: read ?? this.read,
    );
  }
}
