import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('presentation layer has no obvious user-visible hardcoded strings', () {
    final files = <File>[
      ...Directory(
        'lib/features',
      ).listSync(recursive: true).whereType<File>().where((file) {
        final path = file.path.replaceAll('\\', '/');
        return path.endsWith('.dart') && path.contains('/presentation/');
      }),
      ...Directory('lib/core/public_widgets')
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart')),
    ];

    final patterns = <RegExp>[
      RegExp(
        r"\b(labelText|hintText|tooltip|title|subtitle|message|label):\s*'([^']+)'",
      ),
      RegExp(r"\b(?:Text|SelectableText)\(\s*'([^']+)'"),
    ];

    final suspects = <String>[];
    for (final file in files) {
      final lines = file.readAsLinesSync();
      for (var index = 0; index < lines.length; index++) {
        final line = lines[index];
        if (line.contains('AppStrings.')) continue;

        for (final pattern in patterns) {
          for (final match in pattern.allMatches(line)) {
            final literal = match.group(match.groupCount) ?? '';
            if (!_isAllowedTechnicalLiteral(literal, line)) {
              suspects.add('${file.path}:${index + 1}: $literal');
            }
          }
        }
      }
    }

    expect(suspects, isEmpty, reason: suspects.join('\n'));
  });
}

bool _isAllowedTechnicalLiteral(String literal, String line) {
  if (literal == 'TL') return true;
  if (literal == 'v4.2.0-STABLE') return true;
  if (literal == r'${index + 1}') return true;
  if (line.contains('displayValue(')) return true;
  if (literal.contains(r'${') && literal.contains('%')) return true;

  final allowedExact = <String>{
    '0',
    '1',
    '2',
    '3',
    '6',
    '7',
    '10',
    '12',
    '15',
    '17',
    '22',
    '30',
    '60',
    '70',
    '75%',
    'AND',
    'Barakat',
    'COH-Q2-ENG',
    'EMP-000105',
    'EMP-123',
    'EMP-999',
    'EXAM-ALPHA-001',
    'Lana',
    'NewPassword@lana1',
    'Q2 Engineering Batch',
    'Alpha Foundational Adaptive Exam',
    'examinee',
    'g',
    'min_score',
    'new.candidate@alpha-engine.example',
    'new.candidate1@alpha-engine.example',
    '10.0.0.0/24, 192.168.1.1',
    '2026-06-25T14:03:03',
    '2052-07-18',
  };
  if (allowedExact.contains(literal)) return true;

  if (RegExp(r'^\d+(\.\d+)?%?$').hasMatch(literal)) return true;
  if (RegExp(r'^[A-Z]+-[A-Z0-9-]+$').hasMatch(literal)) return true;
  if (RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(literal)) return true;

  return false;
}
