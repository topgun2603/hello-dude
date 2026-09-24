//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

import 'package:pesu_api/api.dart';
import 'package:test/test.dart';


/// tests for BookingsApi
void main() {
  // final instance = BookingsApi();

  group('tests for BookingsApi', () {
    // Caller cancels; the held coins come back in full
    //
    //Future<Booking> cancelBooking(String id, ConfirmBookingRequest confirmBookingRequest) async
    test('test cancelBooking', () async {
      // TODO
    });

    // Companion accepts the booked time
    //
    //Future<Booking> confirmBooking(String id, ConfirmBookingRequest confirmBookingRequest) async
    test('test confirmBooking', () async {
      // TODO
    });

    // Book a call with a favourite. Coins for the full duration are held now and returned if it doesn't happen.
    //
    //Future<CreateBooking201Response> createBooking(CreateBookingRequest createBookingRequest) async
    test('test createBooking', () async {
      // TODO
    });

    // Companion declines; the caller's coins come back
    //
    //Future<Booking> declineBooking(String id, ConfirmBookingRequest confirmBookingRequest) async
    test('test declineBooking', () async {
      // TODO
    });

    // Bookable times for the next few days (IST), and the durations offered
    //
    //Future<GetBookingSlots200Response> getBookingSlots(String id) async
    test('test getBookingSlots', () async {
      // TODO
    });

    // My bookings: upcoming (and in progress) first, then the last 30 days
    //
    //Future<ListBookings200Response> listBookings() async
    test('test listBookings', () async {
      // TODO
    });

    // Caller starts the booked call (from 5 min before to 15 min after). The hold comes back and the call is billed per minute.
    //
    //Future<Booking> startBooking(String id, ConfirmBookingRequest confirmBookingRequest) async
    test('test startBooking', () async {
      // TODO
    });

  });
}
