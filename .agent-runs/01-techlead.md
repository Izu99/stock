# Milestone: Fix Frontend Errors and Enable Flutter Run

## Objective
Identify and resolve all compilation and linting errors in the Flutter frontend to allow a successful build and execution.

## Non-Goals
- Adding new features beyond what was already requested (invoice printing).
- Major refactoring of unaffected modules.

## Constraints
- Environment: win32
- Flutter SDK: ^3.10.7
- Riverpod for state management.

## Acceptance Criteria
- `flutter build apk` (or `flutter analyze`) passes without errors.
- `flutter run` starts the application successfully.
- Sales flow with quantity validation and invoice printing works as intended.

## Delivery Plan

### Debug Tasks (Initial Assessment)
- Run `flutter analyze` to get a fresh list of errors.
- Verify `auth_provider.dart` for correct Riverpod generation.

### Frontend Tasks
- Fix `CompanyDetailsRef` in `auth_provider.dart` (ensure correct generator syntax).
- Update `dashboard_screen.dart` to use `user?.company?.name`.
- Ensure `companyDetailsProvider` is correctly exported or imported in `billing_screen.dart`.
- Fix type mismatch in `billing_screen.dart` (ensure `company` is cast correctly).
- Clean up `export_utils.dart` (remove invalid `margin` and fix `Divider`).
- Add missing `dio` import in `auth_repository.dart` for `Options`.

### Integration Tasks
- Run `dart run build_runner build --delete-conflicting-outputs` to ensure all generated code is up-to-date.
- Final validation with `flutter analyze`.
