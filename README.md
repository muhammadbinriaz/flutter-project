# Leads MVP

A Flutter web lead-generation MVP based on the approved mobile dashboard design.
It provides a pipeline dashboard, searchable and filterable lead cards, lead
details, status insights, and a company-enrichment flow connected to the
existing FastAPI leads engine.

## Run the web app

```powershell
flutter pub get
flutter run -d web-server --web-hostname localhost --web-port 3000
```

The app uses sample lead cards so the dashboard can be demonstrated before the
backend is running. Start the FastAPI leads engine to scrape and enrich real
companies. Its default API address is `http://localhost:8000`.

Override the API address when needed:

```powershell
flutter run --dart-define=API_BASE_URL=https://your-api.example.com
```

The web app uses port 3000 by default to match the CORS origin already allowed
by the leads-engine backend. The app calls `POST /process` and polls
`GET /process/{job_id}/status` until the job is complete.

## Lead sheet

Use the centered **+** action to submit company names or websites (one per line).
As results arrive, they appear in the lead list and update the dashboard.
Missing data is labeled explicitly rather than left as a blank cell. Use
**Export** to download the complete lead sheet as CSV, including the enrichment
fields from the API, headers, and placeholders for missing fields. The CSV is
saved/downloaded as `leads_mvp.csv`. Values in the initial sample workspace
are illustrative; estimated deal value is not provided by the current
lead-engine API.

## Code layout

- `lib/app.dart`: app title, root route, and Material theme.
- `lib/screens/`: dashboard state and screen-specific view extensions.
- `lib/widgets/`: reusable lead cards, dashboard widgets, and bottom sheets.
- `lib/models/lead.dart`: lead model and API response parsing.
- `lib/services/lead_api.dart`: HTTP client for the existing FastAPI pipeline.
- `lib/theme/` and `lib/utils/`: shared colors and formatting helpers.

## Verify the web app

```powershell
flutter analyze
flutter test
flutter build web
```
