// Fixture for no_raw_alpha_integer: alpha values outside 0.0..1.0 are
// flagged.

class Color {
  Color withValues({double? alpha}) => this;
  Color withAlpha(int a) => this;
}

void use(Color color) {
  color.withValues(alpha: 160); // LINT: no_raw_alpha_integer (int)
  color.withValues(alpha: 2.0); // LINT: no_raw_alpha_integer (double)
  color.withValues(alpha: 0.5); // not flagged: within range
  color.withAlpha(160); // not flagged: different method name
}
