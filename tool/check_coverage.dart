import 'dart:io';

const minimumCoverage = 66.0;

void main() {
  final report = File('coverage/lcov.info');
  if (!report.existsSync()) {
    stderr.writeln('Coverage report not found: ${report.path}');
    exitCode = 1;
    return;
  }

  var source = '';
  var coveredLines = 0;
  var executableLines = 0;

  for (final line in report.readAsLinesSync()) {
    if (line.startsWith('SF:')) {
      source = line.substring(3).replaceAll(r'\', '/');
      continue;
    }
    if (!line.startsWith('DA:') || !_isIncluded(source)) continue;

    final values = line.substring(3).split(',');
    if (values.length < 2) continue;
    executableLines++;
    if (int.parse(values[1]) > 0) coveredLines++;
  }

  if (executableLines == 0) {
    stderr.writeln('Coverage report contains no eligible Dart source lines.');
    exitCode = 1;
    return;
  }

  final coverage = coveredLines * 100 / executableLines;
  stdout.writeln(
    'Hand-written lib/ line coverage: ${coverage.toStringAsFixed(2)}% '
    '($coveredLines/$executableLines; minimum ${minimumCoverage.toStringAsFixed(1)}%)',
  );
  if (coverage < minimumCoverage) {
    stderr.writeln('Coverage is below the required minimum.');
    exitCode = 1;
  }
}

bool _isIncluded(String path) =>
    path.startsWith('lib/') &&
    !path.endsWith('.g.dart') &&
    !path.endsWith('.freezed.dart') &&
    !path.startsWith('lib/core/data/generated/');
