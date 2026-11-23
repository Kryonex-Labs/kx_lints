import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class NoFPrefixOnProjectWidgets extends DartLintRule {
  const NoFPrefixOnProjectWidgets() : super(code: _code);

  static const _code = LintCode(
    name: 'no_f_prefix_on_project_widgets',
    problemMessage:
        "The 'F' prefix is reserved for upstream forui components; rename '{0}' to plain PascalCase.",
    correctionMessage: "Remove the 'F' prefix from the class name.",
    errorSeverity: ErrorSeverity.WARNING,
  );

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
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addClassDeclaration((node) {
      final name = node.name.lexeme;
      if (!_fUpperPattern.hasMatch(name)) return;
      if (!_isWidgetClass(node)) return;
      reporter.atToken(node.name, _code, arguments: [name]);
    });
  }

  bool _isWidgetClass(ClassDeclaration cls) {
    final superclassName = cls.extendsClause?.superclass.name2.lexeme;
    return superclassName != null &&
        _widgetSuperclasses.contains(superclassName);
  }
}
