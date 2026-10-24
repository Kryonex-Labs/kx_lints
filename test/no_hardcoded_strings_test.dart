import 'dart:io';

import 'package:kx_lints/src/no_hardcoded_strings.dart';
import 'package:test/test.dart';

import 'test_helper.dart';

void main() {
  group('no_hardcoded_strings violations', () {
    test('flags Text(...) literals and UI-named string arguments', () async {
      final errors = await runLintOn(
        NoHardcodedStrings(),
        File('example/no_hardcoded_strings_fixture.dart').absolute,
      );
      expect(errors, hasLength(2));
      expect(
        errors.map((e) => e.errorCode.name),
        everyElement('no_hardcoded_strings'),
      );
    });
  });

  group('no_hardcoded_strings non-violations', () {
    test('does not flag non-literal or non-UI-context strings', () async {
      final errors = await runLintOn(
        NoHardcodedStrings(),
        fixture('no_hardcoded_strings_clean.dart'),
      );
      expect(errors, isEmpty);
    });

    test('skips files in test directories', () async {
      final errors = await runLintOn(
        NoHardcodedStrings(),
        fixture('no_hardcoded_strings.dart'),
      );
      expect(errors, isEmpty);
    });
  });
}
