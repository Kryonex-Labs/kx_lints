import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

class RouteConstantsOnly extends AnalysisRule {
  RouteConstantsOnly({
    this.methodName = _defaultMethodName,
    this.constantsClass = _defaultConstantsClass,
    this.argumentIndex = _defaultArgumentIndex,
  }) : super(
          name: 'route_constants_only',
          description:
              'Use route constants instead of string literals for navigation.',
        );

  static const _defaultMethodName = 'navigateTo';
  static const _defaultConstantsClass = 'AppRoutes';
  static const _defaultArgumentIndex = 1;

  final String methodName;
  final String constantsClass;
  final int argumentIndex;

  static const LintCode code = LintCode(
    'route_constants_only',
    "Use a '{0}.*' constant instead of a string literal for navigation.",
    correctionMessage:
        "Replace the string literal with the matching '{0}.*' constant.",
    severity: DiagnosticSeverity.WARNING,
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    registry.addMethodInvocation(this, _Visitor(this));
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule);

  final RouteConstantsOnly rule;

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (node.methodName.name != rule.methodName) return;
    final args = node.argumentList.arguments;
    final i = rule.argumentIndex;
    if (i < 0 || i >= args.length) return;
    if (args[i] is StringLiteral) {
      rule.reportAtNode(args[i], arguments: [rule.constantsClass]);
    }
  }
}
