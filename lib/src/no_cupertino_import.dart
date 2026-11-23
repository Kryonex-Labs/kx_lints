import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

class NoCupertinoImport extends AnalysisRule {
  NoCupertinoImport()
    : super(
        name: 'no_cupertino_import',
        description:
            "Don't import 'package:flutter/cupertino.dart'; use forui components instead.",
      );

  static const LintCode code = LintCode(
    'no_cupertino_import',
    "Don't import 'package:flutter/cupertino.dart'; use forui components instead.",
    correctionMessage: "Remove this import and use the forui equivalents.",
    severity: DiagnosticSeverity.WARNING,
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    registry.addImportDirective(this, _Visitor(this));
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;

  _Visitor(this.rule);

  @override
  void visitImportDirective(ImportDirective node) {
    if (node.uri.stringValue == 'package:flutter/cupertino.dart') {
      rule.reportAtNode(node);
    }
  }
}
