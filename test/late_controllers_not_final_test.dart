import 'package:kx_lints/src/late_controllers_not_final.dart';
import 'package:test/test.dart';

import 'test_helper.dart';

void main() {
  const rule = LateControllersNotFinal();

  group('late_controllers_not_final violations', () {
    test('flags late final controllers in a State subclass', () async {
      final errors = await runLintOn(
        rule,
        fixture('late_controllers_not_final.dart'),
      );
      expect(errors, hasLength(1));
      expect(errors.single.errorCode.name, 'late_controllers_not_final');
    });
  });

  group('late_controllers_not_final non-violations', () {
    test('does not flag non-final, non-controller, or non-State '
        'declarations', () async {
      final errors = await runLintOn(
        rule,
        fixture('late_controllers_not_final_clean.dart'),
      );
      expect(errors, isEmpty);
    });
  });
}
