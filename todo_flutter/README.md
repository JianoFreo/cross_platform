# Flutter Task List App (Material 3)

This repo includes a ready-to-run Task app **template** (code + dependencies), plus a PowerShell bootstrapper that creates the Flutter project scaffolding for you.

## What you get

- Add, edit, delete tasks
- Mark complete/incomplete
- Filter: All / Active / Completed
- Swipe to delete (undo via snackbar)
- Local persistence using `shared_preferences` (stores JSON)
- Material 3 UI

## Prerequisites

- Install Flutter and ensure it’s on PATH (or set `FLUTTER_BIN` as described below)
- (Recommended) Android Studio or VS Code with Flutter extension

## Setup (Windows / PowerShell)

From the repo root (`C:\Users\jiano\cross_platform`):

```powershell
.\todo_flutter\setup.ps1
```

If `flutter` isn’t recognized, either restart your terminal after installing Flutter, or set:

```powershell
$env:FLUTTER_BIN="C:\path\to\flutter\bin\flutter.bat"
.\todo_flutter\setup.ps1
```

Then run:

```powershell
cd .\todo_flutter\app
flutter pub get
flutter run
```

## Files

- `todo_flutter\template\`: the app code and `pubspec.yaml`
- `todo_flutter\setup.ps1`: creates `todo_flutter\app\` via `flutter create` and copies the template in

