// Fixture for no_magic_numbers: values outside a build method, or allowed
// values inside one, are not flagged.

class MagicWidget {
  dynamic pad({dynamic padding}) => null;

  void build() {
    pad(padding: 0);
  }

  void notBuild() {
    pad(padding: 16); // not flagged: outside the build method
  }
}
