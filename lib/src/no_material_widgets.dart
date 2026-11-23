import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

class NoMaterialWidgets extends AnalysisRule {
  NoMaterialWidgets({Map<String, String>? replacements})
      : replacements = {..._defaultReplacements, ...?replacements}
          // An explicit empty replacement value is an opt-out: it disables that
          // entry (including a default) rather than suggesting 'use null/empty'.
          ..removeWhere((_, value) => value.isEmpty),
        super(
          name: 'no_material_widgets',
          description: 'Use forui or project widgets instead of Material ones.',
        );

  /// Forui-generic defaults. Project config entries merge on top of these,
  /// with project overrides winning on key collisions.
  static const _defaultReplacements = <String, String>{
    'Scaffold': 'FScaffold',
    'AppBar': 'FHeader',
    'TextField': 'FTextField',
    'ListTile': 'FTile',
    'Card': 'FCard',
    'AlertDialog': 'FDialog',
    'SnackBar': 'FToast',
    'ElevatedButton': 'FButton',
    'TextButton': 'FButton',
    'MaterialButton': 'FButton',
    'Chip': 'FBadge',
    'FilterChip': 'FBadge',
    'BottomNavigationBar': 'a custom bottom navigation widget',
  };

  final Map<String, String> replacements;

  static const LintCode code = LintCode(
    'no_material_widgets',
    "Don't use the Material '{0}' widget; use '{1}' instead.",
    correctionMessage: "Replace with the forui or project equivalent.",
    severity: DiagnosticSeverity.WARNING,
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    registry.addInstanceCreationExpression(this, _Visitor(this));
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule);

  final NoMaterialWidgets rule;

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    final typeName = node.constructorName.type.name.lexeme;
    final replacement = rule.replacements[typeName];
    if (replacement == null) return;

    // Name-only matching would flag a project's own `Card`/`Chip`/etc. Only
    // flag when the constructor resolves to a Flutter material widget. If the
    // element can't be resolved, fail open (don't flag).
    final library = node.constructorName.type.element?.library;
    final uri = library?.uri.toString();
    if (uri == null) return;
    if (uri != 'package:flutter/material.dart' &&
        !uri.startsWith('package:flutter/src/material/')) {
      return;
    }

    rule.reportAtNode(
      node.constructorName,
      arguments: [typeName, replacement],
    );
  }
}
