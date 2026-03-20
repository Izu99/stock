# Architectural Contract: Frontend Bug Fixes

## Data Model Sync
- **User Model**: Confirmed structure is `{ id, username, email, role, company: Company?, token }`.
- **Company Model**: Confirmed structure includes `{ name, address, phone, owner }`.

## API Contracts
- **Auth ME**: `/auth/me` (GET) - Returns current user with populated company.

## Component Fixes

### 1. Auth Provider (`auth_provider.dart`)
- **Fix**: Ensure `riverpod_generator` syntax is correct. `companyDetails` should use `@riverpod` or `@Riverpod()`.
- **Ref**: `CompanyDetailsRef` is generated. If not found, check `part 'auth_provider.g.dart';` and run build runner.

### 2. Dashboard Screen (`dashboard_screen.dart`)
- **Fix**: Update `user?.companyName` to `user?.company?.name`.

### 3. Billing Screen (`billing_screen.dart`)
- **Fix**: Import `auth_provider.dart` to access `companyDetailsProvider`.
- **Fix**: Cast `company` correctly. `final company = await ref.read(companyDetailsProvider.future);` should be checked for null.

### 4. Export Utils (`export_utils.dart`)
- **Fix**: Replace `pw.Divider(margin: ...)` with `pw.Column` containing `SizedBox` and `Divider`.

## Execution Plan

### Step 1: Resolve Core Provider Errors
- **Task**: Fix `auth_provider.dart` syntax and run `build_runner`.
- **Validation**: `dart run build_runner build --delete-conflicting-outputs`. Check if `auth_provider.g.dart` contains `CompanyDetailsRef`.

### Step 2: Fix UI Components
- **Task**: Update `dashboard_screen.dart` and `billing_screen.dart`.
- **Validation**: `flutter analyze client/lib/features/dashboard` and `flutter analyze client/lib/features/sales`.

### Step 3: Fix Export Logic
- **Task**: Correct `export_utils.dart` PDF widgets.
- **Validation**: `flutter analyze client/lib/core/utils/export_utils.dart`.

### Step 4: Final Integration
- **Task**: Full project analysis and `flutter run`.
- **Validation**: `flutter analyze` (zero errors).
