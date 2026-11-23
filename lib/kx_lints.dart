/// Opinionated, configurable Flutter lint rules via analysis_server_plugin.
///
/// Add `kx_lints` to your `dependencies` and enable in `analysis_options.yaml`:
///
/// ```yaml
/// plugins:
///   kx_lints: ^0.2.0
/// ```
///
/// The plugin entry point is `lib/main.dart` (discovered automatically by
/// the analysis server). This library re-exports the plugin class for
/// programmatic access.
library kx_lints;

export 'main.dart' show KxLintsPlugin;
