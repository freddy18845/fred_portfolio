#!/usr/bin/env bash
# Build the Flutter web app and deploy it to Firebase Hosting.
set -euo pipefail
flutter pub get
flutter build web --release
firebase deploy --only hosting
