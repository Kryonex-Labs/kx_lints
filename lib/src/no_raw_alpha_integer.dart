import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

class NoRawAlphaInteger extends AnalysisRule {
  NoRawAlphaInteger()
    : super(
        name: 'no_raw_alpha_integer',
        description:
            'withValues(alpha:) expects a value in 0.0..1.0; '
            'this literal looks like an 8-bit integer.',
      );

  static const LintCode code = LintCode(
    'no_raw_alpha_integer',
    'withValues(alpha:) expects a value in 0.0..1.0; '
        'this literal looks like an 8-bit integer.',
    correctionMessage: 'Divide by 255 (e.g. 160 → 0.63) or use withAlpha(int).',
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

  final AnalysisRule rule;

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (node.methodName.name != 'withValues') return;
    for (final arg in node.argumentList.arguments) {
      if (arg is! NamedArgument) continue;
      if (arg.name.lexeme != 'alpha') continue;
      final expr = arg.argumentExpression;
      double? value;
      if (expr is IntegerLiteral) {
        value = expr.value?.toDouble();
      } else if (expr is DoubleLiteral) {
        value = expr.value;
      }
      if (value != null && value > 1.0) {
        rule.reportAtNode(arg);
      }
    }
  }
}
