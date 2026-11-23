import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

class OneWidgetPerFile extends AnalysisRule {
  OneWidgetPerFile()
      : super(
          name: 'one_widget_per_file',
          description: 'Only one widget class is allowed per file.',
        );

  static const LintCode code = LintCode(
    'one_widget_per_file',
    'Only one widget class is allowed per file.',
    correctionMessage: 'Move this widget to its own file.',
    severity: DiagnosticSeverity.WARNING,
  );

  @override
  DiagnosticCode get diagnosticCode => code;

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
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    registry.addCompilationUnit(this, _Visitor(this));
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule);

  final OneWidgetPerFile rule;

  @override
  void visitCompilationUnit(CompilationUnit node) {
    final widgetClasses = <ClassDeclaration>[];
    for (final declaration in node.declarations) {
      if (declaration is ClassDeclaration &&
          _isWidgetClass(declaration) &&
          !_isStateSubclass(declaration)) {
        widgetClasses.add(declaration);
      }
    }
    for (final cls in widgetClasses.skip(1)) {
      rule.reportAtToken(cls.namePart.typeName);
    }
  }

  bool _isWidgetClass(ClassDeclaration cls) {
    final superclassName = cls.extendsClause?.superclass.name.lexeme;
    return superclassName != null &&
        OneWidgetPerFile._widgetSuperclasses.contains(superclassName);
  }

  bool _isStateSubclass(ClassDeclaration cls) {
    final superclass = cls.extendsClause?.superclass;
    if (superclass == null) return false;
    return superclass.name.lexeme == 'State';
  }
}
