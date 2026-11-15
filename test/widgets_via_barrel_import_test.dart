import 'package:kx_lints/src/widgets_via_barrel_import.dart';
import 'package:test/test.dart';

import 'test_helper.dart';

void main() {
  const barrelUri = 'package:myapp/core/widgets/index.dart';

  group('widgets_via_barrel_import violations', () {
    test('flags an individual widget file import', () async {
      final errors = await runLintOn(
        WidgetsViaBarrelImport(barrelUri: barrelUri),
        fixture('widgets_via_barrel_import.dart'),
      );
      expect(errors, hasLength(1));
      expect(errors.single.errorCode.name, 'widgets_via_barrel_import');
    });
  });

  group('widgets_via_barrel_import non-violations', () {
    test('does not flag the barrel import', () async {
      final errors = await runLintOn(
        WidgetsViaBarrelImport(barrelUri: barrelUri),
        fixture('widgets_via_barrel_import_clean.dart'),
      );
      expect(errors, isEmpty);
    });

    test('is a no-op when barrel_uri is unset', () async {
      final errors = await runLintOn(
        WidgetsViaBarrelImport(),
        fixture('widgets_via_barrel_import.dart'),
      );
      expect(errors, isEmpty);
    });

    test('is a no-op when widgets_prefix is an empty string', () async {
      // An explicit `widgets_prefix: ''` would make startsWith('') match every
      // import; it must be treated as unset instead.
      final errors = await runLintOn(
        WidgetsViaBarrelImport(barrelUri: barrelUri, widgetsPrefix: ''),
        fixture('widgets_via_barrel_import.dart'),
      );
      expect(errors, isEmpty);
    });

    test('is a no-op when barrel_uri is an empty string', () async {
      final errors = await runLintOn(
        WidgetsViaBarrelImport(barrelUri: ''),
        fixture('widgets_via_barrel_import.dart'),
      );
      expect(errors, isEmpty);
    });
  });
}
