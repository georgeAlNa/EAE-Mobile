# EAE Mobile

EAE Mobile is a Flutter application for an assessment platform with role-based workflows for candidates, evaluators, and tenant administrators. The app connects to backend APIs through a layered networking architecture and includes authentication, account settings, assessment inventory, exam/session flows, evaluator management tools, and tenant administration tools.

The codebase uses a feature-first structure. Each backend-connected feature follows the same flow: JSON models, remote data source, repository, Cubit state management, and presentation widgets/screens.

## Main Features

- Authentication: login, registration, logout, password reset, and token refresh.
- Settings: identity profile, permissions, sessions, profile update, and logout/session revocation.
- Candidate workflows:
  - Assessment inventory and dashboard.
  - Assessment details and candidate assessment flow.
  - Assessment setup, session screens, uploads, navigation, submission, and forensic checkpoints.
  - Mobile proctoring during active exam sessions.
- Evaluator workflows:
  - Competencies management.
  - Exams management.
  - Question bank and categories management.
- Tenant admin workflows:
  - Users management.
  - Roles and security policy management.
  - Cohorts and cohort members management.
  - Live sessions and enrollment management.
  - Tenant admin navigation shell and shared UI widgets.
- Core app behavior:
  - Splash/startup flow.
  - Light/dark theme persistence.
  - Arabic/English language direction handling.
  - Shared networking, dependency injection, routing, and reusable widgets.

## Candidate Mobile Proctoring

Candidate exam sessions include Secure Exam Mode while an exam session is active. It is enabled when the candidate starts the exam and is stopped after the exam ends or the session screen is closed.

Secure Exam Mode includes:

- Android `FLAG_SECURE` to prevent screenshots and screen recording as much as the platform allows.
- Immersive fullscreen during the exam.
- App background and return monitoring.
- Split-screen and multi-window detection.
- Temporary interaction blocking when multi-window mode is detected.
- Question text selection restrictions.
- Device integrity signals such as rooted device, emulator, and debugger detection.
- Security Check before starting the exam.
- Proctoring events sent through the existing proctoring API integration.

Camera and microphone checks are not required by default. They depend on `ExamProctoringConfig`.

`FLAG_SECURE`, multi-window detection, and some device checks are Android-specific. Device integrity checks are heuristic signals and are not conclusive proof of cheating.

## Tech Stack

- Flutter
- Dart SDK `^3.9.2`
- `flutter_bloc` for Cubit/BLoC state management
- `dio` for API requests
- `get_it` for dependency injection
- `shared_preferences` for local persisted state
- `internet_connection_checker` for network availability checks
- `freezed` for generated union states
- `json_serializable` for request/response models
- `mocktail` and `flutter_test` for testing

## Project Structure

```text
lib/
  core/
    constants/
    di/
    helpers/
    language/
    networking/
    public_widgets/
    routing/
    theme/
  features/
    analytics/
    auth/
    candidate/
      assessment_inventory/
      assessment_setup/
      assessment_session/
      bottom_nav/
      forensics_checkpoint/
    evaluator/
      competencies/
      exams_management/
      question_bank_and_categories/
      bottom_nav/
    settings/
    splash/
    tenant_admin/
      cohorts/
      live_sessions_and_enrollment_management/
      roles_and_security/
      users_management/
      bottom_nav/
      shared/
  eae_app.dart
  main.dart
```

Backend-connected features generally use this internal structure:

```text
feature_name/
  data/
    datasources/
    models/
    repos/
  logic/
  presentation/
    screens/
    widgets/
```

## Backend Integration Pattern

Backend integration should stay consistent with the existing auth and feature modules:

- Request and response models live in `data/models`.
- Models use `json_serializable` and generated `.g.dart` files.
- Remote data sources call `ApiServicesImpl` and use `AppLinkUrl` endpoints.
- Repositories check `NetworkInfo` before calling the remote data source.
- Cubits call repositories only; UI should not call API services directly.
- Cubit states are modeled with `freezed`.
- Dependency injection is registered through the existing `get_it` setup.
- Access tokens are read from `AppSharedPreferences` where authenticated endpoints need them.

After editing generated model/state files, run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Testing

The project includes unit tests for the core Cubits and the backend-connected feature layers. Current test coverage focuses on:

- Model serialization/deserialization.
- Remote data source endpoint, token, and request body behavior.
- Repository online/offline/error paths.
- Cubit loading/success/error state emissions.
- Candidate Mobile Proctoring service, manager, Cubit integration, security check, and related widgets.

Tested feature areas include:

- `auth`
- `settings`
- `candidate/assessment_inventory`
- `candidate/assessment_session`
- `candidate/assessment_setup`
- `evaluator/competencies`
- `evaluator/exams_management`
- `evaluator/question_bank_and_categories`
- `tenant_admin/users_management`
- `tenant_admin/roles_and_security`
- `tenant_admin/live_sessions_and_enrollment_management`
- `tenant_admin/cohorts`

Run all tests:

```bash
flutter test
```

Run a specific feature test group:

```bash
flutter test test/features/tenant_admin/cohorts
flutter test test/features/evaluator/exams_management
flutter test test/features/candidate/assessment_session
```

## Development Commands

Install dependencies:

```bash
flutter pub get
```

Generate code:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Analyze the project:

```bash
flutter analyze
```

Format code:

```bash
dart format lib test
```

Run the app:

```bash
flutter run
```

List devices and run on a selected device:

```bash
flutter devices
flutter run -d <device-id>
```

## Prerequisites

Before running the project, install:

- Flutter SDK compatible with Dart `^3.9.2`
- Android Studio or VS Code
- Android SDK and an emulator, or a connected physical Android device
- Xcode if running on iOS or macOS

Check your local setup:

```bash
flutter doctor
```
