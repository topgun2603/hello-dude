import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Requests that answer "204 No Content" come back as `Future<String?>` from the
/// generated client and must go through `api.send`, not `api.call` — `call`
/// treats the empty reply as an error ("Something went wrong").
void main() {
  test('no-content requests use api.send', () {
    final ops = <String>{};
    for (final f in Directory(
      '../../packages/pesu_api/lib/api',
    ).listSync().whereType<File>()) {
      for (final m in RegExp(
        r'Future<String\?> (\w+)\(',
      ).allMatches(f.readAsStringSync())) {
        ops.add(m.group(1)!);
      }
    }
    expect(ops, contains('addFavourite'));

    final wrong = RegExp(
      r'\.call\(\s*\(\)\s*=>\s*api\.\w+\.(' + ops.join('|') + r')\(',
    );
    final offenders = <String>[];
    for (final f
        in Directory('lib')
            .listSync(recursive: true)
            .whereType<File>()
            .where((f) => f.path.endsWith('.dart'))) {
      if (wrong.hasMatch(f.readAsStringSync())) offenders.add(f.path);
    }
    expect(
      offenders,
      isEmpty,
      reason: 'use api.send for these no-content requests',
    );
  });
}
