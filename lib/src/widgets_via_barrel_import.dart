import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

class WidgetsViaBarrelImport extends AnalysisRule {
  WidgetsViaBarrelImport({this.barrelUri, String? widgetsPrefix})
    : widgetsPrefix = widgetsPrefix ?? _derivePrefix(barrelUri),
      super(
        name: 'widgets_via_barrel_import',
        description:
            "Import core widgets through the barrel, not individual files.",
      );

  /// The barrel URI widgets must be imported through. When unset the rule is a
  /// complete no-op.
  final String? barrelUri;

  /// Prefix identifying individual widget files. Derived from [barrelUri]
  /// (everything up to and including the last path segment) when not supplied.
  final String? widgetsPrefix;

  static String? _derivePrefix(String? barrelUri) {
    if (barrelUri == null) return null;
    final lastSlash = barrelUri.lastIndexOf('/');
    if (lastSlash < 0) return null;
    return barrelUri.substring(0, lastSlash + 1);
  }

  static const LintCode code = LintCode(
    'widgets_via_barrel_import',
    "Import core widgets through the barrel '{0}', not individual files.",
    correctionMessage: "Replace with 'import {0};'.",
    severity: DiagnosticSeverity.WARNING,
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final barrel = barrelUri;
    final prefix = widgetsPrefix;
    // Treat an empty/blank barrel or prefix as unset: a `startsWith('')` would
    // otherwise match everything. Preserves the "no-op when not configured"
    // guarantee for an explicit `widgets_prefix: ''` or `barrel_uri: ''`.
    if (barrel == null ||
        barrel.trim().isEmpty ||
        prefix == null ||
        prefix.trim().isEmpty) {
      return;
    }

    registry.addImportDirective(this, _Visitor(this, barrel, prefix));
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;
  final String barrel;
  final String prefix;

  _Visitor(this.rule, this.barrel, this.prefix);

  @override
  void visitImportDirective(ImportDirective node) {
    final uri = node.uri.stringValue ?? '';
    if (uri.startsWith(prefix) && uri != barrel) {
      // Files inside the widgets directory may use relative imports — skip.
      final source =
          node.root is CompilationUnit
              ? (node.root as CompilationUnit).declaredFragment?.source.uri
                    .toString()
              : null;
      if (source != null && source.startsWith(prefix)) return;
      rule.reportAtNode(node.uri, arguments: [barrel]);
    }
  }
}
