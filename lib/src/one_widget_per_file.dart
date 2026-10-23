import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class OneWidgetPerFile extends DartLintRule {
  const OneWidgetPerFile() : super(code: _code);

  static const _code = LintCode(
    name: 'one_widget_per_file',
    problemMessage: 'Only one widget class is allowed per file.',
    correctionMessage: 'Move this widget to its own file.',
    errorSeverity: ErrorSeverity.WARNING,
  );

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
    context.registry.addCompilationUnit((node) {
      final widgetClasses = <ClassDeclaration>[];
      for (final declaration in node.declarations) {
        if (declaration is ClassDeclaration &&
            _isWidgetClass(declaration) &&
            !_isStateSubclass(declaration)) {
          widgetClasses.add(declaration);
        }
      }
      for (final cls in widgetClasses.skip(1)) {
        reporter.atToken(cls.name, _code);
      }
    });
  }

  bool _isWidgetClass(ClassDeclaration cls) {
    final superclassName = cls.extendsClause?.superclass.name2.lexeme;
    return superclassName != null &&
        _widgetSuperclasses.contains(superclassName);
  }

  bool _isStateSubclass(ClassDeclaration cls) {
    final superclass = cls.extendsClause?.superclass;
    if (superclass == null) return false;
    return superclass.name2.lexeme == 'State';
  }
}
