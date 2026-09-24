import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pesu_api/api.dart';

import 'errors.dart';
import 'session.dart';

/// Phone sign-in (CLAUDE.md: Firebase Auth, India only).
///
/// Firebase sends the SMS and checks the code; the app then swaps Firebase's
/// ID token for our own session at `POST /v1/auth/firebase`. Build with
/// `--dart-define=DEV_OTP=true` to use the server's dev code (123456) instead,
/// e.g. for the demo accounts.
const useDevOtp = bool.fromEnvironment('DEV_OTP');

class PhoneVerification {
  const PhoneVerification({
    this.verificationId,
    this.resendToken,
    this.autoIdToken,
  });

  /// Set once Firebase has sent the SMS.
  final String? verificationId;
  final int? resendToken;

  /// Android verified the number by itself (SMS read automatically): no typing needed.
  final String? autoIdToken;
}

class PhoneAuthController extends Notifier<PhoneVerification?> {
  @override
  PhoneVerification? build() => null;

  /// Sends the code to a 10-digit Indian mobile. Completes when the SMS is on
  /// its way (or the phone verified itself); throws [UserFacingError] otherwise.
  Future<void> send(String tenDigits) {
    final done = Completer<void>();
    void finish([Object? error]) {
      if (done.isCompleted) return;
      error == null ? done.complete() : done.completeError(error);
    }

    FirebaseAuth.instance
        .verifyPhoneNumber(
          phoneNumber: '+91$tenDigits',
          forceResendingToken: state?.resendToken,
          timeout: const Duration(seconds: 60),
          codeSent: (id, resend) {
            state = PhoneVerification(verificationId: id, resendToken: resend);
            finish();
          },
          verificationCompleted: (credential) async {
            try {
              final token = await _idTokenFor(credential);
              state = PhoneVerification(
                verificationId: state?.verificationId,
                resendToken: state?.resendToken,
                autoIdToken: token,
              );
              finish();
            } catch (e) {
              finish(e);
            }
          },
          verificationFailed: (e) => finish(UserFacingError(_message(e))),
          codeAutoRetrievalTimeout: (_) {},
        )
        .catchError((Object e) => finish(UserFacingError(_message(e))));
    return done.future;
  }

  /// The 6-digit code the user typed -> Firebase ID token.
  Future<String> verifyCode(String code) async {
    final id = state?.verificationId;
    if (id == null) throw const UserFacingError('Ask for a new code first.');
    return _idTokenFor(
      PhoneAuthProvider.credential(verificationId: id, smsCode: code),
    );
  }

  /// Swaps Firebase's proof for our own session; Firebase's own sign-in isn't
  /// kept (our tokens are the session).
  Future<OtpVerifyResult> exchange(String idToken) async {
    final api = ref.read(apiProvider);
    try {
      return await api.call(
        () => api.auth.signInWithFirebase(
          SignInWithFirebaseRequest(idToken: idToken),
        ),
      );
    } finally {
      await FirebaseAuth.instance.signOut().catchError((_) {});
    }
  }

  void reset() => state = null;

  static Future<String> _idTokenFor(AuthCredential credential) async {
    try {
      final result = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      final token = await result.user?.getIdToken();
      if (token == null) {
        throw const UserFacingError('Could not verify your number. Try again.');
      }
      return token;
    } on FirebaseAuthException catch (e) {
      throw UserFacingError(_message(e));
    }
  }

  static String _message(Object e) {
    final code = e is FirebaseAuthException ? e.code : '';
    return switch (code) {
      'invalid-verification-code' =>
        'That code is not right. Check the SMS and try again.',
      'session-expired' ||
      'code-expired' => 'That code has expired. Ask for a new one.',
      'too-many-requests' =>
        'Too many tries from this phone. Please try again later.',
      'invalid-phone-number' => 'Enter a valid 10-digit Indian mobile number.',
      'network-request-failed' =>
        "Can't reach the internet. Check your connection and try again.",
      'quota-exceeded' =>
        "We can't send codes right now. Please try again in a while.",
      _ => 'Could not verify your number. Please try again.',
    };
  }
}

final phoneAuthProvider =
    NotifierProvider<PhoneAuthController, PhoneVerification?>(
      PhoneAuthController.new,
    );
