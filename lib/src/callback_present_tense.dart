import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class CallbackPresentTense extends DartLintRule {
  const CallbackPresentTense() : super(code: _code);

  static const _code = LintCode(
    name: 'callback_present_tense',
    problemMessage: "Rename callback '{0}' to present tense '{1}'.",
    correctionMessage:
        'Callbacks use present tense (onPress, onChange, onClose).',
    errorSeverity: ErrorSeverity.WARNING,
  );

  static const _pastToPresent = <String, String>{
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

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addFieldDeclaration((node) {
      for (final v in node.fields.variables) {
        final name = v.name.lexeme;
        final present = _pastToPresent[name];
        if (present != null) {
          reporter.atToken(v.name, _code, arguments: [name, present]);
        }
      }
    });
    context.registry.addSimpleFormalParameter((node) {
      final name = node.name?.lexeme;
      if (name == null) return;
      final present = _pastToPresent[name];
      if (present != null) {
        reporter.atToken(node.name!, _code, arguments: [name, present]);
      }
    });
    context.registry.addFieldFormalParameter((node) {
      final name = node.name.lexeme;
      final present = _pastToPresent[name];
      if (present != null) {
        reporter.atToken(node.name, _code, arguments: [name, present]);
      }
    });
  }
}
