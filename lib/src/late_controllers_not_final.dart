import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class LateControllersNotFinal extends DartLintRule {
  const LateControllersNotFinal() : super(code: _code);

  static const _code = LintCode(
    name: 'late_controllers_not_final',
    problemMessage:
        "Use 'late' (not 'late final') for '{0}' so it can be "
        "reassigned in 'didUpdateWidget'.",
    correctionMessage: "Remove the 'final' keyword; keep 'late'.",
    errorSeverity: ErrorSeverity.WARNING,
  );

  static bool _isPrivateWithoutDidUpdateWidget(
    String fieldName,
    ClassDeclaration cls,
  ) {
    if (!fieldName.startsWith('_')) return false;
    return !cls.members.any(
      (m) => m is MethodDeclaration && m.name.lexeme == 'didUpdateWidget',
    );
  }

  static const _controllerTypes = {
    'AnimationController',
    'ScrollController',
    'FocusNode',
    'PageController',
    'TabController',
    'TextEditingController',
  };

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addFieldDeclaration((node) {
      if (!node.fields.isLate || !node.fields.isFinal) return;
      final enclosingClass = node.parent;
      if (enclosingClass is! ClassDeclaration) return;
      if (enclosingClass.extendsClause?.superclass.name2.lexeme != 'State') {
        return;
      }
      final typeName = node.fields.type?.toSource().trim();
      if (typeName == null || !_controllerTypes.contains(typeName)) return;
      for (final v in node.fields.variables) {
        if (_isPrivateWithoutDidUpdateWidget(v.name.lexeme, enclosingClass)) {
          return;
        }
        reporter.atToken(v.name, _code, arguments: [typeName]);
      }
    });
  }
}
