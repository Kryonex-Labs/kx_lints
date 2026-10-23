# kx_lints

Opinionated, configurable Flutter lint rules that catch real bugs — not style bikeshedding.

[![Pub Version](https://img.shields.io/pub/v/kx_lints)](https://pub.dev/packages/kx_lints)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

---

## Install

```yaml
# pubspec.yaml
dev_dependencies:
  custom_lint: ^0.8.0
  kx_lints: ^0.0.1
```

```yaml
# analysis_options.yaml
analyzer:
  plugins:
    - custom_lint
```

## Rules

| Rule | Severity | Fix | Description |
|------|----------|-----|-------------|
| `file_length` | ERROR | — | File exceeds line limit (default 400) |
| `one_widget_per_file` | warn | — | Only one widget class per file |
| `screen_class_suffix` | warn | ✓ | Screen classes use `Screen` suffix, not `Page` |
| `callback_present_tense` | warn | — | Callbacks use present tense (`onPress`, not `onPressed`) |
| `no_theme_of` | warn | ✓ | Use `context.theme` instead of `Theme.of(context)` |
| `no_text_theme_access` | warn | ✓ | Use `context.theme.typography` instead of `.textTheme` |
| `no_color_scheme_access` | warn | ✓ | Use `context.theme.colors` instead of `.colorScheme` |
| `no_material_colors_constant` | warn | — | No `Colors.red` — use semantic color tokens |
| `no_raw_alpha_integer` | warn | ✓ | `withValues(alpha:)` expects 0.0–1.0, not 0–255 |
| `late_controllers_not_final` | warn | ✓ | Controllers in State: `late`, not `late final` |
| `prefer_geometry_types` | warn | ✓ | Widget APIs use `EdgeInsetsGeometry` over `EdgeInsets` |
| `no_magic_numbers` | warn | ✓ | No raw numbers in widget sizing params |
| `no_hardcoded_strings` | warn | — | No hardcoded user-visible strings |

## Configuration

Disable a rule or tune thresholds in `analysis_options.yaml`:

```yaml
custom_lint:
  rules:
    - file_length: false          # disable entirely
    - callback_present_tense: false
    - no_magic_numbers:
        allowed_values: [0, 1, 2, -1]
```

## Rule Details

<details>
<summary><code>file_length</code> — file exceeds line limit</summary>

Files over 400 lines are hard to navigate and review. Split into smaller, focused files.

```dart
// ✗ BAD — 500-line file
class MegaWidget extends StatelessWidget { /* ... 500 lines ... */ }

// ✓ GOOD — split into focused files
// mega_widget.dart
// mega_widget_header.dart
// mega_widget_body.dart
```

Configurable: `max_lines` (default `400`).

</details>

<details>
<summary><code>one_widget_per_file</code> — one widget class per file</summary>

Multiple widgets in one file make them hard to find and test independently.

```dart
// ✗ BAD
class ProfileHeader extends StatelessWidget { ... }
class ProfileBody extends StatelessWidget { ... }   // ← flagged

// ✓ GOOD — each widget in its own file
```

`State` subclasses are excluded — they belong with their `StatefulWidget`.

</details>

<details>
<summary><code>screen_class_suffix</code> — use Screen, not Page</summary>

Consistent naming across the codebase.

```dart
// ✗ BAD
class HomePage extends StatelessWidget { ... }

// ✓ GOOD
class HomeScreen extends StatelessWidget { ... }
```

</details>

<details>
<summary><code>callback_present_tense</code> — callbacks use present tense</summary>

Flutter SDK uses past tense (`onPressed`), but present tense is shorter and reads as intent, not event.

```dart
// ✗ BAD
final VoidCallback? onPressed;
final ValueChanged<String>? onChanged;

// ✓ GOOD
final VoidCallback? onPress;
final ValueChanged<String>? onChange;
```

</details>

<details>
<summary><code>no_theme_of</code> — use context.theme</summary>

Extension method is shorter, cacheable, and reads better.

```dart
// ✗ BAD
final theme = Theme.of(context);

// ✓ GOOD
final theme = context.theme;
```

</details>

<details>
<summary><code>no_text_theme_access</code> — use context.theme.typography</summary>

```dart
// ✗ BAD
Theme.of(context).textTheme.headlineLarge

// ✓ GOOD
context.theme.typography.headlineLarge
```

</details>

<details>
<summary><code>no_color_scheme_access</code> — use context.theme.colors</summary>

```dart
// ✗ BAD
Theme.of(context).colorScheme.primary

// ✓ GOOD
context.theme.colors.primary
```

</details>

<details>
<summary><code>no_material_colors_constant</code> — no Material color palette</summary>

Material palette colors don't adapt to themes. Use semantic tokens or explicit hex values.

```dart
// ✗ BAD
color: Colors.red

// ✓ GOOD
color: context.theme.colors.error
color: const Color(0xFFE53935)
```

</details>

<details>
<summary><code>no_raw_alpha_integer</code> — alpha expects 0.0–1.0</summary>

`Color.withValues(alpha:)` takes a normalized double. Passing an 8-bit int (e.g. `160`) is a silent bug — it clamps to `1.0`.

```dart
// ✗ BAD — looks like 63% opacity, actually 100%
color.withValues(alpha: 160)

// ✓ GOOD
color.withValues(alpha: 0.63)
```

</details>

<details>
<summary><code>late_controllers_not_final</code> — controllers should be reassignable</summary>

Controllers in `State` subclasses may need reassignment in `didUpdateWidget`. `late final` prevents that.

```dart
// ✗ BAD
late final TextEditingController _controller;

// ✓ GOOD
late TextEditingController _controller;
```

</details>

<details>
<summary><code>prefer_geometry_types</code> — use abstract geometry types on widget APIs</summary>

Concrete types like `EdgeInsets` break RTL support. Use their `Geometry` supertypes on public APIs.

```dart
// ✗ BAD
class MyWidget extends StatelessWidget {
  final EdgeInsets padding;      // ← won't accept EdgeInsetsDirectional
}

// ✓ GOOD
class MyWidget extends StatelessWidget {
  final EdgeInsetsGeometry padding;
}
```

</details>

<details>
<summary><code>no_magic_numbers</code> — extract sizing constants</summary>

Raw numbers in widget build methods obscure intent and make global changes impossible.

```dart
// ✗ BAD
padding: EdgeInsets.all(16),
SizedBox(height: 24),

// ✓ GOOD
padding: EdgeInsets.all(Spacing.md),
SizedBox(height: Spacing.lg),
```

Scoped to `build` methods and sizing-related named parameters only. Values `0`, `1`, `2`, `-1`, `0.0`, `1.0`, `0.5` are allowed.

</details>

<details>
<summary><code>no_hardcoded_strings</code> — use localized strings</summary>

Hardcoded user-visible strings can't be translated and are scattered across the codebase.

```dart
// ✗ BAD
Text('Welcome back')
TextField(decoration: InputDecoration(hintText: 'Enter email'))

// ✓ GOOD
Text(context.l10n.welcomeBack)
TextField(decoration: InputDecoration(hintText: context.l10n.emailHint))
```

Flagged params: `Text()` positional args, `label`, `hint`, `hintText`, `labelText`, `title`, `subtitle`, `tooltip`, `semanticsLabel`, `errorText`, `helperText`, `prefixText`, `suffixText`, `message`, `placeholder`, `description`, `counterText`.

Excluded: `key`, `debugLabel`, `restorationId`, `heroTag`, `routeName`, `fontFamily`, `package`, `name`, asset paths.

</details>

## License

MIT
