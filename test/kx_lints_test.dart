import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:kx_lints/kx_lints.dart';
import 'package:test/test.dart';

void main() {
  test('createPlugin exposes all 13 lint rules', () {
    final plugin = createPlugin();
    // ignore: invalid_use_of_internal_member
    final rules = plugin.getLintRules(CustomLintConfigs.empty);

    expect(rules, hasLength(13));
    expect(rules.map((r) => r.code.name).toSet(), {
      'file_length',
      'one_widget_per_file',
      'screen_class_suffix',
      'callback_present_tense',
      'no_theme_of',
      'no_text_theme_access',
      'no_color_scheme_access',
      'no_material_colors_constant',
      'no_raw_alpha_integer',
      'late_controllers_not_final',
      'prefer_geometry_types',
      'no_magic_numbers',
      'no_hardcoded_strings',
    });
  });
}
