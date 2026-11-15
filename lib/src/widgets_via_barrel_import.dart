import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class WidgetsViaBarrelImport extends DartLintRule {
  WidgetsViaBarrelImport({this.barrelUri, String? widgetsPrefix})
      : widgetsPrefix = widgetsPrefix ?? _derivePrefix(barrelUri),
        super(code: _code);

  /// The barrel URI widgets must be imported through. When unset the rule is a
  /// complete no-op.
  final String? barrelUri;

  /// Prefix identifying individual widget files. Derived from [barrelUri]
  /// (everything up to and including the last path segment) when not supplied.
  final String? widgetsPrefix;

  static String? _derivePrefix(String? barrelUri) {
    if (barrelUri == null) return null;
    final lastSlash = barrelUri.lastIndexOf('/');
    if (lastSlash < 0) return null;
    return barrelUri.substring(0, lastSlash + 1);
  }

  static const _code = LintCode(
    name: 'widgets_via_barrel_import',
    problemMessage:
        "Import core widgets through the barrel '{0}', not individual files.",
    correctionMessage: "Replace with 'import {0};'.",
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    final barrel = barrelUri;
    final prefix = widgetsPrefix;
    // Treat an empty/blank barrel or prefix as unset: a `startsWith('')` would
    // otherwise match everything. Preserves the "no-op when not configured"
    // guarantee for an explicit `widgets_prefix: ''` or `barrel_uri: ''`.
    if (barrel == null ||
        barrel.trim().isEmpty ||
        prefix == null ||
        prefix.trim().isEmpty) {
      return;
    }

    context.registry.addImportDirective((node) {
      final uri = node.uri.stringValue ?? '';
      if (uri.startsWith(prefix) && uri != barrel) {
        // Files inside the widgets directory may use relative imports — skip.
        final source = resolver.source.uri.toString();
        if (source.startsWith(prefix)) return;
        reporter.atNode(node.uri, _code, arguments: [barrel]);
      }
    });
  }
}
