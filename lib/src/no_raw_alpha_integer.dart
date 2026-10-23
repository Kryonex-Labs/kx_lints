import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class NoRawAlphaInteger extends DartLintRule {
  const NoRawAlphaInteger() : super(code: _code);

  static const _code = LintCode(
    name: 'no_raw_alpha_integer',
    problemMessage:
        'withValues(alpha:) expects a value in 0.0..1.0; '
        'this literal looks like an 8-bit integer.',
    correctionMessage: 'Divide by 255 (e.g. 160 → 0.63) or use withAlpha(int).',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addMethodInvocation((node) {
      if (node.methodName.name != 'withValues') return;
      for (final arg in node.argumentList.arguments) {
        if (arg is! NamedExpression) continue;
        if (arg.name.label.name != 'alpha') continue;
        final expr = arg.expression;
        double? value;
        if (expr is IntegerLiteral) {
          value = expr.value?.toDouble();
        } else if (expr is DoubleLiteral) {
          value = expr.value;
        }
        if (value != null && value > 1.0) {
          reporter.atNode(arg, _code);
        }
      }
    });
  }
}
