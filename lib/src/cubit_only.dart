import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

class CubitOnly extends AnalysisRule {
  static const LintCode code = LintCode(
    'cubit_only',
    "Don't extend 'Bloc<Event, State>'; use 'Cubit<State>' instead.",
    correctionMessage: "Replace 'extends Bloc<…>' with 'extends Cubit<…>'.",
    severity: DiagnosticSeverity.WARNING,
  );

  CubitOnly()
      : super(
          name: 'cubit_only',
          description: "Use 'Cubit<State>' instead of 'Bloc<Event, State>'.",
        );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    registry.addClassDeclaration(this, _Visitor(this));
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;

  _Visitor(this.rule);

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final superclassName = node.extendsClause?.superclass.name.lexeme;
    if (superclassName == 'Bloc') {
      rule.reportAtToken(node.namePart.typeName);
    }
  }
}
