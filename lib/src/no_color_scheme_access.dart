import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class NoColorSchemeAccess extends DartLintRule {
  const NoColorSchemeAccess() : super(code: _code);

  static const _code = LintCode(
    name: 'no_color_scheme_access',
    problemMessage:
        "Don't access '.colorScheme'; use 'context.theme.colors' instead.",
    correctionMessage:
        "Replace 'theme.colorScheme.X' with 'context.theme.colors.X'.",
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addPropertyAccess((node) {
      if (node.propertyName.name == 'colorScheme') {
        reporter.atNode(node.propertyName, _code);
      }
    });
    context.registry.addPrefixedIdentifier((node) {
      if (node.identifier.name == 'colorScheme') {
        reporter.atNode(node.identifier, _code);
      }
    });
  }
}
