/// Entry point for the analysis_server_plugin discovery mechanism.
///
/// The analysis server discovers this plugin via the top-level `plugin`
/// variable. Consumer projects enable it in `analysis_options.yaml`:
///
/// ```yaml
/// plugins:
///   kx_lints: ^0.2.0
///   diagnostics:
///     file_length: true
///     # ... enable rules individually
/// ```
library;

import 'package:analysis_server_plugin/plugin.dart';
import 'package:analysis_server_plugin/registry.dart';

import 'src/callback_present_tense.dart';
import 'src/cubit_only.dart';
import 'src/file_length.dart';
import 'src/late_controllers_not_final.dart';
import 'src/no_color_scheme_access.dart';
import 'src/no_cupertino_import.dart';
import 'src/no_f_prefix_on_project_widgets.dart';
import 'src/no_hardcoded_strings.dart';
import 'src/no_magic_numbers.dart';
import 'src/no_material_colors_constant.dart';
import 'src/no_material_widgets.dart';
import 'src/no_raw_alpha_integer.dart';
import 'src/no_text_theme_access.dart';
import 'src/no_theme_of.dart';
import 'src/one_widget_per_file.dart';
import 'src/prefer_geometry_types.dart';
import 'src/route_constants_only.dart';
import 'src/screen_class_suffix.dart';
import 'src/widgets_via_barrel_import.dart';

/// Top-level variable required by analysis_server_plugin discovery.
final plugin = KxLintsPlugin();

class KxLintsPlugin extends Plugin {
  @override
  String get name => 'kx_lints';

  // ponytail: config reading deferred — analysis_server_plugin doesn't expose
  // analysis_options YAML to plugins the way custom_lint did. Rules that need
  // config (file_length, no_material_widgets, route_constants_only,
  // widgets_via_barrel_import) use defaults for now. Config mechanism TBD once
  // rules are migrated and we can test the diagnostics: map or a custom
  // analysis_options reader.

  @override
  void register(PluginRegistry registry) {
    // All registered as lint rules (must be enabled in analysis_options.yaml
    // under `diagnostics:`).
    registry.registerLintRule(FileLength());
    registry.registerLintRule(OneWidgetPerFile());
    registry.registerLintRule(ScreenClassSuffix());
    registry.registerLintRule(CallbackPresentTense());
    registry.registerLintRule(NoThemeOf());
    registry.registerLintRule(NoTextThemeAccess());
    registry.registerLintRule(NoColorSchemeAccess());
    registry.registerLintRule(NoMaterialColorsConstant());
    registry.registerLintRule(NoRawAlphaInteger());
    registry.registerLintRule(LateControllersNotFinal());
    registry.registerLintRule(PreferGeometryTypes());
    registry.registerLintRule(NoMagicNumbers());
    registry.registerLintRule(NoHardcodedStrings());
    registry.registerLintRule(CubitOnly());
    registry.registerLintRule(NoCupertinoImport());
    registry.registerLintRule(NoFPrefixOnProjectWidgets());
    registry.registerLintRule(NoMaterialWidgets());
    registry.registerLintRule(RouteConstantsOnly());
    registry.registerLintRule(WidgetsViaBarrelImport());
  }
}
