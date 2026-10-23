import 'package:kx_lints/src/no_magic_numbers.dart';
import 'package:test/test.dart';

import 'test_helper.dart';

void main() {
  group('no_magic_numbers violations', () {
    test(
      'flags magic numbers in sizing-context arguments inside build',
      () async {
        final errors = await runLintOn(
          NoMagicNumbers(),
          fixture('no_magic_numbers.dart'),
        );
        expect(errors, hasLength(2));
        expect(
          errors.map((e) => e.errorCode.name),
          everyElement('no_magic_numbers'),
        );
      },
    );
  });

  group('no_magic_numbers non-violations', () {
    test('does not flag allowed values or values outside build', () async {
      final errors = await runLintOn(
        NoMagicNumbers(),
        fixture('no_magic_numbers_clean.dart'),
      );
      expect(errors, isEmpty);
    });
  });
}
