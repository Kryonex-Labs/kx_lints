import 'package:kx_lints/src/screen_class_suffix.dart';
import 'package:test/test.dart';

import 'test_helper.dart';

void main() {
  const rule = ScreenClassSuffix();

  group('screen_class_suffix violations', () {
    test('flags widget classes ending in Page', () async {
      final errors = await runLintOn(rule, fixture('screen_class_suffix.dart'));
      expect(errors, hasLength(1));
      expect(errors.single.errorCode.name, 'screen_class_suffix');
    });
  });

  group('screen_class_suffix non-violations', () {
    test('does not flag widget classes ending in Screen', () async {
      final errors = await runLintOn(
        rule,
        fixture('screen_class_suffix_clean.dart'),
      );
      expect(errors, isEmpty);
    });
  });
}
