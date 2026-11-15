import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class CubitOnly extends DartLintRule {
  const CubitOnly() : super(code: _code);

  static const _code = LintCode(
    name: 'cubit_only',
    problemMessage:
        "Don't extend 'Bloc<Event, State>'; use 'Cubit<State>' instead.",
    correctionMessage: "Replace 'extends Bloc<…>' with 'extends Cubit<…>'.",
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addClassDeclaration((node) {
      final superclassName = node.extendsClause?.superclass.name2.lexeme;
      if (superclassName == 'Bloc') {
        reporter.atToken(node.name, _code);
      }
    });
  }
}
