import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class FileLength extends DartLintRule {
  FileLength({this.maxLines = _defaultMaxLines}) : super(code: _code);

  static const _defaultMaxLines = 400;

  final int maxLines;

  static const _code = LintCode(
    name: 'file_length',
    problemMessage: 'File exceeds the line limit. Split it into smaller files.',
    correctionMessage:
        'Extract widgets, helpers, or logic into separate files.',
    errorSeverity: ErrorSeverity.ERROR,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addCompilationUnit((node) {
      final lineCount = node.lineInfo.getLocation(node.end).lineNumber;
      if (lineCount > maxLines) {
        reporter.atOffset(offset: 0, length: 0, errorCode: _code);
      }
    });
  }
}
