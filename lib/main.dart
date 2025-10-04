import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'routes/shell_tabs.dart';
import 'core/l10n/app_localizations.dart';
import 'core/l10n/l10n_singleton.dart'; // adiciona isto

// Controls current app locale (null = system)
final localeProvider = StateProvider<Locale?>((_) => null);

void main() => runApp(const ProviderScope(child: MyApp()));

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final l10 = L10n.i;

    return MaterialApp(
      title: l10.footyStar,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.light,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('pt')],
      // builder to update the singleton
      builder: (context, child) {
        final l10n = AppLocalizations.of(context);
        if (l10n != null) {
          L10n.set(l10n);
        }
        return child ?? const SizedBox.shrink();
      },
      home: const ShellTabs(),
    );
  }
}
