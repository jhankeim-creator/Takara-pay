# StripCard User App — Update Guide (v4.7.0 → v4.8.0)

This package contains only the files that changed between v4.7.0 and v4.8.0. Follow these steps in order.

## 1. Back up your current project
Copy your whole project folder somewhere safe, or commit your current work to Git, before changing anything. If something goes wrong you want an easy way back.

## 2. Check for your own customizations first
If you've customized any of the files listed in `CHANGED_FILES.txt`, open them side-by-side with the new versions before overwriting — don't blindly replace. The files in this update that buyers most commonly customize are:
- `lib/base/api/endpoint/api_endpoint.dart` — your backend domain (`mainDomain`) lives here. **Do not overwrite this with the version in this package** — see step 5.
- `lib/base/utils/language/strings.dart` and `assets/lang/en.json` — if you added or edited any translation text, merge your changes in rather than replacing the file outright.
- `pubspec.yaml` — if you changed the app name, description, or added your own dependencies, merge rather than replace (see "About pubspec.yaml" below).

All other files in this update (the Strowallet card-holder screens/controllers/models, the shared image component, `api_method.dart`, `analysis_options.yaml`) are safe to replace outright unless you specifically modified them yourself.

## 3. Copy the files in
Copy everything from this package into your project root, preserving the folder structure, and replace files when your file manager/IDE asks.

## 4. Delete removed files
Check `DELETED_FILES.txt`. For this release it's empty (no files need deleting).

## 5. Restore your own configuration
After copying, double-check these are still YOUR values, not the ones from this package:
- `ApiEndpoint.mainDomain` in `lib/base/api/endpoint/api_endpoint.dart` — point it back at your own backend.
- Your Firebase config files (`android/app/google-services.json`, iOS `GoogleService-Info.plist`) — this package doesn't touch them, but double check if you replaced `api_endpoint.dart` by hand.
- Your Android package name / application ID and app icons — untouched by this update, but worth a quick check after any file replacement step.

## 6. About `pubspec.yaml` and dependencies
`pubspec.yaml`'s version was bumped to `4.8.0+19`. No new packages were added — only the version number changed. `pubspec.lock` was also updated (a handful of transitive/indirect dependencies resolved to newer patch versions; nothing you depend on directly changed). If you customized `pubspec.yaml` (app name, your own dependencies), merge the version line manually rather than overwriting the whole file.

Then run:
```
flutter clean
flutter pub get
```
No `build_runner` step is needed for this release — no new generated assets were added.

## 7. Test these screens
- Strowallet → Create Card → Create Card Holder (for a backend account with no card holder yet): dropdowns, ID image upload, and Submit should all work.
- Strowallet → Create Card → Customer Details (for an account that already has a card holder): should be fully read-only, with a masked ID number and no Submit button.
- My Card list, including a freshly purchased ("processing") Strowallet card.

## 8. Update your backend too
This release expects your backend API to already support the new Strowallet card-holder fields (Account Purpose, Employment Status, Occupation, ID Image) and to return the same "card holder not created yet" response shape this app now expects (HTTP 400 with `data: null` and a `message.error` array). Make sure your backend is on the matching v4.8.0 API version before rolling this out to users.
