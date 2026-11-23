import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

class ScreenClassSuffix extends AnalysisRule {
  ScreenClassSuffix()
    : super(
        name: 'screen_class_suffix',
        description: "Screen classes must use the 'Screen' suffix, not 'Page'.",
      );

  static const code = LintCode(
    'screen_class_suffix',
    "Screen classes must use the 'Screen' suffix, not 'Page' "
        "(e.g. 'HomeScreen' not 'HomePage').",
    correctionMessage: "Rename '{0}' to '{1}'.",
    severity: DiagnosticSeverity.WARNING,
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

  final ScreenClassSuffix rule;

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
    if (!name.endsWith('Page')) return;
    if (!_isWidgetClass(node)) return;
    final corrected = '${name.substring(0, name.length - 4)}Screen';
    rule.reportAtToken(node.namePart.typeName, arguments: [name, corrected]);
  }

  bool _isWidgetClass(ClassDeclaration cls) {
    final superclassName = cls.extendsClause?.superclass.name.lexeme;
    return superclassName != null &&
        _widgetSuperclasses.contains(superclassName);
  }
}
