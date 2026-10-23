import 'package:kx_lints/src/no_material_colors_constant.dart';
import 'package:test/test.dart';

import 'test_helper.dart';

void main() {
  const rule = NoMaterialColorsConstant();

  group('no_material_colors_constant violations', () {
    test('flags Colors.X', () async {
      final errors = await runLintOn(
        rule,
        fixture('no_material_colors_constant.dart'),
      );
      expect(errors, hasLength(1));
      expect(errors.single.errorCode.name, 'no_material_colors_constant');
    });
  });

  group('no_material_colors_constant non-violations', () {
    test('does not flag app-defined color tokens', () async {
      final errors = await runLintOn(
        rule,
        fixture('no_material_colors_constant_clean.dart'),
      );
      expect(errors, isEmpty);
    });
  });
}
