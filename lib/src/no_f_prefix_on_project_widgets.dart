import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

class NoFPrefixOnProjectWidgets extends AnalysisRule {
  static const LintCode code = LintCode(
    'no_f_prefix_on_project_widgets',
    "The 'F' prefix is reserved for upstream forui components; rename '{0}' to plain PascalCase.",
    correctionMessage: "Remove the 'F' prefix from the class name.",
    severity: DiagnosticSeverity.WARNING,
  );

  NoFPrefixOnProjectWidgets()
    : super(
        name: 'no_f_prefix_on_project_widgets',
        description:
            "The 'F' prefix is reserved for upstream forui components.",
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
  _Visitor(this.rule);

  final AnalysisRule rule;

  static final _fUpperPattern = RegExp(r'^F[A-Z]');

  static const _widgetSuperclasses = {
    'Widget',
    'StatelessWidget',
    'StatefulWidget',
    'InheritedWidget',
    'RenderObjectWidget',
    'SingleChildRenderObjectWidget',
    'MultiChildRenderObjectWidget',
    'PreferredSizeWidget',
    'ProxyWidget',
  };

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final name = node.namePart.typeName.lexeme;
    if (!_fUpperPattern.hasMatch(name)) return;
    if (!_isWidgetClass(node)) return;
    rule.reportAtToken(node.namePart.typeName, arguments: [name]);
  }

  bool _isWidgetClass(ClassDeclaration cls) {
    final superclassName = cls.extendsClause?.superclass.name.lexeme;
    return superclassName != null &&
        _widgetSuperclasses.contains(superclassName);
  }
}
