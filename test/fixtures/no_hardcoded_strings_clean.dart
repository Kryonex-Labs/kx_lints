// ignore_for_file: unused_local_variable
// Fixture for no_hardcoded_strings: no user-visible string literals present.

class Text {
  Text(String data);
}

void build(String localized) {
  final a = Text(localized); // not flagged: not a string literal
  final b = 'internal only'; // not flagged: plain variable
}
