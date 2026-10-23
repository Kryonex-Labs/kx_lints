import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class ScreenClassSuffix extends DartLintRule {
  const ScreenClassSuffix() : super(code: _code);

  static const _code = LintCode(
    name: 'screen_class_suffix',
    problemMessage:
        "Screen classes must use the 'Screen' suffix, not 'Page' "
        "(e.g. 'HomeScreen' not 'HomePage').",
    correctionMessage: "Rename '{0}' to '{1}'.",
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
    context.registry.addClassDeclaration((node) {
      final name = node.name.lexeme;
      if (!name.endsWith('Page')) return;
      if (!_isWidgetClass(node)) return;
      final corrected = '${name.substring(0, name.length - 4)}Screen';
      reporter.atToken(node.name, _code, arguments: [name, corrected]);
    });
  }

  bool _isWidgetClass(ClassDeclaration cls) {
    final superclassName = cls.extendsClause?.superclass.name2.lexeme;
    return superclassName != null &&
        _widgetSuperclasses.contains(superclassName);
  }
}
