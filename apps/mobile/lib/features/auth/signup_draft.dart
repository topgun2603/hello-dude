import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pesu_api/api.dart';

/// What the sign-up screens collect before the account exists.
class SignupDraft {
  const SignupDraft({
    this.phone = '',
    this.gender = SignUpRequestGenderEnum.female,
    this.signupToken,
  });
  final String phone; // 10 digits
  final SignUpRequestGenderEnum gender;
  final String? signupToken; // set after OTP when the number is new

  SignupDraft copyWith({
    String? phone,
    SignUpRequestGenderEnum? gender,
    String? signupToken,
  }) => SignupDraft(
    phone: phone ?? this.phone,
    gender: gender ?? this.gender,
    signupToken: signupToken ?? this.signupToken,
  );
}

class SignupDraftController extends Notifier<SignupDraft> {
  @override
  SignupDraft build() => const SignupDraft();
  void update(SignupDraft draft) => state = draft;
  void reset() => state = const SignupDraft();
}

final signupDraftProvider =
    NotifierProvider<SignupDraftController, SignupDraft>(
      SignupDraftController.new,
    );
