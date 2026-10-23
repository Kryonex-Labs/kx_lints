import 'package:kx_lints/src/no_color_scheme_access.dart';
import 'package:test/test.dart';

import 'test_helper.dart';

void main() {
  const rule = NoColorSchemeAccess();

  group('no_color_scheme_access violations', () {
    test(
      'flags .colorScheme via prefixed identifier and property access',
      () async {
        final errors = await runLintOn(
          rule,
          fixture('no_color_scheme_access.dart'),
        );
        expect(errors, hasLength(2));
        expect(
          errors.map((e) => e.errorCode.name),
          everyElement('no_color_scheme_access'),
        );
      },
    );
  });

  group('no_color_scheme_access non-violations', () {
    test('does not flag unrelated property access', () async {
      final errors = await runLintOn(
        rule,
        fixture('no_color_scheme_access_clean.dart'),
      );
      expect(errors, isEmpty);
    });
  });
}
