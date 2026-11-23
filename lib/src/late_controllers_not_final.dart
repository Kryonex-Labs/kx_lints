import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

class LateControllersNotFinal extends AnalysisRule {
  LateControllersNotFinal()
    : super(
        name: 'late_controllers_not_final',
        description:
            "Controllers in State classes should use 'late', not 'late final'.",
      );

  static const LintCode code = LintCode(
    'late_controllers_not_final',
    "Use 'late' (not 'late final') for '{0}' so it can be "
        "reassigned in 'didUpdateWidget'.",
    correctionMessage: "Remove the 'final' keyword; keep 'late'.",
    severity: DiagnosticSeverity.WARNING,
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    registry.addFieldDeclaration(this, _Visitor(this));
  }
}

const _controllerTypes = {
  'AnimationController',
  'ScrollController',
  'FocusNode',
  'PageController',
  'TabController',
  'TextEditingController',
};

bool _isPrivateWithoutDidUpdateWidget(String fieldName, ClassDeclaration cls) {
  if (!fieldName.startsWith('_')) return false;
  return !(cls.body as BlockClassBody).members.any(
    (m) => m is MethodDeclaration && m.name.lexeme == 'didUpdateWidget',
  );
}

class _Visitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;

  _Visitor(this.rule);

  @override
  void visitFieldDeclaration(FieldDeclaration node) {
    if (!node.fields.isLate || !node.fields.isFinal) return;
    final enclosingClass = node.parent?.parent; // field -> BlockClassBody -> ClassDeclaration
    if (enclosingClass is! ClassDeclaration) return;
    if (enclosingClass.extendsClause?.superclass.name.lexeme != 'State') {
      return;
    }
    final typeName = node.fields.type?.toSource().trim();
    if (typeName == null || !_controllerTypes.contains(typeName)) return;
    for (final v in node.fields.variables) {
      if (_isPrivateWithoutDidUpdateWidget(v.name.lexeme, enclosingClass)) {
        return;
      }
      rule.reportAtToken(v.name, arguments: [typeName]);
    }
  }
}
