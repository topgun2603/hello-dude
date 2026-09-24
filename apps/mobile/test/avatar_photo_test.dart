import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pesu/widgets/common.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  test('photo paths from the API become absolute URLs', () {
    expect(Avatar.photoSrc('/v1/photos/u/3.jpg?exp=1&sig=x'), endsWith('/v1/photos/u/3.jpg?exp=1&sig=x'));
    expect(Avatar.photoSrc('/v1/photos/u/3.jpg'), startsWith('http'));
    expect(Avatar.photoSrc('https://cdn.example/p.jpg'), 'https://cdn.example/p.jpg');
  });

  testWidgets('a photo that fails to load falls back to the illustrated avatar', (t) async {
    // Tests have no network: every Image.network fails, like an expired link.
    await t.pumpWidget(const MaterialApp(
      home: Scaffold(body: Avatar(name: 'Priya', avatarId: 1, size: 64, photoUrl: '/v1/photos/x/1.jpg?exp=1&sig=bad')),
    ));
    await t.pumpAndSettle();
    expect(t.takeException(), isNull);
    expect(find.byWidgetPredicate((w) => w is Image && w.image is AssetImage), findsOneWidget);
  });
}
