import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pesu/data/languages.dart';
import 'package:pesu/features/home/home_screen.dart';

/// The language sheet used to overflow by ~220 px on a 360 dp-wide phone
/// (Realme RMX3842). It must fit and scroll on small and large screens.
void main() {
  for (final size in const [
    Size(1080, 2412),
    Size(720, 1280),
    Size(1440, 3200),
  ]) {
    testWidgets('language picker fits without overflow at $size', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = size.width / 360;
      addTearDown(tester.view.reset);

      String? picked;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () async =>
                      picked = await pickLanguage(context, languages.first),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // The last language is reachable (scrolling if needed) and selectable.
      // (On short screens the bottom rows are only built once scrolled to.)
      final english = find.byKey(const ValueKey('lang-en'));
      await tester.scrollUntilVisible(
        english,
        100,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.tap(english);
      await tester.pumpAndSettle();
      expect(picked, 'en');
      expect(tester.takeException(), isNull);
    });
  }
}
