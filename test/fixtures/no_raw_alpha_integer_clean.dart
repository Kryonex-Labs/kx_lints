// Fixture for no_raw_alpha_integer: a valid alpha fraction is not flagged.

class Color {
  Color withValues({double? alpha}) => this;
}

void use(Color color) {
  color.withValues(alpha: 0.5);
}
