import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pesu_api/api.dart';

import '../../app/theme.dart';
import '../../data/errors.dart';
import '../../data/phone_auth.dart';
import '../../data/session.dart';
import '../../widgets/common.dart';
import '../../widgets/love_loader.dart';
import 'signup_draft.dart';

/// Design: Otp.dc.html — six boxes, resend timer, privacy note, Verify.
class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  static const _resendSeconds = 30;
  final _code = TextEditingController();
  final _focus = FocusNode();
  Timer? _timer;
  int _left = _resendSeconds;
  bool _verifying = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    if (useDevOtp) return;
    // Android may read the SMS by itself, before or after this screen opens.
    final early = ref.read(phoneAuthProvider)?.autoIdToken;
    if (early != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _finish(() => Future.value(early)),
      );
    }
    ref.listenManual(phoneAuthProvider, (prev, next) {
      final token = next?.autoIdToken;
      if (token != null && token != prev?.autoIdToken) {
        _finish(() => Future.value(token));
      }
    });
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _left = _resendSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_left <= 1) t.cancel();
      if (mounted) setState(() => _left--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _code.dispose();
    _focus.dispose();
    super.dispose();
  }

  String get _phone => ref.read(signupDraftProvider).phone;

  Future<void> _verify() async {
    if (_code.text.length != 6 || _verifying) return;
    final code = _code.text;
    if (useDevOtp) {
      final api = ref.read(apiProvider);
      return _complete(
        () => api.call(
          () => api.auth.verifyOtp(VerifyOtpRequest(phone: _phone, code: code)),
        ),
      );
    }
    return _finish(() => ref.read(phoneAuthProvider.notifier).verifyCode(code));
  }

  /// Firebase path: get the ID token, then swap it for our own session.
  Future<void> _finish(Future<String> Function() idToken) => _complete(
    () async => ref.read(phoneAuthProvider.notifier).exchange(await idToken()),
  );

  /// Signs in an existing account, or moves a new number on to sign-up.
  Future<void> _complete(Future<OtpVerifyResult> Function() check) async {
    if (_verifying) return;
    setState(() => _verifying = true);
    try {
      final result = await check();
      if (result.status == OtpVerifyResultStatusEnum.signedIn) {
        // Router sends a signed-in user to Home, under the loader.
        if (!mounted) return;
        await withLoveLoader(
          context,
          title: 'Signing you in…',
          subtitle: 'Different languages. Same vibe.',
          task: () => ref
              .read(sessionProvider.notifier)
              .signIn(result.tokens!, result.profile!),
        );
        ref.read(signupDraftProvider.notifier).reset();
        ref.read(phoneAuthProvider.notifier).reset();
      } else {
        final draft = ref.read(signupDraftProvider);
        ref
            .read(signupDraftProvider.notifier)
            .update(draft.copyWith(signupToken: result.signupToken));
        if (mounted) context.push('/language');
      }
    } catch (e) {
      _code.clear();
      if (mounted) {
        setState(() {});
        showError(context, friendlyError(e));
        _focus.requestFocus();
      }
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }

  Future<void> _resend() async {
    final api = ref.read(apiProvider);
    try {
      if (useDevOtp) {
        await api.auth.sendOtp(SendOtpRequest(phone: _phone));
      } else {
        await ref.read(phoneAuthProvider.notifier).send(_phone);
      }
      _startTimer();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('New code sent')));
      }
    } catch (e) {
      if (mounted) showError(context, friendlyError(e));
    }
  }

  String get _prettyPhone {
    final p = _phone;
    return p.length == 10
        ? '+91 ${p.substring(0, 5)} ${p.substring(5)}'
        : '+91 $p';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GlowBackground(
        child: SafeArea(
          child: FillScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 26),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleIconButton(
                    icon: Icons.arrow_back_rounded,
                    tooltip: 'Back',
                    onPressed: () => context.pop(),
                  ),
                  const StepDots(step: 0),
                  const SizedBox(width: 46),
                ],
              ),
              const SizedBox(height: 34),
              const _Rings(),
              const SizedBox(height: 30),
              OneLine(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Enter the ',
                      style: AppText.heading(30, spacing: -0.8),
                    ),
                    GradientText(
                      '6-digit code',
                      style: AppText.heading(30, spacing: -0.8),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              OneLine(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Sent to ',
                      style: AppText.body(15, color: AppColors.textMuted),
                    ),
                    Text(
                      _prettyPhone,
                      style: AppText.body(15, weight: FontWeight.w600),
                    ),
                    Text(
                      ' · ',
                      style: AppText.body(15, color: AppColors.textMuted),
                    ),
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Text(
                        'Edit',
                        style: AppText.body(
                          15,
                          color: const Color(0xFFF9A8D4),
                          weight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              _boxes(),
              const SizedBox(height: 18),
              Center(
                child: _left > 0
                    ? Text.rich(
                        TextSpan(
                          style: AppText.body(
                            14,
                            color: AppColors.textSecondary,
                          ),
                          children: [
                            const TextSpan(text: 'Resend code in '),
                            TextSpan(
                              text: '0:${_left.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : TextButton(
                        onPressed: _resend,
                        child: Text(
                          'Resend code',
                          style: AppText.body(
                            14,
                            color: const Color(0xFFF9A8D4),
                            weight: FontWeight.w600,
                          ),
                        ),
                      ),
              ),
              const Spacer(),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.lock_outline_rounded,
                      color: AppColors.success,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your number stays private. Others only see your avatar and first name.',
                        style: AppText.body(
                          13.5,
                          color: AppColors.textMuted,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              GradientButton(
                label: 'Verify',
                loading: _verifying,
                onPressed: _code.text.length == 6 ? _verify : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// A hidden text field drives six visual boxes (keeps SMS autofill working).
  Widget _boxes() {
    final text = _code.text;
    return Stack(
      children: [
        Row(
          children: [
            for (var i = 0; i < 6; i++) ...[
              if (i > 0) const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () => _focus.requestFocus(),
                  child: Container(
                    height: 58,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: i == text.length
                          ? const Color(0x24EC4899)
                          : AppColors.card,
                      border: Border.all(
                        width: 1.5,
                        color: i == text.length
                            ? AppColors.pink
                            : i < text.length
                            ? const Color(0x8CC084FC)
                            : Colors.white.withValues(alpha: 0.18),
                      ),
                    ),
                    child: Text(
                      i < text.length ? text[i] : '',
                      style: AppText.heading(24),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
        Positioned.fill(
          child: Opacity(
            opacity: 0,
            child: TextField(
              controller: _code,
              focusNode: _focus,
              autofocus: true,
              keyboardType: TextInputType.number,
              autofillHints: const [AutofillHints.oneTimeCode],
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              showCursor: false,
              enableInteractiveSelection: false,
              onChanged: (v) {
                setState(() {});
                if (v.length == 6) _verify();
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _Rings extends StatelessWidget {
  const _Rings();

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 170,
    child: Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 170,
          height: 170,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0x40C084FC)),
          ),
        ),
        Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0x59F472B6)),
          ),
        ),
        Transform.rotate(
          angle: -0.1,
          child: Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: AppColors.brandLogo,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x66DB2777),
                  blurRadius: 30,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: const Icon(Icons.sms_rounded, color: Colors.white, size: 42),
          ),
        ),
      ],
    ),
  );
}
