// ignore_for_file: unused_local_variable
// Fixture for no_material_colors_constant: app-defined color tokens are not
// flagged.

class AppColors {
  static const red = 0;
}

void use() {
  final b = AppColors.red;
}
