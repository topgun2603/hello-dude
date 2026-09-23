import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pesu/widgets/love_loader.dart';

void main() {
  for (final size in const [Size(1080, 2412), Size(720, 1280)]) {
    testWidgets('love loader lays out cleanly at $size', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = size.width / 360;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoveLoader(
              title: 'Signing you in…',
              subtitle: 'Different languages. Same vibe.',
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 600)); // mid-animation
      expect(tester.takeException(), isNull);
      expect(find.text('Signing you in…'), findsOneWidget);
      expect(find.text('Different languages. Same vibe.'), findsOneWidget);
    });
  }

  testWidgets(
    'withLoveLoader shows while the task runs, then goes away — even if it fails',
    (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (c) {
              ctx = c;
              return const Scaffold(body: Text('screen'));
            },
          ),
        ),
      );

      final done = withLoveLoader(
        ctx,
        title: 'Signing you out…',
        minimum: Duration.zero,
        task: () => Future<void>.delayed(const Duration(milliseconds: 300)),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Signing you out…'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 400));
      await done;
      await tester.pump();
      expect(find.text('Signing you out…'), findsNothing);

      // Attach the expectation straight away so the error is handled.
      final failed = expectLater(
        withLoveLoader<void>(
          ctx,
          title: 'Oops',
          minimum: Duration.zero,
          task: () async => throw StateError('network'),
        ),
        throwsStateError,
      );
      await tester.pump();
      await failed;
      await tester.pump();
      expect(find.text('Oops'), findsNothing);
    },
  );
}
