// ignore_for_file: unused_local_variable
// Fixture for no_color_scheme_access: .colorScheme access is flagged,
// whether reached via a prefixed identifier or a property access chain.

class Helper {
  dynamic nested;
}

void use(dynamic theme, Helper helper) {
  final a =
      theme.colorScheme; // LINT: no_color_scheme_access (PrefixedIdentifier)
  final b = helper
      .nested
      .colorScheme; // LINT: no_color_scheme_access (PropertyAccess)
}
