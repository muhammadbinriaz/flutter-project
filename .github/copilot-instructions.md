# Copilot instructions for Leads MVP

## Project overview

This repository is a Flutter web lead-generation MVP. The app is currently a
single `MaterialApp` whose home is `LeadFlowHome`, a stateful dashboard with
Home, Leads, Insights, and Profile tabs. The UI is intentionally constrained
to a 700 px content width and is backed by sample leads so it can be
demonstrated without the backend.

The enrichment workflow connects to the existing FastAPI leads engine:

- `POST /process` accepts a list of company names or websites and returns a
  job ID plus any immediately available results.
- `GET /process/{job_id}/status` is polled until the job is complete.
- The default web endpoint is `http://localhost:8000`; Android emulators use
  `http://10.0.2.2:8000`.
- `API_BASE_URL` can be supplied with `--dart-define` to override the endpoint.

## Build, test, and lint

Run commands from the repository root after installing Flutter/Dart and
fetching packages:

```powershell
flutter pub get
flutter run -d web-server --web-hostname localhost --web-port 3000
flutter analyze
flutter test
flutter build web
```

Run the current widget test file alone:

```powershell
flutter test test/widget_test.dart
```

Run one named test:

```powershell
flutter test test/widget_test.dart --plain-name "dashboard shows leads pipeline and priority leads"
```

The analyzer uses `flutter_lints` through `analysis_options.yaml`. Generated
Flutter, platform, and build directories are excluded from analysis; make
source changes under `lib/` or `test/`, not under `build/` or `.dart_tool/`.

## Architecture and data flow

- `lib/main.dart` starts `LeadsMvpApp`; `lib/app.dart` owns the root
  `MaterialApp`, title, theme, and home route.
- `lib/screens/lead_flow_home.dart` owns the shared dashboard state:
  sample/current leads, selected tab, search and status filters, and
  enrichment progress. Its `part` files contain view/action extensions for
  the top chrome, bottom navigation, dashboard, leads list, insights/profile,
  and lead actions.
- Reusable presentation components live in `lib/widgets/`. Bottom sheets
  handle company submission and lead details; cards and dashboard widgets
  should remain presentational and receive callbacks from the screen state.
- `lib/models/lead.dart` is the API-to-UI model boundary. `Lead.fromJson`
  maps API status strings and preserves missing optional fields as `null`.
  Unknown statuses currently fall back to `LeadStatus.newLead`.
- `lib/services/lead_api.dart` owns HTTP, response decoding, timeout/error
  handling, job progress parsing, and conversion of result rows to `Lead`.
  Keep API validation here rather than in widgets.
- `lib/theme/leads_theme.dart` contains shared colors and the Material 3
  theme. `lib/utils/lead_formatters.dart` contains shared status, currency,
  and card styling helpers.

When an enrichment job returns results, `_mergeResults` replaces an existing
lead by case-insensitive company name or inserts a new lead at the front.
Progress is updated from the status endpoint, and failures are surfaced to
the user with a SnackBar. CSV export is implemented in the lead actions part
and includes all enrichment fields plus explicit placeholders for missing
values.

## Repository-specific conventions

- Keep screen-specific UI in the existing `part` files of
  `lead_flow_home.dart`; do not create a second state owner for the same
  dashboard.
- Use `_refresh`/`setState` for state changes and check `mounted` after
  awaited work before updating UI or showing feedback.
- Use the shared `AppColors`, `buildAppTheme`, `cardDecoration`, status
  helpers, and existing widget primitives instead of duplicating visual
  constants.
- Preserve the distinction between unavailable API data (`null`) and
  display fallbacks. The model should not invent lead values, and UI/export
  code should label missing fields explicitly.
- Keep the API layer strict: validate JSON shapes and required fields, honor
  the existing 25-second request timeouts, and allow errors to reach the
  screen where they are shown to the user.
- Keep lead statuses aligned with `LeadStatus` and `statusLabel`; API
  `"completed"` and `"qualified"` both map to the qualified UI status.
- Company input is normalized by splitting on newlines/commas, trimming,
  dropping blanks, and de-duplicating before calling the API.
- Preserve the app’s Material 3 styling and compact dashboard layout when
  changing UI. User-visible controls should retain tooltips where the current
  tests or accessibility affordances rely on them.
- Add or update widget/model tests in `test/` when behavior changes. Existing
  tests cover model null handling, dashboard totals, status filtering, and the
  enrichment form.
