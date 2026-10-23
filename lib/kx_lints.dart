import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'src/callback_present_tense.dart';
import 'src/file_length.dart';
import 'src/late_controllers_not_final.dart';
import 'src/no_color_scheme_access.dart';
import 'src/no_hardcoded_strings.dart';
import 'src/no_magic_numbers.dart';
import 'src/no_material_colors_constant.dart';
import 'src/no_raw_alpha_integer.dart';
import 'src/no_text_theme_access.dart';
import 'src/no_theme_of.dart';
import 'src/one_widget_per_file.dart';
import 'src/prefer_geometry_types.dart';
import 'src/screen_class_suffix.dart';

PluginBase createPlugin() => _KxLintsPlugin();

class _KxLintsPlugin extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
    FileLength(),
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
  ];
}
