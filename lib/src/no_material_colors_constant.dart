import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

class NoMaterialColorsConstant extends AnalysisRule {
  NoMaterialColorsConstant()
    : super(
        name: 'no_material_colors_constant',
        description:
            "Don't use the Material 'Colors' palette; "
            "use 'Color(0xFF…)' or a semantic color constant.",
      );

  static const LintCode code = LintCode(
    'no_material_colors_constant',
    "Don't use the Material 'Colors' palette; "
        "use 'Color(0xFF…)' or a semantic color constant.",
    correctionMessage:
        "Replace 'Colors.X' with 'const Color(0xFF…)' or your app's color tokens.",
    severity: DiagnosticSeverity.WARNING,
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    registry.addPrefixedIdentifier(this, _Visitor(this));
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule);

  final AnalysisRule rule;

  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) {
    if (node.prefix.name == 'Colors') {
      rule.reportAtNode(node);
    }
  }
}
