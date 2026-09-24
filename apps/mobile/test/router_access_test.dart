import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pesu/app/router.dart';

void main() {
  test('each role can open its own screens, including ones with ids', () {
    for (final p in ['/home', '/coin-history', '/call-history', '/call-details', '/schedule/123', '/vip']) {
      expect(routeAllowed(callerPaths, p), isTrue, reason: 'caller $p');
    }
    for (final p in ['/companion', '/call-history', '/call-details', '/rewards', '/academy']) {
      expect(routeAllowed(companionPaths, p), isTrue, reason: 'companion $p');
    }
    expect(routeAllowed(companionPaths, '/coin-history'), isFalse);
    expect(routeAllowed(callerPaths, '/kyc'), isFalse);
    expect(routeAllowed(callerPaths, '/homework'), isFalse); // prefix only at a "/"
  });

  test('every screen in the router is reachable by someone', () {
    final src = File('lib/app/router.dart').readAsStringSync();
    final paths = RegExp(r"path: '(/[^']*)'").allMatches(src).map((m) => m.group(1)!).toSet();
    // Handled before the role lists: splash, legal pages, and the screens both roles share.
    const shared = {'/splash', '/legal', '/chats', '/chat/:id', '/bookings', '/rooms', '/room/:id'};
    final unreachable = paths.where((p) {
      if (shared.contains(p)) return false;
      final sample = p.replaceAll(RegExp(r':\w+'), 'x');
      return !routeAllowed(signUpPaths, sample) && !routeAllowed(callerPaths, sample) && !routeAllowed(companionPaths, sample);
    }).toList();
    expect(unreachable, isEmpty, reason: 'add these to callerPaths / companionPaths in router.dart');
  });
}
