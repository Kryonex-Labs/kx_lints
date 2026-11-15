import 'package:kx_lints/src/route_constants_only.dart';
import 'package:test/test.dart';

import 'test_helper.dart';

void main() {
  group('route_constants_only violations', () {
    test('flags a string literal route argument', () async {
      final errors = await runLintOn(
        RouteConstantsOnly(),
        fixture('route_constants_only.dart'),
      );
      expect(errors, hasLength(1));
      expect(errors.single.errorCode.name, 'route_constants_only');
    });
  });

  group('route_constants_only non-violations', () {
    test('does not flag route constants', () async {
      final errors = await runLintOn(
        RouteConstantsOnly(),
        fixture('route_constants_only_clean.dart'),
      );
      expect(errors, isEmpty);
    });

    test('does not flag when the method name is not configured', () async {
      final errors = await runLintOn(
        RouteConstantsOnly(methodName: 'pushNamed'),
        fixture('route_constants_only.dart'),
      );
      expect(errors, isEmpty);
    });

    test('honors custom method_name, constants_class and argument_index',
        () async {
      final errors = await runLintOn(
        RouteConstantsOnly(
          methodName: 'pushRoute',
          constantsClass: 'Routes',
          argumentIndex: 0,
        ),
        fixture('route_constants_only_custom.dart'),
      );
      expect(errors, hasLength(1));
      expect(errors.single.errorCode.name, 'route_constants_only');
    });

    test('does not crash or flag when argument_index is out of range',
        () async {
      final errors = await runLintOn(
        RouteConstantsOnly(argumentIndex: 5),
        fixture('route_constants_only.dart'),
      );
      expect(errors, isEmpty);
    });

    test('does not crash or flag when argument_index is negative', () async {
      // A negative index from YAML must be guarded: args[-1] would throw a
      // RangeError inside the analyzer callback.
      final errors = await runLintOn(
        RouteConstantsOnly(argumentIndex: -1),
        fixture('route_constants_only.dart'),
      );
      expect(errors, isEmpty);
    });
  });
}
