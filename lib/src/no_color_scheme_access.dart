import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

class NoColorSchemeAccess extends AnalysisRule {
  static const LintCode code = LintCode(
    'no_color_scheme_access',
    "Don't access '.colorScheme'; use 'context.theme.colors' instead.",
    correctionMessage:
        "Replace 'theme.colorScheme.X' with 'context.theme.colors.X'.",
    severity: DiagnosticSeverity.WARNING,
  );

  NoColorSchemeAccess()
      : super(
          name: 'no_color_scheme_access',
          description: "Don't access '.colorScheme'; use 'context.theme.colors'.",
        );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this);
    registry.addPropertyAccess(this, visitor);
    registry.addPrefixedIdentifier(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule);

  final AnalysisRule rule;

  @override
  void visitPropertyAccess(PropertyAccess node) {
    if (node.propertyName.name == 'colorScheme') {
      rule.reportAtNode(node.propertyName);
    }
  }

  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) {
    if (node.identifier.name == 'colorScheme') {
      rule.reportAtNode(node.identifier);
    }
  }
}
