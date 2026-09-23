import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pesu_api/api.dart';
import 'package:share_plus/share_plus.dart';

import '../../app/theme.dart';
import '../../data/errors.dart';
import '../../data/languages.dart';
import '../../data/session.dart';
import '../../widgets/common.dart';

final shareCardProvider = FutureProvider.autoDispose<GetShareCard200Response>((
  ref,
) {
  final api = ref.read(apiProvider);
  return api.call(() => api.growth.getShareCard());
});

String shareText(GetShareCard200Response c) =>
    'Join me on Hello Dude! — talk in the language you think in. Use my code ${c.code} and get ${c.refereeCoins} free coins: ${c.link}';

/// Design: ShareCard.dc.html — story-style card, share row, privacy note.
class ShareCardScreen extends ConsumerStatefulWidget {
  const ShareCardScreen({super.key});

  @override
  ConsumerState<ShareCardScreen> createState() => _ShareCardScreenState();
}

class _ShareCardScreenState extends ConsumerState<ShareCardScreen> {
  final _cardKey = GlobalKey();
  bool _sharing = false;

  Future<void> _share(
    GetShareCard200Response c, {
    bool withImage = true,
  }) async {
    setState(() => _sharing = true);
    try {
      final files = <XFile>[];
      if (withImage) {
        final boundary =
            _cardKey.currentContext!.findRenderObject()!
                as RenderRepaintBoundary;
        final image = await boundary.toImage(pixelRatio: 3);
        final png = await image.toByteData(format: ui.ImageByteFormat.png);
        files.add(
          XFile.fromData(
            png!.buffer.asUint8List(),
            mimeType: 'image/png',
            name: 'hello-dude.png',
          ),
        );
      }
      await SharePlus.instance.share(
        ShareParams(text: shareText(c), files: files.isEmpty ? null : files),
      );
    } catch (e) {
      if (mounted) showError(context, friendlyError(e));
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(shareCardProvider);
    return Scaffold(
      body: GlowBackground(
        child: SafeArea(
          child: data.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) =>
                Center(child: Text(friendlyError(e), style: AppText.body(15))),
            data: (c) => FillScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                Row(
                  children: [
                    CircleIconButton(
                      icon: Icons.arrow_back_rounded,
                      tooltip: 'Back',
                      onPressed: () => context.pop(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Share',
                        style: AppText.heading(22),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                RepaintBoundary(
                  key: _cardKey,
                  child: ShareCard(card: c),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    _ShareButton(
                      icon: Icons.chat_rounded,
                      label: 'WhatsApp',
                      color: const Color(0xFF25D366),
                      onTap: _sharing ? null : () => _share(c),
                    ),
                    _ShareButton(
                      icon: Icons.auto_awesome_rounded,
                      label: 'Story',
                      color: const Color(0xFFDB2777),
                      onTap: _sharing ? null : () => _share(c),
                    ),
                    _ShareButton(
                      icon: Icons.link_rounded,
                      label: 'Copy link',
                      color: const Color(0xFF60A5FA),
                      onTap: () async {
                        await Clipboard.setData(
                          ClipboardData(text: shareText(c)),
                        );
                        if (context.mounted)
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Link copied')),
                          );
                      },
                    ),
                    _ShareButton(
                      icon: Icons.more_horiz_rounded,
                      label: 'More',
                      color: AppColors.lilac,
                      onTap: _sharing
                          ? null
                          : () => _share(c, withImage: false),
                    ),
                  ],
                ),
                const Spacer(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.lock_outline_rounded,
                      size: 15,
                      color: AppColors.hint,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        "Your number and who you talked to are never shown.",
                        textAlign: TextAlign.center,
                        style: AppText.body(12.5, color: AppColors.hint),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The image people share. Only today's minutes, language and the invite code.
class ShareCard extends StatelessWidget {
  const ShareCard({super.key, required this.card});
  final GetShareCard200Response card;

  @override
  Widget build(BuildContext context) {
    final lang = languageInfo(card.language).english;
    // Fixed design width, scaled to the screen, so the shared image looks the same on every phone.
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: SizedBox(width: 360, child: _card(lang)),
    );
  }

  Widget _card(String lang) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF7C3AED), Color(0xFFDB2777), Color(0xFFEA580C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const BrandMark(size: 34),
              const SizedBox(width: 10),
              Text('Hello Dude!', style: AppText.heading(20)),
            ],
          ),
          const SizedBox(height: 44),
          Text(
            card.todayMinutes > 0 ? '${card.todayMinutes} min' : 'Hi!',
            style: AppText.heading(64, spacing: -2).copyWith(height: 1),
          ),
          const SizedBox(height: 6),
          Text(
            card.todayMinutes > 0
                ? 'of good conversation in $lang today'
                : 'Come talk with me in $lang',
            style: AppText.body(18, weight: FontWeight.w600),
          ),
          const SizedBox(height: 36),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text.rich(
              TextSpan(
                style: AppText.body(15),
                children: [
                  const TextSpan(text: 'Join with my code '),
                  TextSpan(
                    text: card.code,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  TextSpan(text: ' and get ${card.refereeCoins} free coins'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Talk in the language you think in',
            style: AppText.hand(22, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _ShareButton extends StatelessWidget {
  const _ShareButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Expanded(
    child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.body(12.5, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    ),
  );
}
