import 'package:kx_lints/src/cubit_only.dart';
import 'package:test/test.dart';

import 'test_helper.dart';

void main() {
  final rule = CubitOnly();

  group('cubit_only violations', () {
    test('flags a class extending Bloc', () async {
      final errors = await runLintOn(rule, fixture('cubit_only.dart'));
      expect(errors, hasLength(1));
      expect(errors.single.errorCode.name, 'cubit_only');
    });
  });

  group('cubit_only non-violations', () {
    test('does not flag Cubit subclasses', () async {
      final errors = await runLintOn(rule, fixture('cubit_only_clean.dart'));
      expect(errors, isEmpty);
    });
  });
}
