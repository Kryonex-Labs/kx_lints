import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

class NoMagicNumbers extends AnalysisRule {
  NoMagicNumbers()
    : super(
        name: 'no_magic_numbers',
        description:
            'Avoid magic numbers in widget build methods. '
            'Extract to a named constant.',
      );

  static const code = LintCode(
    'no_magic_numbers',
    'Avoid magic numbers in widget build methods. '
        'Extract to a named constant.',
    correctionMessage: 'Define a constant for this value.',
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    registry.addMethodDeclaration(this, _Visitor(this));
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule);

  final AnalysisRule rule;

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
  void visitMethodDeclaration(MethodDeclaration node) {
    if (node.name.lexeme != 'build') return;

    final body = node.body;
    for (final literal in _numericLiterals(body)) {
      final value = literal.value;
      if (value == null) continue;
      if (value is int && _allowedInts.contains(value)) continue;
      if (value is double && _allowedDoubles.contains(value)) continue;
      if (!_isInSizingContext(literal)) continue;

      rule.reportAtNode(literal);
    }
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
      if (current is NamedArgument) {
        final name = current.name.lexeme;
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
