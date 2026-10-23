// ignore_for_file: unused_local_variable
// Fixture for no_magic_numbers: magic numbers in sizing-context named
// arguments inside a build method are flagged.

class MagicWidget {
  dynamic pad({dynamic padding, dynamic height, dynamic width}) => null;
  void foo(dynamic x) {}
  void bar({dynamic key}) {}

  void build() {
    final count = 42; // not flagged: no named/positional call context
    foo(42); // not flagged: positional argument, not a named parameter
    bar(key: 5); // not flagged: named param 'key' is not a sizing param
    pad(padding: 16); // LINT: no_magic_numbers
    pad(padding: 0); // not flagged: 0 is an allowed int
    pad(height: 24.0); // LINT: no_magic_numbers
    pad(height: 0.5); // not flagged: 0.5 is an allowed double
    pad(width: 2); // not flagged: 2 is an allowed int
  }
}
