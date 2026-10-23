import 'package:kx_lints/src/file_length.dart';
import 'package:test/test.dart';

import 'test_helper.dart';

void main() {
  group('file_length violations', () {
    test('flags a file exceeding maxLines', () async {
      final errors = await runLintOn(
        FileLength(maxLines: 10),
        fixture('file_length.dart'),
      );
      expect(errors, hasLength(1));
      expect(errors.single.errorCode.name, 'file_length');
    });
  });

  group('file_length non-violations', () {
    test('does not flag a file within maxLines', () async {
      final errors = await runLintOn(
        FileLength(maxLines: 10),
        fixture('file_length_clean.dart'),
      );
      expect(errors, isEmpty);
    });

    test('uses the default maxLines of 400 when unset', () async {
      final errors = await runLintOn(
        FileLength(),
        fixture('file_length_clean.dart'),
      );
      expect(errors, isEmpty);
    });
  });
}
