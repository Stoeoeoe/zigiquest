# Localization
NEVER update app_locazion*.dart files yourself. Always just add the entry to the *.arb files in /l10n folder.

Steps:
1. import '../l10n/app_localizations.dart';
2. Defining l10n: final l10n = AppLocalizations.of(context)!;
3. Using: l10n.theString

# Generated code
After changes that affect generated code, such as Drift database definitions or localization ARB files, run:

`dart run build_runner build`

All user-facing text must use `AppLocalizations`; never hardcode user-facing text in Dart files. Add keys to every `/lib/l10n/app_*.arb` file, then regenerate generated code with `dart run build_runner build`.
