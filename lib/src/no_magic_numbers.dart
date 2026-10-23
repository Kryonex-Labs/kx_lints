import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class NoMagicNumbers extends DartLintRule {
  NoMagicNumbers() : super(code: _code);

  static const _code = LintCode(
    name: 'no_magic_numbers',
    problemMessage:
        'Avoid magic numbers in widget build methods. '
        'Extract to a named constant.',
    correctionMessage: 'Define a constant for this value.',
  );

  static const _allowedInts = {0, 1, 2, -1};
  static final _allowedDoubles = {0.0, 1.0, 0.5};

  static const _sizingParams = {
    'padding',
    'margin',
    'width',
    'height',
    'size',
    'radius',
    'elevation',
    'spacing',
    'gap',
    'indent',
    'thickness',
    'extent',
    'top',
    'bottom',
    'left',
    'right',
    'horizontal',
    'vertical',
    'all',
    'symmetric',
    'only',
    'circular',
    'mainAxisSpacing',
    'crossAxisSpacing',
    'childAspectRatio',
    'maxWidth',
    'maxHeight',
    'minWidth',
    'minHeight',
  };

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addMethodDeclaration((node) {
      if (node.name.lexeme != 'build') return;

      final body = node.body;
      for (final literal in _numericLiterals(body)) {
        final value = literal.value;
        if (value == null) continue;
        if (value is int && _allowedInts.contains(value)) continue;
        if (value is double && _allowedDoubles.contains(value)) continue;
        if (!_isInSizingContext(literal)) continue;

        reporter.atNode(literal, _code);
      }
    });
  }

  Iterable<Literal> _numericLiterals(AstNode node) sync* {
    for (final child in node.childEntities) {
      if (child is IntegerLiteral || child is DoubleLiteral) {
        yield child as Literal;
      }
      if (child is AstNode) {
        yield* _numericLiterals(child);
      }
    }
  }

  bool _isInSizingContext(Literal node) {
    AstNode? current = node.parent;
    while (current != null) {
      if (current is NamedExpression) {
        final name = current.name.label.name;
        if (_sizingParams.contains(name)) return true;
        return false;
      }
      if (current is ArgumentList) return false;
      current = current.parent;
    }
    return false;
  }
}

extension on Literal {
  num? get value {
    final self = this;
    if (self is IntegerLiteral) return self.value;
    if (self is DoubleLiteral) return self.value;
    return null;
  }
}
