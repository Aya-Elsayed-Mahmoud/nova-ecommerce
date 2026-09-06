# NOVA - Profile / Settings Feature

This feature is intentionally isolated under `lib/features/profile/`.

## Scope

- GET `/users/profile`
- PUT `/users/profile`
- GET `/system/settings`
- Profile screen
- Edit profile screen
- Privacy Policy
- Terms of Service
- Contact Us / Support
- About Us
- Dark mode setting display

## Merge-safety

This feature does NOT modify:

- `main.dart`
- `pubspec.yaml`
- `pubspec.lock`
- `core/theme/*`
- `core/network/*`
- `core/routing/*`
- other feature folders

The existing `ProfileScreen` file is the only existing project file that this feature owns/replaces.

## Important API contract note

The public Scalar page was not accessible from the current environment, so the model/parser intentionally accepts common response wrappers (`data`, `result`) and common profile field names.

Before final backend integration, verify the exact request/response field names in:

- GET `/users/profile`
- PUT `/users/profile`
- GET `/system/settings`

Only `UserProfileModel.toUpdateJson()` should need adjustment if the PUT body uses different field names.

## Usage

```dart
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (_) => const ProfileScreen(),
  ),
);
```

If the auth layer already injects a bearer token into `DioClient.dio`, no change is needed.

Otherwise:

```dart
ProfileScreen(
  repository: ProfileRepository(accessToken: token),
)
```

## Why this is merge-safe

All new files live under the profile feature. Shared project files are only imported, not edited. Routing can be connected by the teammate who owns navigation.
