import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:footy_star/core/l10n/app_localizations.dart';
import 'package:footy_star/main.dart'; // localeProvider

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late String _localeCode;

  @override
  void initState() {
    super.initState();
    final current = ref.read(localeProvider);
    _localeCode = (current ?? const Locale('en')).languageCode;
  }

  void _changeLocale(String? value) {
    if (value == null) return;
    setState(() => _localeCode = value);
    ref.read(localeProvider.notifier).state = Locale(value);
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.languageChanged)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.language, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _localeCode,
            items: const [
              DropdownMenuItem(value: 'en', child: Text('English')),
              DropdownMenuItem(value: 'pt', child: Text('Português')),
            ],
            onChanged: _changeLocale,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: l10n.selectLanguage,
            ),
          ),
          const SizedBox(height: 24),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.preview),
            subtitle: Text(l10n.previewSubtitle),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(onPressed: () {}, child: Text(l10n.train)),
              OutlinedButton(onPressed: () {}, child: Text(l10n.restAllSquad)),
              FilledButton(onPressed: () {}, child: Text(l10n.casinoAllIn)),
            ],
          ),
        ],
      ),
    );
  }
}
