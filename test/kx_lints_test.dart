import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:kx_lints/kx_lints.dart';
import 'package:kx_lints/src/no_material_widgets.dart';
import 'package:kx_lints/src/route_constants_only.dart';
import 'package:kx_lints/src/widgets_via_barrel_import.dart';
import 'package:test/test.dart';

void main() {
  test('createPlugin exposes all 19 lint rules', () {
    final plugin = createPlugin();
    // ignore: invalid_use_of_internal_member
    final rules = plugin.getLintRules(CustomLintConfigs.empty);

    expect(rules, hasLength(19));
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
      'cubit_only',
      'no_cupertino_import',
      'no_f_prefix_on_project_widgets',
      'no_material_widgets',
      'route_constants_only',
      'widgets_via_barrel_import',
    });
  });

  test('malformed per-rule config does not crash and falls back to defaults',
      () {
    // Every value here is the wrong type for the option it sits under. Hard
    // casts used to throw a TypeError out of getLintRules, taking down all 19
    // rules; the safe getters must ignore the bad values and use defaults.
    // ignore: invalid_use_of_internal_member
    final configs = CustomLintConfigs(
      enableAllLintRules: null,
      verbose: false,
      debug: false,
      rules: {
        // ignore: invalid_use_of_internal_member
        'file_length': LintOptions.fromYaml(
          const {'max_lines': 'big'},
          enabled: true,
        ),
        // ignore: invalid_use_of_internal_member
        'no_material_widgets': LintOptions.fromYaml(
          const {'replacements': ['a', 'b']},
          enabled: true,
        ),
        // ignore: invalid_use_of_internal_member
        'route_constants_only': LintOptions.fromYaml(
          const {
            'argument_index': '1',
            'method_name': 5,
            'constants_class': true,
          },
          enabled: true,
        ),
        // ignore: invalid_use_of_internal_member
        'widgets_via_barrel_import': LintOptions.fromYaml(
          const {'barrel_uri': 5, 'widgets_prefix': 9},
          enabled: true,
        ),
      },
    );

    late final List<LintRule> rules;
    expect(
      // ignore: invalid_use_of_internal_member
      () => rules = createPlugin().getLintRules(configs),
      returnsNormally,
    );
    expect(rules, hasLength(19));

    final route = rules.whereType<RouteConstantsOnly>().single;
    expect(route.argumentIndex, 1);
    expect(route.methodName, 'navigateTo');
    expect(route.constantsClass, 'AppRoutes');

    final barrel = rules.whereType<WidgetsViaBarrelImport>().single;
    expect(barrel.barrelUri, isNull);

    final material = rules.whereType<NoMaterialWidgets>().single;
    expect(material.replacements['Scaffold'], 'FScaffold');
  });
}
