import 'package:kx_lints/src/no_theme_of.dart';
import 'package:test/test.dart';

import 'test_helper.dart';

void main() {
  const rule = NoThemeOf();

  group('no_theme_of violations', () {
    test('flags Theme.of(context)', () async {
      final errors = await runLintOn(rule, fixture('no_theme_of.dart'));
      expect(errors, hasLength(1));
      expect(errors.single.errorCode.name, 'no_theme_of');
    });
  });

  group('no_theme_of non-violations', () {
    test('does not flag other .of(context) calls', () async {
      final errors = await runLintOn(rule, fixture('no_theme_of_clean.dart'));
      expect(errors, isEmpty);
    });
  });
}
