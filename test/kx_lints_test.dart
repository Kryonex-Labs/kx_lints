import 'package:analysis_server_plugin/registry.dart';
import 'package:kx_lints/main.dart';
import 'package:test/test.dart';

class _CapturingRegistry implements PluginRegistry {
  final names = <String>[];

  @override
  void registerLintRule(rule) => names.add(rule.name);

  @override
  void registerWarningRule(rule) => names.add(rule.name);

  @override
  dynamic noSuchMethod(Invocation invocation) {}
}

void main() {
  test('plugin exposes all 19 lint rules', () {
    final registry = _CapturingRegistry();
    plugin.register(registry);

    expect(plugin.name, 'kx_lints');
    expect(registry.names, hasLength(19));
    expect(registry.names.toSet(), {
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

  // ponytail: malformed-config test dropped; plugin has no config channel yet
  // (see lib/main.dart). Restore when rule migration adds one.
}
