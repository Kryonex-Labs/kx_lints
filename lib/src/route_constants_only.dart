import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class RouteConstantsOnly extends DartLintRule {
  RouteConstantsOnly({
    this.methodName = _defaultMethodName,
    this.constantsClass = _defaultConstantsClass,
    this.argumentIndex = _defaultArgumentIndex,
  }) : super(code: _code);

  static const _defaultMethodName = 'navigateTo';
  static const _defaultConstantsClass = 'AppRoutes';
  static const _defaultArgumentIndex = 1;

  final String methodName;
  final String constantsClass;
  final int argumentIndex;

  static const _code = LintCode(
    name: 'route_constants_only',
    problemMessage:
        "Use a '{0}.*' constant instead of a string literal for navigation.",
    correctionMessage:
        "Replace the string literal with the matching '{0}.*' constant.",
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addMethodInvocation((node) {
      if (node.methodName.name != methodName) return;
      final args = node.argumentList.arguments;
      if (argumentIndex < 0 || argumentIndex >= args.length) return;
      if (args[argumentIndex] is StringLiteral) {
        reporter.atNode(
          args[argumentIndex],
          _code,
          arguments: [constantsClass],
        );
      }
    });
  }
}
