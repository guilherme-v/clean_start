# Clean Start  🤖

![coverage][coverage_badge]

---

## What's Included? 📦

✅  Architecture - Clean architecture

✅  Build Flavors - Multiple flavor support for development, staging, and production

✅  Internationalization Support - Internationalization support

✅  Sound Null-Safety - No more null-dereference exceptions at runtime. Develop with a sound, static type system.

✅  Bloc - Integrated bloc architecture for scalable, testable code which offers a clear separation between business logic and presentation

✅  Testing - Unit and Widget Tests (no Integration Tests - for now)

✅  Logging - Extensible logging to capture uncaught Flutter and Dart Exceptions

✅  Very Good Analysis - Strict Lint Rules which are used at Very Good Ventures

✅  Continuous Integration - Lint, format, test, and enforce code coverage using GitHub Actions

![architecture](./art/app4.png?raw=true)

## Architecture overview 🏗️

![architecture](./art/arch.png?raw=true)

This project is configured using the called "Clean (or hexagonal) Architecture". You can read more about it here: [GuiCode][gui_code]. But in short:

**Domain Layer** - It contains all the Models and Use-cases that we need to design the solution to the problem. It's a plain dart module that doesn't have any external dependencies.

**Data Layer** - It's responsible for providing data to Domain's use-cases. It'll coordinate data fetching from 2 sources: Network and Local.

**Network Layer**- It's responsible for fetching data from the network.

**Local Layer**- It's responsible for fetching data from local sources (shared_preferences, databases, system...).

**Presentation Layer** - Flutter is used to create a UI and present its data correctly to the user. This data consumes use-cases from Domain.

---

## Up and running 🚀

You can run the app in the desired environment using the following command:

```sh
# Development
$ flutter run --flavor development --target lib/main_development.dart

# Staging
$ flutter run --flavor staging --target lib/main_staging.dart

# Production
$ flutter run --flavor production --target lib/main_production.dart
```

---

## Running Tests 🧪

I didn't have time to create the integration tests, but you can run the Unit/Widgets tests with the following command:

```sh
$ flutter test --coverage --test-randomize-ordering-seed random
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate the Report
$ genhtml coverage/lcov.info -o coverage/

# Check Report
$ open coverage/index.html
```

---

## Working with Translations 🌐

We're using [flutter_localizations][flutter_localizations_link] to handle the translations. For more information check: [official internationalization guide for Flutter][internationalization_link].

### Adding Strings

1. To add a new localizable string, open the `app_en.arb` file at `lib/app/l10n/arb/app_en.arb`.

```arb
{
    "@@locale": "en",
    "homeAppBarTitle": "Glucose History",
    "@homeAppBarTitle": {
        "description": "Text shown in the AppBar of the home Page"
    },
}
```

2. Add the new key/value and description

```arb
{
    "@@locale": "en",
    "homeAppBarTitle": "Glucose History",
    "@homeAppBarTitle": {
        "description": "Text shown in the AppBar of the home Page"
    },
    "homeLoadErrorMessage": "Something went wrong. Please try again later.",
    "@homeLoadErrorMessage": {
        "description": "Error text shown on the Home Page when an error ..."
    }
}
```

3. Use the new string

```dart
import 'package:rootshealth_test/app/l10n/l10n.dart';

@override
Widget build(BuildContext context) {
  final l10n = context.l10n;
  return Text(l10n.helloWorld);
}
```

### Adding new Location

If you'll include new location, you'll need to update the `CFBundleLocalizations` array in the `Info.plist` at `ios/Runner/Info.plist` to include it.

```xml
    ...

    <key>CFBundleLocalizations</key>
	<array>
		<string>en</string>
		<string>de</string>
	</array>

    ...
```

### Adding Translations

1. For each supported locale, add a new ARB file in `lib/app/l10n/arb`.

```
├── app
│  ├── l10n
│  │   ├── arb
│  │   │   ├── app_en.arb
│  │   │   └── app_de.arb (new)
```

2. Add the translated strings to each `.arb` file:

`app_de.arb`

```arb
{
  "@@locale": "de",
  "homeAppBarTitle": "Glukoseverlauf",
  "@homeAppBarTitle": {
    "description": "Text, der in der AppBar der Startseite angezeigt wird"
  },
}
```

[coverage_badge]: coverage_badge.svg
[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[license_link]: https://opensource.org/licenses/MIT
[gui_code]: https://github.com/guilherme-v/flutter-clean-arch
