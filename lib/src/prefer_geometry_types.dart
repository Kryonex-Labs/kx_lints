import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

class PreferGeometryTypes extends AnalysisRule {
  PreferGeometryTypes()
    : super(
        name: 'prefer_geometry_types',
        description:
            'Prefer abstract geometry types on widget API surface for RTL.',
      );

  static const LintCode code = LintCode(
    'prefer_geometry_types',
    "Use '{1}' instead of '{0}' on widget API surface "
        'to support RTL layouts.',
    correctionMessage:
        'Replace the concrete type with its abstract geometry counterpart.',
    severity: DiagnosticSeverity.WARNING,
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  static const _concreteToGeometry = <String, String>{
    'EdgeInsets': 'EdgeInsetsGeometry',
    'Alignment': 'AlignmentGeometry',
    'BorderRadius': 'BorderRadiusGeometry',
  };

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
    registry.addFieldDeclaration(this, _FieldVisitor(this));
    registry.addRegularFormalParameter(this, _ParamVisitor(this));
  }

  static bool _isWidgetClass(ClassDeclaration cls) {
    final superclassName = cls.extendsClause?.superclass.name.lexeme;
    return superclassName != null &&
        _widgetSuperclasses.contains(superclassName);
  }

  static ClassDeclaration? _enclosingClass(AstNode node) {
    AstNode? current = node.parent;
    while (current != null) {
      if (current is ClassDeclaration) return current;
      current = current.parent;
    }
    return null;
  }
}

class _FieldVisitor extends SimpleAstVisitor<void> {
  _FieldVisitor(this.rule);
  final AnalysisRule rule;

  @override
  void visitFieldDeclaration(FieldDeclaration node) {
    final enclosingClass = node.parent?.parent;
    if (enclosingClass is! ClassDeclaration) return;
    if (!PreferGeometryTypes._isWidgetClass(enclosingClass)) return;
    final typeAnnotation = node.fields.type;
    if (typeAnnotation == null) return;
    final typeName = typeAnnotation.toSource().trim();
    final geometry = PreferGeometryTypes._concreteToGeometry[typeName];
    if (geometry == null) return;
    rule.reportAtNode(typeAnnotation, arguments: [typeName, geometry]);
  }
}

class _ParamVisitor extends SimpleAstVisitor<void> {
  _ParamVisitor(this.rule);
  final AnalysisRule rule;

  @override
  void visitRegularFormalParameter(RegularFormalParameter node) {
    final typeAnnotation = node.type;
    if (typeAnnotation == null) return;
    final typeName = typeAnnotation.toSource().trim();
    final geometry = PreferGeometryTypes._concreteToGeometry[typeName];
    if (geometry == null) return;
    final enclosingClass = PreferGeometryTypes._enclosingClass(node);
    if (enclosingClass == null ||
        !PreferGeometryTypes._isWidgetClass(enclosingClass)) {
      return;
    }
    rule.reportAtNode(typeAnnotation, arguments: [typeName, geometry]);
  }
}
