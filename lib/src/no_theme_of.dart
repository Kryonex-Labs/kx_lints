import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

class NoThemeOf extends AnalysisRule {
  NoThemeOf()
      : super(
          name: 'no_theme_of',
          description: "Don't use 'Theme.of(context)'; use 'context.theme'.",
        );

  static const LintCode code = LintCode(
    'no_theme_of',
    "Don't use 'Theme.of(context)'; use 'context.theme' instead.",
    correctionMessage: "Replace with 'context.theme'.",
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
    if (node.methodName.name != 'of') return;
    final target = node.target;
    if (target is SimpleIdentifier && target.name == 'Theme') {
      rule.reportAtNode(node);
    }
  }
}
