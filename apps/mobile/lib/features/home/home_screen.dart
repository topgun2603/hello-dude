import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pesu_api/api.dart';

import '../../app/theme.dart';
import '../../data/errors.dart';
import '../../data/languages.dart';
import '../../data/session.dart';
import '../../widgets/common.dart';
import '../call/start_call.dart';
import 'package:go_router/go_router.dart';

import '../favourites/favourites_screen.dart';
import 'home_data.dart';
import 'offer_banner.dart';
import '../growth/leaderboard_screen.dart' show BadgeChip, CurrentEventBanner;
import '../live/live_data.dart' show LiveNowRow;
import '../group/group_data.dart' show GroupVideoCard;
import '../notifications/notifications_screen.dart';
import '../rooms/rooms_screens.dart';
import '../chat/chat_screens.dart' show openChatWith;

/// Design: Home.dc.html — coin chip, greeting, Instant match, Online now.
class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({
    super.key,
    required this.onOpenWallet,
    this.onSeeAllOnline,
    this.onSeeAllLive,
  });
  final VoidCallback onOpenWallet;

  /// Opens the Live tab.
  final VoidCallback? onSeeAllLive;

  /// Opens the Online tab (search, filters, sort).
  final VoidCallback? onSeeAllOnline;

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  Timer? _poll;

  @override
  void initState() {
    super.initState();
    // Presence changes constantly; refresh the list every 15 s while Home is open.
    _poll = Timer.periodic(
      const Duration(seconds: 15),
      (_) => ref.invalidate(onlineCompanionsProvider),
    );
  }

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(sessionProvider).profile!;
    final lang = languageInfo(profile.primaryLanguage);
    final companions = ref.watch(onlineCompanionsProvider(lang.code));
    final coins = ref.watch(walletProvider).valueOrNull?.coins;

    // The top bar stays put; only the content below it scrolls.
    final topBar = Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
      child: Row(
        children: [
          const Expanded(
            child: Align(alignment: Alignment.centerLeft, child: BrandTitle()),
          ),
          _CoinChip(coins: coins, onTap: widget.onOpenWallet),
          const SizedBox(width: 8),
          const NotificationBell(),
          const SizedBox(width: 8),
          CircleIconButton(
            icon: Icons.favorite_border_rounded,
            tooltip: 'Favourites',
            onPressed: () => context.push('/favourites'),
          ),
        ],
      ),
    );

    return Column(
      children: [
        topBar,
        Expanded(
          child: RefreshIndicator(
            color: AppColors.pink,
            onRefresh: () async {
              ref.invalidate(walletProvider);
              ref.invalidate(onlineCompanionsProvider);
              await ref
                  .read(onlineCompanionsProvider(lang.code).future)
                  .catchError((_) => <OnlineCompanion>[]);
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Find your vibe',
                        style: AppText.heading(26, spacing: -0.6),
                      ),
                    ),
                    _LanguageChip(current: lang),
                  ],
                ),
                const SizedBox(height: 18),
                const OfferBanner(),
                const CurrentEventBanner(),
                LiveNowRow(onSeeAll: widget.onSeeAllLive),
                _InstantMatchCard(language: lang),
                const SizedBox(height: 14),
                const GroupVideoCard(),
                const SizedBox(height: 14),
                const VoiceRoomsCard(),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.success,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.success.withValues(alpha: 0.3),
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Online now',
                      style: AppText.heading(17, weight: FontWeight.w700),
                    ),
                    const Spacer(),
                    if (widget.onSeeAllOnline != null)
                      TextButton(
                        onPressed: widget.onSeeAllOnline,
                        child: Text(
                          (companions.valueOrNull?.isNotEmpty ?? false)
                              ? '${companions.value!.length} online · See all'
                              : 'See all',
                          style: AppText.body(
                            14,
                            color: const Color(0xFFF9A8D4),
                            weight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                companions.when(
                  data: (list) => list.isEmpty
                      ? _EmptyState(language: lang.english)
                      : Column(
                          children: [
                            // A short preview; the Online tab has everyone.
                            for (final c in list.take(3))
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: CompanionRow(c),
                              ),
                            if (list.length > 3 &&
                                widget.onSeeAllOnline != null)
                              OutlinedButton.icon(
                                onPressed: widget.onSeeAllOnline,
                                icon: const Icon(
                                  Icons.people_alt_outlined,
                                  size: 18,
                                ),
                                label: Text('See all ${list.length} online'),
                              ),
                          ],
                        ),
                  loading: () => const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.pink),
                    ),
                  ),
                  error: (e, _) => _ErrorCard(
                    message: friendlyError(e),
                    onRetry: () => ref.invalidate(onlineCompanionsProvider),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CoinChip extends StatelessWidget {
  const _CoinChip({required this.coins, required this.onTap});
  final int? coins;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: 'Coin balance ${coins ?? 0}, add coins',
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.fromLTRB(10, 0, 6, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withValues(alpha: 0.08),
          border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
        ),
        child: Row(
          children: [
            const CoinIcon(size: 20),
            const SizedBox(width: 8),
            Text(
              coins?.toString() ?? '–',
              style: AppText.body(15, weight: FontWeight.w700),
            ),
            const SizedBox(width: 8),
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFFDB2777), Color(0xFFEA580C)],
                ),
              ),
              child: const Icon(
                Icons.add_rounded,
                size: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class CoinIcon extends StatelessWidget {
  const CoinIcon({super.key, this.size = 20});
  final double size;

  /// The brand coin (masters in design/brand/).
  @override
  Widget build(BuildContext context) => Image.asset(
    'assets/images/coin.png',
    width: size,
    height: size,
    filterQuality: FilterQuality.medium,
    excludeFromSemantics: true,
  );
}

/// Pile of brand coins, for balance and offer cards.
class CoinStack extends StatelessWidget {
  const CoinStack({super.key, this.width = 120});
  final double width;

  @override
  Widget build(BuildContext context) => Image.asset(
    'assets/images/coin_stack.png',
    width: width,
    filterQuality: FilterQuality.medium,
    excludeFromSemantics: true,
  );
}

class _LanguageChip extends ConsumerWidget {
  const _LanguageChip({required this.current});
  final LanguageInfo current;

  Future<void> _change(BuildContext context, WidgetRef ref) async {
    final picked = await pickLanguage(context, current);
    if (picked == null || picked == current.code) return;
    final api = ref.read(apiProvider);
    try {
      final profile = await api.call(
        () => api.profile.updateMe(UpdateMeRequest(primaryLanguage: picked)),
      );
      await ref.read(sessionProvider.notifier).setProfile(profile);
    } catch (e) {
      if (context.mounted) showError(context, friendlyError(e));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => Semantics(
    button: true,
    label: 'Change language, current ${current.english}',
    child: GestureDetector(
      onTap: () => _change(context, ref),
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: const Color(0x29C084FC),
          border: Border.all(color: const Color(0x73C084FC)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              current.native,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: Color(0xFFE9D5FF),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Bottom sheet listing every language; returns the chosen code (or null).
Future<String?> pickLanguage(BuildContext context, LanguageInfo current) {
  return showModalBottomSheet<String>(
    context: context,
    // Eight languages don't fit the default half-height sheet on most phones:
    // let it grow to 85% of the screen and scroll beyond that.
    isScrollControlled: true,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.sizeOf(context).height * 0.85,
    ),
    backgroundColor: const Color(0xFF16142C),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Text('Talk in', style: AppText.heading(18)),
          const SizedBox(height: 8),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 8),
              children: [
                for (final l in languages)
                  ListTile(
                    key: ValueKey('lang-${l.code}'),
                    title: Text(
                      l.native,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(l.english),
                    trailing: l.code == current.code
                        ? const Icon(
                            Icons.check_rounded,
                            color: AppColors.pinkSoft,
                          )
                        : null,
                    onTap: () => Navigator.pop(context, l.code),
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _InstantMatchCard extends ConsumerWidget {
  const _InstantMatchCard({required this.language});
  final LanguageInfo language;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Container(
    constraints: const BoxConstraints(minHeight: 196),
    padding: const EdgeInsets.all(20),
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(28),
      gradient: AppColors.instantMatch,
      boxShadow: const [
        BoxShadow(
          color: Color(0x59C026D3),
          blurRadius: 40,
          offset: Offset(0, 16),
        ),
      ],
    ),
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          right: -60,
          top: -50,
          child: Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.22),
                width: 1.5,
              ),
            ),
          ),
        ),
        Positioned(
          right: -30,
          top: -20,
          child: Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'INSTANT MATCH',
              style: AppText.body(
                12,
                color: const Color(0xFFFCE7F3),
                weight: FontWeight.w700,
              ).copyWith(letterSpacing: 1),
            ),
            const SizedBox(height: 6),
            Text(
              'Talk to someone now',
              style: AppText.heading(24, spacing: -0.5),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(right: 60),
              child: Text(
                "We'll connect you with an online ${language.english} speaker in seconds.",
                style: AppText.body(
                  14,
                  color: const Color(0xFFFDF2F8),
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _pill(
                    context,
                    ref,
                    'Voice call',
                    Icons.mic_none_rounded,
                    solid: true,
                    video: false,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _pill(
                    context,
                    ref,
                    'Video call',
                    Icons.videocam_outlined,
                    solid: false,
                    video: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );

  Widget _pill(
    BuildContext context,
    WidgetRef ref,
    String label,
    IconData icon, {
    required bool solid,
    required bool video,
  }) => Material(
    color: solid ? Colors.white : Colors.white.withValues(alpha: 0.14),
    shape: StadiumBorder(
      side: solid
          ? BorderSide.none
          : BorderSide(color: Colors.white.withValues(alpha: 0.6), width: 1.5),
    ),
    child: InkWell(
      customBorder: const StadiumBorder(),
      onTap: () =>
          startCallFlow(context, ref, language: language.code, video: video),
      child: SizedBox(
        height: 46,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: solid ? const Color(0xFF4C1D95) : Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppText.body(
                15,
                weight: FontWeight.w700,
                color: solid ? const Color(0xFF4C1D95) : Colors.white,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class CompanionRow extends ConsumerWidget {
  const CompanionRow(this.c, {super.key});
  final OnlineCompanion c;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busy = c.busy;
    void call(bool video) => startCallFlow(
      context,
      ref,
      companion: c,
      language: c.primaryLanguage,
      video: video,
    );
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Avatar(
            name: c.displayName,
            avatarId: c.avatarId,
            photoUrl: c.photoUrl,
            statusColor: busy ? AppColors.warning : AppColors.success,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        c.displayName,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.body(15.5, weight: FontWeight.w700),
                      ),
                    ),
                    if (c.rating != null) ...[
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: Color(0xFFFCD34D),
                      ),
                      Text(
                        c.rating!.toStringAsFixed(1),
                        style: AppText.body(
                          12.5,
                          color: const Color(0xFFFCD34D),
                          weight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
                if (c.badge != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: BadgeChip(badge: c.badge!),
                  ),
                const SizedBox(height: 2),
                Text(
                  busy
                      ? 'In a call'
                      : [
                          languageNames(c.languages),
                          if (c.rates.audioCoinsPerMin != null)
                            '${c.rates.audioCoinsPerMin} coins/min',
                        ].join(' · '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.body(
                    13,
                    color: busy
                        ? const Color(0xFFFCD34D)
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          FavouriteHeart(
            companionId: c.id,
            name: c.displayName,
            initial: c.isFavourite,
          ),
          // Chat if you've talked; otherwise a message request.
          _roundCall(
            context,
            Icons.chat_bubble_outline_rounded,
            'Message ${c.displayName}',
            gradient: false,
            onTap: () => openChatWith(context, ref, c.id, name: c.displayName),
          ),
          const SizedBox(width: 8),
          _roundCall(
            context,
            Icons.call_rounded,
            'Voice call ${c.displayName}',
            gradient: !busy && c.audioEnabled,
            onTap: busy || !c.audioEnabled ? null : () => call(false),
          ),
          const SizedBox(width: 8),
          _roundCall(
            context,
            Icons.videocam_outlined,
            'Video call ${c.displayName}',
            gradient: false,
            onTap: busy || !c.videoEnabled ? null : () => call(true),
          ),
        ],
      ),
    );
  }

  Widget _roundCall(
    BuildContext context,
    IconData icon,
    String label, {
    required bool gradient,
    VoidCallback? onTap,
  }) => Semantics(
    button: true,
    enabled: onTap != null,
    label: label,
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: gradient
              ? const LinearGradient(
                  colors: [Color(0xFF7C3AED), Color(0xFFDB2777)],
                )
              : null,
          color: gradient
              ? null
              : Colors.white.withValues(alpha: onTap == null ? 0.12 : 0.06),
          border: gradient
              ? null
              : Border.all(color: Colors.white.withValues(alpha: 0.18)),
        ),
        child: Icon(
          icon,
          size: 19,
          color: onTap == null ? AppColors.hint : Colors.white,
        ),
      ),
    ),
  );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.language});
  final String language;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.cardBorder),
    ),
    child: Column(
      children: [
        const Icon(
          Icons.nights_stay_outlined,
          color: AppColors.lilac,
          size: 36,
        ),
        const SizedBox(height: 10),
        Text(
          'Nobody is online in $language right now',
          textAlign: TextAlign.center,
          style: AppText.body(15, weight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          'Pull down to refresh, or try another language.',
          textAlign: TextAlign.center,
          style: AppText.body(13, color: AppColors.textSecondary),
        ),
      ],
    ),
  );
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.danger.withValues(alpha: 0.4)),
    ),
    child: Column(
      children: [
        Text(
          message,
          textAlign: TextAlign.center,
          style: AppText.body(14, color: AppColors.textMuted),
        ),
        const SizedBox(height: 10),
        TextButton(onPressed: onRetry, child: const Text('Try again')),
      ],
    ),
  );
}
