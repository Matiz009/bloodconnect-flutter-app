# BloodConnect

A Flutter + Firebase mobile app that connects blood donors with people who need blood.

> 📸 Screenshots: TODO

## Features

- Email sign-up and login with Firebase Auth. Users register with their blood group.
- Create blood requests (blood group, hospital, city) stored in Cloud Firestore
- Home feed of open requests, with a detail screen for each one
- Call the requester directly from the app (`tel:` via `url_launcher`)

## Tech stack

Flutter · Dart · Firebase Auth · Cloud Firestore · Firebase Messaging · Provider · Shared Preferences

## Getting started

```bash
flutter pub get
flutter run
```

To use your own Firebase project, run `flutterfire configure` to regenerate `lib/firebase_options.dart` and `android/app/google-services.json`.

## Project structure

```
lib/
  main.dart
  models/     user, blood request
  screens/    splash, login, register, home, create request, request detail
  services/   auth_service, firestore_service
  utils/      constants
```

## Author

**Mati ul Rehman**: [github.com/Matiz009](https://github.com/Matiz009)
