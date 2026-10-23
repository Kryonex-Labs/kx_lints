// ignore_for_file: unused_local_variable
// Fixture for no_material_colors_constant: Colors.X is flagged.

class Colors {
  static const red = 0;
}

class AppColors {
  static const red = 0;
}

void use() {
  final a = Colors.red; // LINT: no_material_colors_constant
  final b = AppColors.red; // not flagged: not the Material Colors palette
}
