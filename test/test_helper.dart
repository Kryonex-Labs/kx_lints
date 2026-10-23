import 'dart:io';

import 'package:analyzer/error/error.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

Future<List<AnalysisError>> runLintOn(DartLintRule rule, File file) async {
  return rule.testAnalyzeAndRun(file);
}

File fixture(String name) {
  // resolveFile2 requires an absolute, normalized path.
  return File('test/fixtures/$name').absolute;
}
