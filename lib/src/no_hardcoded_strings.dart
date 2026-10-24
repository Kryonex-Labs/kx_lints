import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class NoHardcodedStrings extends DartLintRule {
  NoHardcodedStrings() : super(code: _code);

  static const _code = LintCode(
    name: 'no_hardcoded_strings',
    problemMessage:
        'Avoid hardcoded user-visible strings. '
        'Use localized strings via AppLocalizations or equivalent.',
    correctionMessage: 'Replace with a localized string accessor.',
  );

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
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    final path = resolver.path;
    for (final seg in _testDirSegments) {
      if (path.contains(seg)) return;
    }

    context.registry.addSimpleStringLiteral((node) {
      if (_isExcludedByContent(node.value)) return;
      if (!_isUserVisibleContext(node)) return;

      reporter.atNode(node, _code);
    });
  }

  bool _isExcludedByContent(String value) {
    if (value.trim().isEmpty) return true;
    for (final prefix in _excludedPrefixes) {
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
        final name = grandparent.constructorName.type.name2.lexeme;
        if (name == 'Text') return true;
      }
    }

    // Named parameter check
    if (parent is NamedExpression) {
      final paramName = parent.name.label.name;
      if (_excludedParams.contains(paramName)) return false;
      if (_uiParams.contains(paramName)) return true;
    }

    return false;
  }
}
