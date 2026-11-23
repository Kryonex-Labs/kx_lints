import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class NoMaterialWidgets extends DartLintRule {
  NoMaterialWidgets({Map<String, String>? replacements})
      : replacements = {..._defaultReplacements, ...?replacements}
          // An explicit empty replacement value is an opt-out: it disables that
          // entry (including a default) rather than suggesting 'use null/empty'.
          ..removeWhere((_, value) => value.isEmpty),
        super(code: _code);

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

  static const _code = LintCode(
    name: 'no_material_widgets',
    problemMessage: "Don't use the Material '{0}' widget; use '{1}' instead.",
    correctionMessage: "Replace with the forui or project equivalent.",
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      final typeName = node.constructorName.type.name2.lexeme;
      final replacement = replacements[typeName];
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

      reporter.atNode(
        node.constructorName,
        _code,
        arguments: [typeName, replacement],
      );
    });
  }
}
