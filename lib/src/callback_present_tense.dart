import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

class CallbackPresentTense extends AnalysisRule {
  static const LintCode code = LintCode(
    'callback_present_tense',
    "Rename callback '{0}' to present tense '{1}'.",
    correctionMessage:
        'Callbacks use present tense (onPress, onChange, onClose).',
    severity: DiagnosticSeverity.WARNING,
  );

  CallbackPresentTense()
      : super(
          name: 'callback_present_tense',
          description:
              'Callbacks use present tense (onPress, onChange, onClose).',
        );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this);
    registry.addFieldDeclaration(this, visitor);
    registry.addRegularFormalParameter(this, visitor);
    registry.addFieldFormalParameter(this, visitor);
  }
}

const _pastToPresent = <String, String>{
  'onPressed': 'onPress',
  'onChanged': 'onChange',
  'onClosed': 'onClose',
  'onTapped': 'onTap',
  'onSelected': 'onSelect',
  'onSubmitted': 'onSubmit',
  'onCompleted': 'onComplete',
  'onOpened': 'onOpen',
  'onDismissed': 'onDismiss',
};

class _Visitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;

  _Visitor(this.rule);

  @override
  void visitFieldDeclaration(FieldDeclaration node) {
    for (final v in node.fields.variables) {
      final name = v.name.lexeme;
      final present = _pastToPresent[name];
      if (present != null) {
        rule.reportAtToken(v.name, arguments: [name, present]);
      }
    }
  }

  @override
  void visitRegularFormalParameter(RegularFormalParameter node) {
    // Old SimpleFormalParameter excluded function-typed params.
    if (node.functionTypedSuffix != null) return;
    final name = node.name?.lexeme;
    if (name == null) return;
    final present = _pastToPresent[name];
    if (present != null) {
      rule.reportAtToken(node.name!, arguments: [name, present]);
    }
  }

  @override
  void visitFieldFormalParameter(FieldFormalParameter node) {
    final name = node.name.lexeme;
    final present = _pastToPresent[name];
    if (present != null) {
      rule.reportAtToken(node.name, arguments: [name, present]);
    }
  }
}
