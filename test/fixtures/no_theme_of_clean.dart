// ignore_for_file: unused_local_variable
// Fixture for no_theme_of: Theme.of(context) is absent.

class BuildContext {}

class MediaQuery {
  static MediaQuery of(BuildContext context) => MediaQuery();
}

void build(BuildContext context) {
  final media = MediaQuery.of(context);
}
