# bike_kollective

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Architecture Notes

### State vs Presentation

The data directory contains the state management layer, and it should
remain cleanly separated and distinct from the presentation layer.

Data models define the different types of state the application manages,
both locally and from databases and other external sources.

Data providers define sources of data at a conceptual level, and encapsulates
the source(s) and business logic that produce that data. The associated
notifier for a provider exposes methods for handling events and updates to
the data from the UI and other parts of the state management layer. It is
important that the UI not know or care where data is coming from or going to
in order to keep the app simple and prevent difficult bugs like race conditions.

The presentation layer widgets should watch state from relevant providers.
Widgets should NOT contain business logic or be managing the details of
the data. They should simply render any new data from the provider and pass
UI events to the notifier. Forms can have their own state but once the form
is submitted, its state should be passed off to the appropriate provider notifier.
