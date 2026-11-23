/// Opinionated, configurable Flutter lint rules via custom_lint.
///
/// Add `kx_lints` to your `dev_dependencies` and enable the `custom_lint`
/// analyzer plugin to activate the rules.
library kx_lints;

import 'package:custom_lint_builder/custom_lint_builder.dart';

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

/// Entry point for the custom_lint plugin.
///
/// Returns the plugin instance that registers all kx_lints rules.
PluginBase createPlugin() => _KxLintsPlugin();

class _KxLintsPlugin extends PluginBase {
  /// Reads [k] from developer-supplied YAML [j] only when it is actually a [T].
  /// A wrong type (e.g. `argument_index: "1"`) yields null instead of throwing
  /// a TypeError out of [getLintRules] and taking down every rule.
  static T? _opt<T>(Map<String, Object?> j, String k) =>
      j[k] is T ? j[k] as T : null;

  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) {
    final fileLengthOpts = configs.rules['file_length'];
    final maxLines =
        fileLengthOpts == null ? null : _opt<int>(fileLengthOpts.json, 'max_lines');

    final materialWidgetsOpts = configs.rules['no_material_widgets'];
    final rawReplacements = materialWidgetsOpts?.json['replacements'];
    final replacements = rawReplacements is Map
        ? rawReplacements.map((key, value) => MapEntry('$key', '$value'))
        : null;

    final routeConstantsOpts = configs.rules['route_constants_only'];
    final routeJson = routeConstantsOpts?.json;
    final routeMethodName =
        routeJson == null ? null : _opt<String>(routeJson, 'method_name');
    final routeConstantsClass =
        routeJson == null ? null : _opt<String>(routeJson, 'constants_class');
    final routeArgumentIndex =
        routeJson == null ? null : _opt<int>(routeJson, 'argument_index');

    final barrelOpts = configs.rules['widgets_via_barrel_import'];
    final barrelJson = barrelOpts?.json;
    final barrelUri =
        barrelJson == null ? null : _opt<String>(barrelJson, 'barrel_uri');
    final widgetsPrefix =
        barrelJson == null ? null : _opt<String>(barrelJson, 'widgets_prefix');

    return [
      FileLength(maxLines: maxLines ?? 400),
      OneWidgetPerFile(),
      ScreenClassSuffix(),
      CallbackPresentTense(),
      NoThemeOf(),
      NoTextThemeAccess(),
      NoColorSchemeAccess(),
      NoMaterialColorsConstant(),
      NoRawAlphaInteger(),
      LateControllersNotFinal(),
      PreferGeometryTypes(),
      NoMagicNumbers(),
      NoHardcodedStrings(),
      CubitOnly(),
      NoCupertinoImport(),
      NoFPrefixOnProjectWidgets(),
      NoMaterialWidgets(replacements: replacements),
      RouteConstantsOnly(
        methodName: routeMethodName ?? 'navigateTo',
        constantsClass: routeConstantsClass ?? 'AppRoutes',
        argumentIndex: routeArgumentIndex ?? 1,
      ),
      WidgetsViaBarrelImport(
        barrelUri: barrelUri,
        widgetsPrefix: widgetsPrefix,
      ),
    ];
  }
}
