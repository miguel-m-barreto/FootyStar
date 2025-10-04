import 'app_localizations.dart';

/// Holds the current AppLocalizations for places where BuildContext isn't available.
class L10n {
  static AppLocalizations? _current;

  /// Update the current localizations (call this whenever locale changes).
  static void set(AppLocalizations l10n) {
    _current = l10n;
  }

  /// Access the current localizations. Throws if not set.
  static AppLocalizations get i {
    final v = _current;
    if (v == null) {
      throw StateError(
        'L10n not initialized. Call L10n.set(AppLocalizations.of(context)!) early in your app.',
      );
    }
    return v;
  }
}
