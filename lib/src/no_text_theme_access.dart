import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

class NoTextThemeAccess extends AnalysisRule {
  static const LintCode code = LintCode(
    'no_text_theme_access',
    "Don't access '.textTheme'; use 'context.theme.typography' instead.",
    correctionMessage:
        "Replace 'theme.textTheme.X' with 'context.theme.typography.X'.",
    severity: DiagnosticSeverity.WARNING,
  );

  NoTextThemeAccess()
      : super(
          name: 'no_text_theme_access',
          description: "Disallows '.textTheme'; use 'context.theme.typography'.",
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
  final AnalysisRule rule;

  _Visitor(this.rule);

  @override
  void visitPropertyAccess(PropertyAccess node) {
    if (node.propertyName.name == 'textTheme') {
      rule.reportAtNode(node.propertyName);
    }
  }

  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) {
    if (node.identifier.name == 'textTheme') {
      rule.reportAtNode(node.identifier);
    }
  }
}
