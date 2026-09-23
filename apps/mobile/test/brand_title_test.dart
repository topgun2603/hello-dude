import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pesu/widgets/common.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('brand title shrinks instead of overflowing a tight header row', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          // Home header on a 360 dp phone: title + coin chip + icon button.
          child: SizedBox(
            width: 160,
            child: Row(
              children: const [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: BrandTitle(),
                  ),
                ),
                SizedBox(width: 44, height: 44),
              ],
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });
}
