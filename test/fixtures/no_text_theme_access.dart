// ignore_for_file: unused_local_variable
// Fixture for no_text_theme_access: .textTheme access is flagged, whether
// reached via a prefixed identifier or a property access chain.

class Helper {
  dynamic nested;
}

void use(dynamic theme, Helper helper) {
  final a = theme.textTheme; // LINT: no_text_theme_access (PrefixedIdentifier)
  final b =
      helper.nested.textTheme; // LINT: no_text_theme_access (PropertyAccess)
}
