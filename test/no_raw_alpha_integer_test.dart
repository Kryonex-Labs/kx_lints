import 'package:kx_lints/src/no_raw_alpha_integer.dart';
import 'package:test/test.dart';

import 'test_helper.dart';

void main() {
  const rule = NoRawAlphaInteger();

  group('no_raw_alpha_integer violations', () {
    test('flags alpha values greater than 1.0', () async {
      final errors = await runLintOn(
        rule,
        fixture('no_raw_alpha_integer.dart'),
      );
      expect(errors, hasLength(2));
      expect(
        errors.map((e) => e.errorCode.name),
        everyElement('no_raw_alpha_integer'),
      );
    });
  });

  group('no_raw_alpha_integer non-violations', () {
    test('does not flag a valid alpha fraction', () async {
      final errors = await runLintOn(
        rule,
        fixture('no_raw_alpha_integer_clean.dart'),
      );
      expect(errors, isEmpty);
    });
  });
}
