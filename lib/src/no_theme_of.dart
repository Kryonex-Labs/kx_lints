import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class NoThemeOf extends DartLintRule {
  const NoThemeOf() : super(code: _code);

  static const _code = LintCode(
    name: 'no_theme_of',
    problemMessage:
        "Don't use 'Theme.of(context)'; use 'context.theme' instead.",
    correctionMessage: "Replace with 'context.theme'.",
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addMethodInvocation((node) {
      if (node.methodName.name != 'of') return;
      final target = node.target;
      if (target is SimpleIdentifier && target.name == 'Theme') {
        reporter.atNode(node, _code);
      }
    });
  }
}
