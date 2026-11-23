import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/error/error.dart';
// ignore: implementation_imports
import 'package:analyzer/src/lint/registry.dart';

final String _sdkPath = Directory(Platform.resolvedExecutable).parent.parent.path;

Future<List<AnalysisError>> runLintOn(AnalysisRule rule, File file) async {
  final name = rule.diagnosticCode.name;
  final registry = Registry.ruleRegistry;
  final existing = registry.lintRules[rule.name.toLowerCase()];
  if (existing != null) registry.unregisterLintRule(existing);
  registry.registerLintRule(rule);

  final dir = Directory.systemTemp.createTempSync('kx_lints_');
  try {
    final relativePath = _relativeFixturePath(file);
    final targetDir =
        relativePath != null ? Directory('${dir.path}/$relativePath') : dir;
    targetDir.createSync(recursive: true);
    File('${dir.path}/analysis_options.yaml')
        .writeAsStringSync('linter:\n  rules:\n    - ${rule.name}\n');
    final copy =
        File('${targetDir.path}/${file.uri.pathSegments.last}')
          ..writeAsStringSync(file.readAsStringSync());
    final path = copy.path;
    final collection = AnalysisContextCollection(
      includedPaths: [path],
      sdkPath: _sdkPath,
    );
    final result =
        await collection
            .contextFor(path)
            .currentSession
            .getResolvedUnit(path);
    if (result is! ResolvedUnitResult) {
      throw StateError('Failed to resolve $path: ${result.runtimeType}');
    }
    return result.errors.where((e) => e.errorCode.name == name).toList();
  } finally {
    dir.deleteSync(recursive: true);
  }
}

/// If [file] is under test/fixtures/, return the parent segments so the
/// temp copy preserves /test/ in its path (needed by rules that skip test dirs).
String? _relativeFixturePath(File file) {
  final segments = file.uri.pathSegments;
  final testIdx = segments.lastIndexOf('test');
  if (testIdx < 0) return null;
  return segments.sublist(testIdx, segments.length - 1).join('/');
}

File fixture(String name) {
  return File('test/fixtures/$name').absolute;
}
