import 'package:kx_lints/src/no_text_theme_access.dart';
import 'package:test/test.dart';

import 'test_helper.dart';

void main() {
  const rule = NoTextThemeAccess();

  group('no_text_theme_access violations', () {
    test(
      'flags .textTheme via prefixed identifier and property access',
      () async {
        final errors = await runLintOn(
          rule,
          fixture('no_text_theme_access.dart'),
        );
        expect(errors, hasLength(2));
        expect(
          errors.map((e) => e.errorCode.name),
          everyElement('no_text_theme_access'),
        );
      },
    );
  });

  group('no_text_theme_access non-violations', () {
    test('does not flag unrelated property access', () async {
      final errors = await runLintOn(
        rule,
        fixture('no_text_theme_access_clean.dart'),
      );
      expect(errors, isEmpty);
    });
  });
}
