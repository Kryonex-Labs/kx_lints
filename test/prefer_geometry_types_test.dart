import 'package:kx_lints/src/prefer_geometry_types.dart';
import 'package:test/test.dart';

import 'test_helper.dart';

void main() {
  const rule = PreferGeometryTypes();

  group('prefer_geometry_types violations', () {
    test('flags concrete geometry types on widget fields and formal '
        'parameters', () async {
      final errors = await runLintOn(
        rule,
        fixture('prefer_geometry_types.dart'),
      );
      expect(errors, hasLength(2));
      expect(
        errors.map((e) => e.errorCode.name),
        everyElement('prefer_geometry_types'),
      );
    });
  });

  group('prefer_geometry_types non-violations', () {
    test('does not flag geometry types already in use', () async {
      final errors = await runLintOn(
        rule,
        fixture('prefer_geometry_types_clean.dart'),
      );
      expect(errors, isEmpty);
    });
  });
}
