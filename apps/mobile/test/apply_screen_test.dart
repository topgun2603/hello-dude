import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pesu/app/theme.dart';
import 'package:pesu/data/session.dart';
import 'package:pesu/features/companion/apply_screen.dart';

class _SignedOut extends SessionController {
  @override
  SessionState build() => const SessionState(SessionStatus.signedOut);
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  // Small, common and large Android phones (logical pixels).
  for (final size in const [
    Size(360, 640),
    Size(360, 740),
    Size(390, 844),
    Size(412, 915),
  ]) {
    testWidgets('become-a-companion fits without overflow at $size', (
      tester,
    ) async {
      tester.view.physicalSize = size * 3;
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [sessionProvider.overrideWith(_SignedOut.new)],
          child: MaterialApp(theme: buildTheme(), home: const ApplyScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      // The button must be reachable by scrolling.
      await tester.scrollUntilVisible(
        find.text('Continue to verification'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(tester.takeException(), isNull);
    });
  }
}
