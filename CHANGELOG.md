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
