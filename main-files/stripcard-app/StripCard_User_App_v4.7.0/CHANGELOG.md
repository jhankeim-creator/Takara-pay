# TAKARA PAY User App — v4.8.0 Changelog

## New
- **Strowallet card holder: new required details** — Account Purpose, Employment Status, and Occupation are now collected via dropdowns when creating a card holder for the first time.
- **Strowallet card holder: ID image upload** — you can now attach a photo of your ID when setting up your card holder. The Phone and ID Image fields now appear at the end of the form, matching the website.
- **Strowallet card holder: view-only once created** — once your card holder exists, it switches to a read-only "Customer Details" screen. Your ID number is shown masked (e.g. `•••••6789`) for privacy. Editing an existing card holder is no longer possible, matching how it's meant to work.

## Fixed
- New customers used to see a "Couldn't load card holder" error instead of the signup form the very first time they tried to set up a Strowallet card holder — they can now create one normally.
- A newly created ("processing") Strowallet card could crash the card list instead of showing up while it was still being issued — it now appears correctly while processing.
- Fixed a crash ("Infinity or NaN toInt") that could show a broken red box instead of the ID image preview on the Customer Details screen. The underlying fix is in the shared image component, so it also prevents the same potential crash from ever happening on the profile picture.

## Internal / under the hood
- Hardened Strowallet API response parsing throughout (card info, card list, user info) so missing/partial fields from the server degrade gracefully instead of crashing the app.
- Minor analyzer configuration cleanup (excludes generated Android/iOS build folders from static analysis).
