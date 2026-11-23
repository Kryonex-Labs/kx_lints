import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

class FileLength extends AnalysisRule {
  FileLength({this.maxLines = _defaultMaxLines})
    : super(
        name: 'file_length',
        description: 'File exceeds the line limit. Split it into smaller files.',
      );

  static const _defaultMaxLines = 400;

  final int maxLines;

  static const LintCode code = LintCode(
    'file_length',
    'File exceeds the line limit. Split it into smaller files.',
    correctionMessage:
        'Extract widgets, helpers, or logic into separate files.',
    severity: DiagnosticSeverity.ERROR,
  );

  @override
  DiagnosticCode get diagnosticCode => code;

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

  final FileLength rule;

  @override
  void visitCompilationUnit(CompilationUnit node) {
    final lineCount = node.lineInfo.getLocation(node.end).lineNumber;
    if (lineCount > rule.maxLines) {
      rule.reportAtOffset(0, 0);
    }
  }
}
