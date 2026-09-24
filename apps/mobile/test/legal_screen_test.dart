import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pesu/features/legal/legal_screen.dart';
import 'package:pesu_api/api.dart';

LegalSpan s(String text, {bool? bold, String? href}) =>
    LegalSpan(text: text, bold: bold, href: href);

final page = GetLegalPage200Response(
  id: GetLegalPage200ResponseIdEnum.privacy,
  title: 'Privacy Policy',
  draft: true,
  blocks: [
    LegalBlock(type: LegalBlockTypeEnum.h1, spans: [s('Privacy Policy')]),
    LegalBlock(
      type: LegalBlockTypeEnum.p,
      spans: [s('We are the '), s('Data Fiduciary', bold: true), s('.')],
    ),
    LegalBlock(
      type: LegalBlockTypeEnum.h2,
      spans: [s('4. How long we keep it')],
    ),
    LegalBlock(
      type: LegalBlockTypeEnum.ul,
      items: [
        LegalCell(spans: [s('Mobile number')]),
        LegalCell(
          spans: [
            s('see '),
            s('Grievance', href: 'grievance'),
          ],
        ),
      ],
    ),
    LegalBlock(
      type: LegalBlockTypeEnum.table,
      head: [
        LegalCell(spans: [s('Data')]),
        LegalCell(spans: [s('Kept for')]),
      ],
      rows: [
        LegalRow(
          cells: [
            LegalCell(spans: [s('Flagged video frames')]),
            LegalCell(spans: [s('Deleted 30 days after our review')]),
          ],
        ),
      ],
    ),
  ],
);

void main() {
  for (final size in const [Size(1080, 2412), Size(720, 1280)]) {
    testWidgets(
      'policy page renders every block type without overflow at $size',
      (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = size.width / 360;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              legalPageProvider('privacy').overrideWith((ref) async => page),
            ],
            child: const MaterialApp(home: LegalPageScreen(id: 'privacy')),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(
          find.text('Privacy Policy'),
          findsOneWidget,
        ); // header only; the h1 block is skipped
        expect(find.textContaining('Draft'), findsOneWidget);
        expect(find.textContaining('How long we keep it'), findsOneWidget);
        expect(find.textContaining('Flagged video frames'), findsOneWidget);
        expect(
          find.textContaining('Deleted 30 days after our review'),
          findsOneWidget,
        );
      },
    );
  }

  testWidgets('index lists all five policies', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LegalIndexScreen())),
    );
    for (final (id, _, _) in legalPages) {
      expect(find.byKey(ValueKey('legal-$id')), findsOneWidget);
    }
  });
}
