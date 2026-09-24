import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pesu_api/api.dart';

import '../../app/config.dart';
import '../../app/theme.dart';
import '../../data/errors.dart';
import '../../data/phone_auth.dart';
import '../../data/session.dart';
import '../../widgets/common.dart';
import 'signup_draft.dart';

/// Design: Main.dc.html — mobile number + "I am" + 18+ notice.
class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  late final _phone = TextEditingController(
    text: ref.read(signupDraftProvider).phone,
  );
  late var _gender = ref.read(signupDraftProvider).gender;
  bool _sending = false;

  bool get _valid => RegExp(r'^[6-9]\d{9}$').hasMatch(_phone.text);

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    FocusScope.of(context).unfocus();
    setState(() => _sending = true);
    final api = ref.read(apiProvider);
    try {
      if (useDevOtp) {
        await api.auth.sendOtp(SendOtpRequest(phone: _phone.text));
      } else {
        ref.read(phoneAuthProvider.notifier).reset();
        await ref.read(phoneAuthProvider.notifier).send(_phone.text);
      }
      ref
          .read(signupDraftProvider.notifier)
          .update(SignupDraft(phone: _phone.text, gender: _gender));
      if (mounted) context.push('/otp');
    } catch (e) {
      // A code sent moments ago is still valid: go and enter it.
      if (errorCode(e) == 'OTP_COOLDOWN' && mounted) {
        ref
            .read(signupDraftProvider.notifier)
            .update(SignupDraft(phone: _phone.text, gender: _gender));
        context.push('/otp');
      } else if (mounted) {
        showError(context, friendlyError(e));
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GlowBackground(
        child: SafeArea(
          child: FillScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 22),
            children: [
              Row(
                children: [
                  const BrandMark(size: 46),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppConfig.appName,
                        style: AppText.heading(24, spacing: -0.5),
                      ),
                      Text(
                        AppConfig.tagline,
                        style: AppText.body(12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),
              OneLine(
                Text('Talk in the', style: AppText.heading(33, spacing: -1)),
              ),
              OneLine(
                GradientText(
                  'language you think in.',
                  style: AppText.heading(33, spacing: -1),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'One-on-one voice and video calls with people who speak your language.',
                textAlign: TextAlign.center,
                style: AppText.body(
                  14.5,
                  color: AppColors.textMuted,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 14),
              const _Hero(),
              const SizedBox(height: 18),
              _form(),
              const Spacer(),
              const SizedBox(height: 16),
              GradientButton(
                label: 'Continue',
                icon: Icons.arrow_forward_rounded,
                loading: _sending,
                onPressed: _valid ? _continue : null,
              ),
              const SizedBox(height: 12),
              Text.rich(
                TextSpan(
                  style: AppText.body(12.5, color: AppColors.textSecondary),
                  children: [
                    const TextSpan(
                      text: '18+ only. By continuing you agree to our ',
                    ),
                    TextSpan(
                      text: 'Terms',
                      style: const TextStyle(color: Color(0xFF7DB4FF)),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => context.push('/legal/terms'),
                    ),
                    const TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: const TextStyle(color: Color(0xFF7DB4FF)),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => context.push('/legal/privacy'),
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _form() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Mobile number', style: AppText.body(14, weight: FontWeight.w600)),
        const SizedBox(height: 8),
        Container(
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: const Color(0x990A0A18),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.18),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: Colors.white.withValues(alpha: 0.18),
                      width: 1.5,
                    ),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  '🇮🇳  +91',
                  style: AppText.body(15, weight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  autofillHints: const [AutofillHints.telephoneNumberNational],
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  style: AppText.body(
                    17,
                    weight: FontWeight.w600,
                  ).copyWith(letterSpacing: 1),
                  cursorColor: AppColors.pink,
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (_) => _valid ? _continue() : null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                    hintText: '98765 43210',
                    hintStyle: AppText.body(17, color: AppColors.hint),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "We'll send a 6-digit code to verify it.",
          style: AppText.body(13, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 14),
        Text('I am', style: AppText.body(14, weight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(
          children: [
            for (final (g, label, icon) in const [
              (SignUpRequestGenderEnum.male, 'Male', Icons.male_rounded),
              (SignUpRequestGenderEnum.female, 'Female', Icons.female_rounded),
              (SignUpRequestGenderEnum.other, 'Other', Icons.circle_outlined),
            ]) ...[
              if (g != SignUpRequestGenderEnum.male) const SizedBox(width: 8),
              Expanded(child: _genderChip(g, label, icon)),
            ],
          ],
        ),
      ],
    ),
  );

  Widget _genderChip(SignUpRequestGenderEnum g, String label, IconData icon) {
    final on = _gender == g;
    return Semantics(
      button: true,
      selected: on,
      child: GestureDetector(
        onTap: () => setState(() => _gender = g),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              height: 46,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: on ? const Color(0x29EC4899) : Colors.transparent,
                border: Border.all(
                  color: on
                      ? AppColors.pink
                      : Colors.white.withValues(alpha: 0.2),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 18,
                    color: on
                        ? const Color(0xFFF9A8D4)
                        : const Color(0xFF93C5FD),
                  ),
                  const SizedBox(width: 6),
                  Text(label, style: AppText.body(15, weight: FontWeight.w600)),
                ],
              ),
            ),
            if (on)
              Positioned(
                top: -8,
                right: -6,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.pink,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Landing artwork: two people on a call, fading into the background.
class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) => Semantics(
    image: true,
    label: 'A young man and woman smiling at each other on a video call',
    child: AspectRatio(
      aspectRatio: 3 / 2,
      child: ShaderMask(
        // Soft edges so the picture blends into the dark glow background.
        shaderCallback: (rect) => const RadialGradient(
          radius: 0.78,
          colors: [Colors.white, Colors.white, Colors.transparent],
          stops: [0, 0.72, 1],
        ).createShader(rect),
        blendMode: BlendMode.dstIn,
        child: Image.asset(
          'assets/images/landing.jpg',
          fit: BoxFit.cover,
          filterQuality: FilterQuality.medium,
          excludeFromSemantics: true,
        ),
      ),
    ),
  );
}
