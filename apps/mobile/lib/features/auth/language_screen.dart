import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pesu_api/api.dart';

import '../../app/theme.dart';
import '../../data/errors.dart';
import '../../data/languages.dart';
import '../../data/session.dart';
import '../../widgets/common.dart';
import '../../widgets/love_loader.dart';
import 'signup_draft.dart';

/// Design: Language.dc.html (light screen). Last sign-up step: creates the account.
class LanguageScreen extends ConsumerStatefulWidget {
  const LanguageScreen({super.key});

  @override
  ConsumerState<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends ConsumerState<LanguageScreen> {
  String? _chosen;
  bool _saving = false;
  bool _showCode = false;
  final _code = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    final draft = ref.read(signupDraftProvider);
    if (_chosen == null || draft.signupToken == null) return;
    setState(() => _saving = true);
    final api = ref.read(apiProvider);
    try {
      await withLoveLoader(
        context,
        title: 'Creating your account…',
        subtitle: 'Different languages. Same vibe.',
        task: () async {
          final res = await api.call(
            () => api.auth.signUp(
              SignUpRequest(
                signupToken: draft.signupToken!,
                gender: draft.gender,
                language: _chosen!,
                ageConfirmed: true,
                referralCode: _code.text.trim().isEmpty ? null : _code.text.trim(),
              ),
            ),
          );
          await ref
              .read(sessionProvider.notifier)
              .signIn(res.tokens, res.profile);
        },
      );
      ref.read(signupDraftProvider.notifier).reset();
      // Router moves a signed-in user to Home.
    } catch (e) {
      if (!mounted) return;
      if (errorCode(e) == 'SIGNUP_TOKEN_INVALID') {
        showError(
          context,
          'That took a while — please verify your number again.',
        );
        context.go('/welcome');
      } else if (errorCode(e) == 'INVALID_REFERRAL_CODE') {
        setState(() => _showCode = true);
        showError(context, "That invite code doesn't exist. Check it, or clear it to continue.");
      } else {
        showError(context, friendlyError(e));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final chosen = _chosen == null ? null : languageInfo(_chosen!);
    return Scaffold(
      backgroundColor: Colors.white,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(1, -1),
            radius: 1.1,
            colors: [Color(0x26EC4899), Color(0x00FFFFFF)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                right: 22,
                bottom: 22,
                child: Transform.rotate(
                  angle: -0.157,
                  child: Text(
                    'Different languages.\nSame vibe.',
                    textAlign: TextAlign.right,
                    style: AppText.hand(
                      20,
                      color: const Color(0xFF3730A3),
                    ).copyWith(height: 0.95),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 96),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleIconButton(
                          icon: Icons.arrow_back_rounded,
                          tooltip: 'Back',
                          light: true,
                          onPressed: () => context.pop(),
                        ),
                        const StepDots(step: 1, light: true),
                        const Flexible(
                          child: BrandTitle(
                            logoSize: 32,
                            fontSize: 19,
                            dark: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Wrap(
                      children: [
                        Text(
                          'Which language ',
                          style: AppText.heading(
                            30,
                            color: AppColors.lightText,
                            spacing: -0.8,
                          ),
                        ),
                        GradientText(
                          'do you want to talk in?',
                          style: AppText.heading(30, spacing: -0.8),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF4F46E5),
                              Color(0xFF9333EA),
                              Color(0xFFDB2777),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "We'll match you with people who speak it. You can change this later in settings.",
                      style: AppText.body(
                        15,
                        color: AppColors.lightTextSecondary,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: GridView(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              mainAxisExtent: 84,
                            ),
                        children: [for (final l in languages) _tile(l)],
                      ),
                    ),
                    const SizedBox(height: 12),
                    chosen == null
                        ? Container(
                            height: 56,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.lightDisabled,
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: Text(
                              'Pick a language',
                              style: AppText.body(
                                17,
                                color: AppColors.lightTextSecondary,
                                weight: FontWeight.w700,
                              ),
                            ),
                          )
                        : GradientButton(
                            label: 'Continue in ${chosen.english}',
                            icon: Icons.arrow_forward_rounded,
                            loading: _saving,
                            onPressed: _continue,
                          ),
                    const SizedBox(height: 8),
                    if (_showCode)
                      TextField(
                        key: const ValueKey('invite-code'),
                        controller: _code,
                        textCapitalization: TextCapitalization.characters,
                        maxLength: 20,
                        style: AppText.body(16, color: AppColors.lightText, weight: FontWeight.w700),
                        decoration: InputDecoration(
                          counterText: '',
                          hintText: "Friend's invite code (optional)",
                          prefixIcon: const Icon(Icons.card_giftcard_rounded, color: AppColors.pink),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        ),
                      )
                    else
                      TextButton(
                        onPressed: () => setState(() => _showCode = true),
                        child: Text('Have an invite code?',
                            style: AppText.body(14, color: AppColors.pink, weight: FontWeight.w700)),
                      ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.auto_awesome_rounded,
                          size: 16,
                          color: AppColors.lightTextSecondary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'More languages coming soon',
                          style: AppText.body(
                            13,
                            color: AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tile(LanguageInfo l) {
    final on = _chosen == l.code;
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: on,
      button: true,
      label: l.english,
      child: GestureDetector(
        onTap: () => setState(() => _chosen = l.code),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: on ? l.tint : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: on ? l.color : const Color(0xFFE7E4F0),
              width: 2,
            ),
            boxShadow: on
                ? [
                    BoxShadow(
                      color: l.color.withValues(alpha: 0.18),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Stack(
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: l.tint,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      l.native.characters.first,
                      style: TextStyle(
                        color: l.color,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.native,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.lightText,
                            height: 1.25,
                          ),
                        ),
                        Text(
                          l.english,
                          style: AppText.body(
                            13,
                            color: AppColors.lightTextSecondary,
                            weight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (on)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFF7C3AED), Color(0xFFDB2777)],
                      ),
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
