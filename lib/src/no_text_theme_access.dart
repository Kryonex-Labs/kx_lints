import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class NoTextThemeAccess extends DartLintRule {
  const NoTextThemeAccess() : super(code: _code);

  static const _code = LintCode(
    name: 'no_text_theme_access',
    problemMessage:
        "Don't access '.textTheme'; use 'context.theme.typography' instead.",
    correctionMessage:
        "Replace 'theme.textTheme.X' with 'context.theme.typography.X'.",
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addPropertyAccess((node) {
      if (node.propertyName.name == 'textTheme') {
        reporter.atNode(node.propertyName, _code);
      }
    });
    context.registry.addPrefixedIdentifier((node) {
      if (node.identifier.name == 'textTheme') {
        reporter.atNode(node.identifier, _code);
      }
    });
  }
}
