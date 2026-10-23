import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class PreferGeometryTypes extends DartLintRule {
  const PreferGeometryTypes() : super(code: _code);

  static const _code = LintCode(
    name: 'prefer_geometry_types',
    problemMessage:
        "Use '{1}' instead of '{0}' on widget API surface "
        'to support RTL layouts.',
    correctionMessage:
        'Replace the concrete type with its abstract geometry counterpart.',
    errorSeverity: ErrorSeverity.WARNING,
  );

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
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addFieldDeclaration((node) {
      final enclosingClass = node.parent;
      if (enclosingClass is! ClassDeclaration) return;
      if (!_isWidgetClass(enclosingClass)) return;
      final typeAnnotation = node.fields.type;
      if (typeAnnotation == null) return;
      final typeName = typeAnnotation.toSource().trim();
      final geometry = _concreteToGeometry[typeName];
      if (geometry == null) return;
      reporter.atNode(typeAnnotation, _code, arguments: [typeName, geometry]);
    });

    context.registry.addSimpleFormalParameter((node) {
      final typeAnnotation = node.type;
      if (typeAnnotation == null) return;
      final typeName = typeAnnotation.toSource().trim();
      final geometry = _concreteToGeometry[typeName];
      if (geometry == null) return;
      final enclosingClass = _enclosingClass(node);
      if (enclosingClass == null || !_isWidgetClass(enclosingClass)) return;
      reporter.atNode(typeAnnotation, _code, arguments: [typeName, geometry]);
    });
  }

  bool _isWidgetClass(ClassDeclaration cls) {
    final superclassName = cls.extendsClause?.superclass.name2.lexeme;
    return superclassName != null &&
        _widgetSuperclasses.contains(superclassName);
  }

  ClassDeclaration? _enclosingClass(AstNode node) {
    AstNode? current = node.parent;
    while (current != null) {
      if (current is ClassDeclaration) return current;
      current = current.parent;
    }
    return null;
  }
}
