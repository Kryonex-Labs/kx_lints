import 'package:kx_lints/src/no_material_widgets.dart';
import 'package:test/test.dart';

import 'test_helper.dart';

void main() {
  group('no_material_widgets non-violations', () {
    test('does not flag a project\'s own same-named widget', () async {
      // `Scaffold` here is the project's own class, not Material's. Name-only
      // matching used to flag it; element scoping to package:flutter/material
      // means it (and the forui equivalent) are left alone.
      final errors = await runLintOn(
        NoMaterialWidgets(),
        fixture('no_material_widgets.dart'),
      );
      expect(errors, isEmpty);
    });

    test('does not flag forui equivalents', () async {
      final errors = await runLintOn(
        NoMaterialWidgets(),
        fixture('no_material_widgets_clean.dart'),
      );
      expect(errors, isEmpty);
    });
  });

  // Positive-flag behavior (a real `package:flutter/material` widget IS flagged,
  // and the replacement text appears in the message) requires `package:flutter`
  // to resolve. This package is pure-Dart and has no flutter dependency, so the
  // analyzer cannot resolve a flutter import in a fixture (the rule fails open).
  // The merge/opt-out logic that drives the message is covered below via the
  // public `replacements` map instead.
  group('no_material_widgets replacement config', () {
    test('keeps defaults and adds a custom key', () {
      final rule = NoMaterialWidgets(replacements: const {'FancyBox': 'FBox'});
      expect(rule.replacements['FancyBox'], 'FBox');
      expect(rule.replacements['Scaffold'], 'FScaffold'); // default preserved
    });

    test('a project override wins on key collision', () {
      final rule = NoMaterialWidgets(replacements: const {'Card': 'MyCard'});
      expect(rule.replacements['Card'], 'MyCard');
    });

    test('an empty replacement value disables that default', () {
      final rule = NoMaterialWidgets(replacements: const {'Card': ''});
      expect(rule.replacements.containsKey('Card'), isFalse);
      // other defaults remain
      expect(rule.replacements['Scaffold'], 'FScaffold');
    });

    test('the BottomNavigationBar suggestion is a generic bottom-nav widget', () {
      expect(
        NoMaterialWidgets().replacements['BottomNavigationBar'],
        'a custom bottom navigation widget',
      );
    });
  });
}
