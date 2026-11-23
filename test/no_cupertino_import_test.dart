import 'package:kx_lints/src/no_cupertino_import.dart';
import 'package:test/test.dart';

import 'test_helper.dart';

void main() {
  final rule = NoCupertinoImport();

  group('no_cupertino_import violations', () {
    test('flags importing package:flutter/cupertino.dart', () async {
      final errors = await runLintOn(
        rule,
        fixture('no_cupertino_import.dart'),
      );
      expect(errors, hasLength(1));
      expect(errors.single.errorCode.name, 'no_cupertino_import');
    });
  });

  group('no_cupertino_import non-violations', () {
    test('does not flag other flutter imports', () async {
      final errors = await runLintOn(
        rule,
        fixture('no_cupertino_import_clean.dart'),
      );
      expect(errors, isEmpty);
    });
  });
}
