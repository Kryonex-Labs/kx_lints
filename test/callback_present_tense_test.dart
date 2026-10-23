import 'package:kx_lints/src/callback_present_tense.dart';
import 'package:test/test.dart';

import 'test_helper.dart';

void main() {
  const rule = CallbackPresentTense();

  group('callback_present_tense violations', () {
    test('flags past-tense callbacks declared as fields, simple formal '
        'parameters, and field formal parameters', () async {
      final errors = await runLintOn(
        rule,
        fixture('callback_present_tense.dart'),
      );
      // onPressed (field) + onPressed (field formal) + onChanged (simple
      // formal) + onClosed (field) + onClosed (field formal) = 5.
      expect(errors, hasLength(5));
      expect(
        errors.map((e) => e.errorCode.name),
        everyElement('callback_present_tense'),
      );
    });
  });

  group('callback_present_tense non-violations', () {
    test('does not flag present-tense callback names', () async {
      final errors = await runLintOn(
        rule,
        fixture('callback_present_tense_clean.dart'),
      );
      expect(errors, isEmpty);
    });
  });
}
