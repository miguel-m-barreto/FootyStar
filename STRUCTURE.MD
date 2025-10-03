lib/
core/
l10n/          # localization (app_strings.dart, future i18n files)
theme/         # global styling (colors, typography, spacing)
widgets/       # shared UI components (reusable across features)
utils/         # generic helpers (rng.dart, formatters, etc.)
domain/          # pure domain models (Player, Team, Fixture, MatchResult, etc.)
data/            # services and repositories (business logic, simulations, economy, training)
app/
controllers/   # Riverpod Notifiers / controllers for global state
providers/     # Riverpod Providers declarations for global use
state/         # global app state objects / DTOs (session, game state, etc.)
features/
home/
ui/          # home_screen.dart and its widgets/
training/
ui/          # training_screen.dart and its widgets/
squad/
ui/          # squad_screen.dart and its widgets/
casino/
ui/          # casino_screen.dart and its widgets/
economy/
ui/          # economy_screen.dart and its widgets/
standings/
ui/          # standings_screen.dart and its widgets/
routes/
shell_tabs.dart   # navigation tabs / main app shell

---

Domain: what the game is (rules, models).

Data: how the game logic runs (services, simulation).

App: how the app manages state (controllers, providers).

Features: what the user sees (UI + feature-local logic).

Core: shared infrastructure (theme, utils, widgets, l10n).

Routes: navigation skeleton.

---

