import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

class NoHardcodedStrings extends AnalysisRule {
  NoHardcodedStrings()
    : super(
        name: 'no_hardcoded_strings',
        description: 'Avoid hardcoded user-visible strings.',
      );

  static const code = LintCode(
    'no_hardcoded_strings',
    'Avoid hardcoded user-visible strings. '
        'Use localized strings via AppLocalizations or equivalent.',
    correctionMessage: 'Replace with a localized string accessor.',
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  static const _uiParams = {
    'label',
    'hint',
    'hintText',
    'labelText',
    'title',
    'subtitle',
    'tooltip',
    'semanticsLabel',
    'errorText',
    'helperText',
    'prefixText',
    'suffixText',
    'message',
    'placeholder',
    'description',
    'counterText',
  };

  static const _excludedParams = {
    'key',
    'debugLabel',
    'restorationId',
    'heroTag',
    'routeName',
    'fontFamily',
    'package',
    'name',
  };

  static const _excludedPrefixes = [
    'assets/',
    'packages/',
    'images/',
    'icons/',
    'fonts/',
  ];

  static const _testDirSegments = [
    '/test/',
    '/integration_test/',
    '/patrol_test/',
  ];

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final path = context.definingUnit.file.path;
    for (final seg in _testDirSegments) {
      if (path.contains(seg)) return;
    }

    registry.addSimpleStringLiteral(this, _Visitor(this));
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule);

  final NoHardcodedStrings rule;

  @override
  void visitSimpleStringLiteral(SimpleStringLiteral node) {
    if (_isExcludedByContent(node.value)) return;
    if (!_isUserVisibleContext(node)) return;

    rule.reportAtNode(node);
  }

  bool _isExcludedByContent(String value) {
    if (value.trim().isEmpty) return true;
    for (final prefix in NoHardcodedStrings._excludedPrefixes) {
      if (value.startsWith(prefix)) return true;
    }
    return false;
  }

  bool _isUserVisibleContext(SimpleStringLiteral node) {
    final parent = node.parent;

    // Text('string') — positional argument to Text constructor
    if (parent is ArgumentList) {
      final grandparent = parent.parent;
      if (grandparent is InstanceCreationExpression) {
        final name = grandparent.constructorName.type.name.lexeme;
        if (name == 'Text') return true;
      }
    }

    // Named parameter check
    if (parent is NamedArgument) {
      final paramName = parent.name.lexeme;
      if (NoHardcodedStrings._excludedParams.contains(paramName)) return false;
      if (NoHardcodedStrings._uiParams.contains(paramName)) return true;
    }

    return false;
  }
}
