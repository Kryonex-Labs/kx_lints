## 0.2.0

- **BREAKING**: Migrate from `custom_lint_builder` to `analysis_server_plugin`.
  - Consumers now enable rules via `analysis_options.yaml` `plugins:` / `diagnostics:` instead of `custom_lint`.
  - Requires Dart SDK ≥ 3.14.0 and `analyzer ≥13.0.0 <15.0.0`.
- Drop `custom_lint_builder` dependency entirely.
- Rewrite all 19 lint rules to `AnalysisRule` + `RuleVisitorRegistry` visitor pattern.
- Rewrite test harness to use `AnalysisContextCollection` directly (no custom_lint test utils).
- Add `lib/main.dart` plugin entry point for `analysis_server_plugin` discovery.

## 0.1.0

- Add `cubit_only` rule: flag `extends Bloc<…>` and mandate `Cubit<…>`.
- Add `no_cupertino_import` rule: block `package:flutter/cupertino.dart`.
- Add `no_f_prefix_on_project_widgets` rule: reserve the `F` prefix for upstream forui widgets.
- Add `no_material_widgets` rule: flag Material widgets with forui-generic default replacements; configurable via `replacements` (project entries merge on top of defaults). Matching is scoped to the real `package:flutter/material` library (via element resolution), so a project's own same-named widget is not flagged; a configured empty replacement value opts that entry out (disabling a default).
- Add `route_constants_only` rule: flag string-literal navigation arguments; configurable via `method_name`, `constants_class`, and `argument_index` (out-of-range or negative indices are ignored).
- Add `widgets_via_barrel_import` rule: force widget imports through a barrel; configurable via required `barrel_uri` (no-op when unset or blank) and optional `widgets_prefix` (an empty/blank prefix is treated as unset).
- Parse per-rule config defensively: a wrong-typed option value (e.g. `argument_index: "1"`) falls back to the default instead of crashing the whole plugin.

## 0.0.3

- Wire `CustomLintConfigs` per-rule options to constructors; `file_length` now reads `max_lines` from config. ([#1](https://github.com/Kryonex-Labs/kx_lints/issues/1))
- Skip `no_hardcoded_strings` in `test/`, `integration_test/`, and `patrol_test/` directories. ([#2](https://github.com/Kryonex-Labs/kx_lints/issues/2))
- Skip `late_controllers_not_final` on private fields when the enclosing State does not override `didUpdateWidget`. ([#3](https://github.com/Kryonex-Labs/kx_lints/issues/3))

## 0.0.2

- Add dartdoc comments on public API for pub.dev documentation score.
- Add `example/example.dart` with setup instructions.
- Add repository, issue tracker, documentation, and topics metadata to pubspec.
- Improve package description.

## 0.0.1

- Initial release with 13 configurable lint rules via custom_lint.
