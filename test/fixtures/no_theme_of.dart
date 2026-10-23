// ignore_for_file: unused_local_variable
// Fixture for no_theme_of: Theme.of(context) is flagged.

class BuildContext {}

class Theme {
  static Theme of(BuildContext context) => Theme();
  static void other() {}
}

class MediaQuery {
  static MediaQuery of(BuildContext context) => MediaQuery();
}

void build(BuildContext context) {
  final theme = Theme.of(context); // LINT: no_theme_of
  final media = MediaQuery.of(context); // not flagged: different target
  Theme.other(); // not flagged: method name is not 'of'
}
