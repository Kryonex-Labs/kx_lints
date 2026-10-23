import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class NoMaterialColorsConstant extends DartLintRule {
  const NoMaterialColorsConstant() : super(code: _code);

  static const _code = LintCode(
    name: 'no_material_colors_constant',
    problemMessage:
        "Don't use the Material 'Colors' palette; "
        "use 'Color(0xFF…)' or a semantic color constant.",
    correctionMessage:
        "Replace 'Colors.X' with 'const Color(0xFF…)' or your app's color tokens.",
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addPrefixedIdentifier((node) {
      if (node.prefix.name == 'Colors') {
        reporter.atNode(node, _code);
      }
    });
  }
}
