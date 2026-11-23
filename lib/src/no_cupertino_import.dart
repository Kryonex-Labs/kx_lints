import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class NoCupertinoImport extends DartLintRule {
  const NoCupertinoImport() : super(code: _code);

  static const _code = LintCode(
    name: 'no_cupertino_import',
    problemMessage:
        "Don't import 'package:flutter/cupertino.dart'; use forui components instead.",
    correctionMessage: "Remove this import and use the forui equivalents.",
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addImportDirective((node) {
      if (node.uri.stringValue == 'package:flutter/cupertino.dart') {
        reporter.atNode(node, _code);
      }
    });
  }
}
