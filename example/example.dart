// ignore_for_file: unused_element, unused_local_variable

// kx_lints — what gets caught and how to fix it.
//
// This package is a custom_lint plugin. It analyses your Flutter project
// at edit-time — no code in this file runs. The pairs below show the
// BAD pattern each rule flags and the GOOD replacement.
//
// ── Setup ───────────────────────────────────────────────────────────
//
//   # pubspec.yaml
//   dev_dependencies:
//     custom_lint: ^0.8.0
//     kx_lints: ^0.0.2
//
//   # analysis_options.yaml
//   analyzer:
//     plugins:
//       - custom_lint
//
// All 13 rules activate automatically. Disable or configure per-rule:
//
//   custom_lint:
//     rules:
//       - file_length: false
//       - no_magic_numbers:
//           allowed_values: [0, 1, 2, -1]
//
// ── screen_class_suffix ─────────────────────────────────────────────
//
//   // BAD — "Page" suffix inconsistent with project convention:
//   class HomePage extends StatelessWidget { ... }
//
//   // GOOD — use "Screen":
//   class HomeScreen extends StatelessWidget { ... }
//
// ── no_theme_of ─────────────────────────────────────────────────────
//
//   // BAD:
//   final theme = Theme.of(context);
//
//   // GOOD — extension method, shorter and cacheable:
//   final theme = context.theme;
//
// ── no_raw_alpha_integer ────────────────────────────────────────────
//
//   // BAD — looks like 63% opacity, actually clamps to 1.0:
//   color.withValues(alpha: 160);
//
//   // GOOD — normalised double:
//   color.withValues(alpha: 0.63);
//
// ── late_controllers_not_final ──────────────────────────────────────
//
//   // BAD — blocks reassignment in didUpdateWidget:
//   late final TextEditingController _controller;
//
//   // GOOD:
//   late TextEditingController _controller;
//
// ── no_magic_numbers ────────────────────────────────────────────────
//
//   // BAD — raw literals in build methods:
//   Padding(padding: EdgeInsets.all(16));
//
//   // GOOD — named constant:
//   static const kPadding = 16.0;
//   Padding(padding: EdgeInsets.all(kPadding));
//
// ── prefer_geometry_types ───────────────────────────────────────────
//
//   // BAD — concrete type breaks RTL (EdgeInsetsDirectional):
//   class MyCard extends StatelessWidget {
//     final EdgeInsets padding;
//   }
//
//   // GOOD — abstract supertype:
//   class MyCard extends StatelessWidget {
//     final EdgeInsetsGeometry padding;
//   }

/// Entry point — import to confirm the package resolves.
///
/// kx_lints is a build-time plugin; there is no runtime API to call.
/// See the comments above for rule examples.
void example() {}
