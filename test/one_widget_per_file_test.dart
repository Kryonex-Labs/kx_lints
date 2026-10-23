import 'package:kx_lints/src/one_widget_per_file.dart';
import 'package:test/test.dart';

import 'test_helper.dart';

void main() {
  const rule = OneWidgetPerFile();

  group('one_widget_per_file violations', () {
    test('flags every widget class after the first', () async {
      final errors = await runLintOn(rule, fixture('one_widget_per_file.dart'));
      expect(errors, hasLength(1));
      expect(errors.single.errorCode.name, 'one_widget_per_file');
    });
  });

  group('one_widget_per_file non-violations', () {
    test('allows a single widget class per file', () async {
      final errors = await runLintOn(
        rule,
        fixture('one_widget_per_file_clean.dart'),
      );
      expect(errors, isEmpty);
    });
  });
}
