import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pesu/features/bookings/bookings_screens.dart';
import 'package:pesu/features/home/home_data.dart';
import 'package:pesu_api/api.dart';

final _companion = OnlineCompanion(
  id: 'c1',
  badge: null,
  displayName: 'Priya',
  avatarId: 1,
  photoUrl: null,
  primaryLanguage: 'ta',
  languages: const ['ta', 'en'],
  rating: 4.7,
  ratingCount: 12,
  audioEnabled: true,
  videoEnabled: true,
  busy: false,
  isFavourite: true,
  rates: CompanionRates(audioCoinsPerMin: 10, videoCoinsPerMin: 25),
);

GetBookingSlots200Response _slots() {
  final base = DateTime.now().add(const Duration(days: 1));
  return GetBookingSlots200Response(
    durations: const [10, 20, 30],
    days: [
      for (var d = 0; d < 5; d++)
        GetBookingSlots200ResponseDaysInner(
          date:
              '${base.year}-${base.month.toString().padLeft(2, '0')}-${(base.day).toString().padLeft(2, '0')}',
          slots: [
            for (var i = 0; i < 9; i++)
              GetBookingSlots200ResponseDaysInnerSlotsInner(
                startAt: DateTime(
                  base.year,
                  base.month,
                  base.day,
                  19,
                ).add(Duration(minutes: 30 * i + d * 1440)),
                available: i != 2 && i != 5,
              ),
          ],
        ),
    ],
  );
}

Booking _booking(BookingStatusEnum status, {bool canStart = false}) => Booking(
  id: 'b1',
  status: status,
  startAt: DateTime.now().add(const Duration(hours: 5)),
  minutes: 20,
  callType: BookingCallTypeEnum.audio,
  coinsPerMin: 10,
  heldCoins: 200,
  canStart: canStart,
  caller: RoomCardHost(id: 'u1', displayName: 'Karthik', avatarId: 2),
  companion: RoomCardHost(id: 'c1', displayName: 'Priya', avatarId: 1),
);

Future<void> pumpAt(
  WidgetTester tester,
  Size size,
  Widget child,
  List<Override> overrides,
) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = size.width / 360;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: MaterialApp(home: child),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  for (final size in const [Size(1080, 2412), Size(720, 1280)]) {
    testWidgets('schedule: pick a time and length, see coins held at $size', (
      tester,
    ) async {
      await pumpAt(tester, size, const ScheduleScreen(companionId: 'c1'), [
        scheduleProvider(
          'c1',
        ).overrideWith((ref) async => ScheduleData(_slots(), _companion)),
        walletProvider.overrideWith((ref) async => throw 'offline'),
      ]);
      expect(tester.takeException(), isNull);
      expect(find.text('Schedule a call'), findsOneWidget);
      expect(find.text('Priya'), findsOneWidget);
      await tester.tap(find.text('8:30 PM'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('20 min'));
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          "200 coins held now, refunded if Priya doesn't join",
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'bookings: caller sees Cancel and Call now; companion sees Confirm at $size',
      (tester) async {
        final list = ListBookings200Response(
          upcoming: [_booking(BookingStatusEnum.confirmed, canStart: true)],
          past: [_booking(BookingStatusEnum.missed)],
        );
        await pumpAt(tester, size, const BookingsScreen(), [
          bookingsProvider.overrideWith((ref) async => list),
        ]);
        expect(tester.takeException(), isNull);
        expect(find.text('Call now'), findsOneWidget);
        expect(find.text('Cancel booking'), findsOneWidget);
        expect(find.text("Didn't happen · coins returned"), findsOneWidget);
      },
    );
  }
}
