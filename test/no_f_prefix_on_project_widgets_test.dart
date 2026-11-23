import 'package:kx_lints/src/no_f_prefix_on_project_widgets.dart';
import 'package:test/test.dart';

import 'test_helper.dart';

void main() {
  final rule =NoFPrefixOnProjectWidgets();

  group('no_f_prefix_on_project_widgets violations', () {
    test('flags an F-prefixed widget class', () async {
      final errors = await runLintOn(
        rule,
        fixture('no_f_prefix_on_project_widgets.dart'),
      );
      expect(errors, hasLength(1));
      expect(errors.single.errorCode.name, 'no_f_prefix_on_project_widgets');
    });
  });

  group('no_f_prefix_on_project_widgets non-violations', () {
    test('does not flag plain or non-widget classes', () async {
      final errors = await runLintOn(
        rule,
        fixture('no_f_prefix_on_project_widgets_clean.dart'),
      );
      expect(errors, isEmpty);
    });
  });
}
