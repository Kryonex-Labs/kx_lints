// ignore_for_file: unused_local_variable
// Fixture for no_hardcoded_strings: user-visible string literals are
// flagged; everything else is not.

class Text {
  Text(String data);
}

class Other {
  Other(String data);
}

void foo(String s) {}

void build2({String? label, String? debugLabel, String? color}) {}

void build() {
  final a = Text('hello'); // LINT: no_hardcoded_strings
  final b = Text(''); // not flagged: empty string excluded
  final c = Text('   '); // not flagged: whitespace-only excluded
  final d = Text('assets/img.png'); // not flagged: excluded asset-path prefix
  final e = Other('world'); // not flagged: not a Text constructor
  foo('plain call'); // not flagged: not an InstanceCreationExpression

  build2(label: 'Submit'); // LINT: no_hardcoded_strings
  build2(debugLabel: 'dbg'); // not flagged: excluded param
  build2(color: 'red'); // not flagged: neither excluded nor UI param

  final plain = 'just a string'; // not flagged: not an argument at all
}
