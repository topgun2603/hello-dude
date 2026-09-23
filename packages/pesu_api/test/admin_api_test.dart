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


/// tests for AdminApi
void main() {
  // final instance = AdminApi();

  group('tests for AdminApi', () {
    // Approve and send to UPI. Failures are credited back to the companion automatically.
    //
    //Future<AdminPayout> adminApprovePayout(String id) async
    test('test adminApprovePayout', () async {
      // TODO
    });

    // Latest admin actions
    //
    //Future<List<AdminAuditLog200ResponseInner>> adminAuditLog({ int limit }) async
    test('test adminAuditLog', () async {
      // TODO
    });

    // Add a coin pack. Create the Google Play product with the same SKU first.
    //
    //Future<AdminCoinPackage> adminCreatePackage(AdminCreatePackageRequest adminCreatePackageRequest) async
    test('test adminCreatePackage', () async {
      // TODO
    });

    // Add a rate version. Calls already running keep their old rate.
    //
    //Future<AdminCallRate> adminCreateRate(AdminCreateRateRequest adminCreateRateRequest) async
    test('test adminCreateRate', () async {
      // TODO
    });

    // Live numbers and today's totals (India time)
    //
    //Future<AdminDashboard200Response> adminDashboard() async
    test('test adminDashboard', () async {
      // TODO
    });

    // Approve (companion can go online) or reject with a reason the companion will see
    //
    //Future<String> adminKycDecision(String userId, AdminKycDecisionRequest adminKycDecisionRequest) async
    test('test adminKycDecision', () async {
      // TODO
    });

    // Decrypted KYC image for side-by-side review. Every view is audit-logged.
    //
    //Future adminKycFile(String userId, String doc) async
    test('test adminKycFile', () async {
      // TODO
    });

    // KYC review queue (oldest first) or decided cases
    //
    //Future<List<AdminKycCase>> adminKycQueue({ String status }) async
    test('test adminKycQueue', () async {
      // TODO
    });

    //Future<List<AdminCoinPackage>> adminListPackages() async
    test('test adminListPackages', () async {
      // TODO
    });

    //Future<AdminListPayouts200Response> adminListPayouts({ String status }) async
    test('test adminListPayouts', () async {
      // TODO
    });

    // All call rates: current, scheduled and past
    //
    //Future<List<AdminCallRate>> adminListRates() async
    test('test adminListRates', () async {
      // TODO
    });

    //Future<List<AdminReport>> adminListReports({ String status, int limit }) async
    test('test adminListReports', () async {
      // TODO
    });

    // Search callers or companions by name or the last digits of their number
    //
    //Future<AdminListUsers200Response> adminListUsers({ String role, String q, String status, int limit, int offset }) async
    test('test adminListUsers', () async {
      // TODO
    });

    // Reject a withdrawal; the amount goes back to the companion's balance
    //
    //Future<String> adminRejectPayout(String id, AdminRejectPayoutRequest adminRejectPayoutRequest) async
    test('test adminRejectPayout', () async {
      // TODO
    });

    // Dismiss a report, or act on it by suspending the reported user
    //
    //Future<String> adminResolveReport(String id, AdminResolveReportRequest adminResolveReportRequest) async
    test('test adminResolveReport', () async {
      // TODO
    });

    // Suspend, ban or reactivate an account
    //
    //Future<String> adminSetUserStatus(String id, AdminSetUserStatusRequest adminSetUserStatusRequest) async
    test('test adminSetUserStatus', () async {
      // TODO
    });

    // Unlock or lock video calls for a companion (after academy + clean record)
    //
    //Future<String> adminSetVideo(String userId, AdminSetVideoRequest adminSetVideoRequest) async
    test('test adminSetVideo', () async {
      // TODO
    });

    // Edit a coin pack. The Google Play product price must be changed to match in Play Console.
    //
    //Future<AdminCoinPackage> adminUpdatePackage(int id, AdminUpdatePackageRequest adminUpdatePackageRequest) async
    test('test adminUpdatePackage', () async {
      // TODO
    });

  });
}
