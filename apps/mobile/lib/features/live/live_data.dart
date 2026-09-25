import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pesu_api/api.dart';

import '../../app/theme.dart';
import '../../data/api.dart';
import '../../data/realtime.dart';
import '../../data/session.dart';
import '../../widgets/common.dart';

/// How the Live tab asks for lives (server-side sort, filters and search).
class LiveQuery {
  const LiveQuery({
    this.sort = LiveSort.forYou,
    this.language,
    this.favourites = false,
    this.q = '',
  });
  final LiveSort sort;
  final String? language;
  final bool favourites;
  final String q;

  LiveQuery copyWith({
    LiveSort? sort,
    String? Function()? language,
    bool? favourites,
    String? q,
  }) => LiveQuery(
    sort: sort ?? this.sort,
    language: language != null ? language() : this.language,
    favourites: favourites ?? this.favourites,
    q: q ?? this.q,
  );

  @override
  bool operator ==(Object o) =>
      o is LiveQuery &&
      o.sort == sort &&
      o.language == language &&
      o.favourites == favourites &&
      o.q == q;

  @override
  int get hashCode => Object.hash(sort, language, favourites, q);
}

enum LiveSort {
  forYou('for_you', 'For you', Icons.auto_awesome_rounded),
  popular('popular', 'Popular', Icons.local_fire_department_rounded),
  newest('new', 'New', Icons.fiber_new_rounded);

  const LiveSort(this.api, this.label, this.icon);
  final String api, label;
  final IconData icon;
}

/// One page of lives for [q].
Future<ListLives200Response> fetchLives(
  PesuApi api,
  LiveQuery q, {
  int offset = 0,
  int limit = 30,
}) => api.call(
  () => api.lives.listLives(
    sort: q.sort.api,
    language: q.language,
    favourites: q.favourites ? 'true' : null,
    q: q.q.trim().isEmpty ? null : q.q.trim(),
    limit: limit,
    offset: offset,
  ),
);

/// Home row: the top 10 for this caller, plus how many are live in all.
final livesProvider = FutureProvider.autoDispose<ListLives200Response>((
  ref,
) async {
  return fetchLives(ref.watch(apiProvider), const LiveQuery(), limit: 10);
});

/// What the swipe feed starts from: the list the caller was looking at (same
/// order and filters), so swiping continues through it and loads more.
class LiveFeedArgs {
  const LiveFeedArgs({
    this.startId,
    this.initial,
    this.total,
    this.query = const LiveQuery(),
  });
  final String? startId;
  final List<LiveCard>? initial;
  final int? total;
  final LiveQuery query;
}

/// `live_event`s for one live, as sent by routes/lives.ts.
extension LiveEvents on Realtime {
  Stream<Map<String, dynamic>> forLive(String liveId) => events
      .where((e) => e['t'] == 'live_event' && e['liveId'] == liveId)
      .map((e) => (e['event'] as Map).cast<String, dynamic>());
}

/// "4:07" or "1:02:15".
String clockLeft(Duration d) {
  if (d.isNegative) return '0:00';
  String two(int n) => n.toString().padLeft(2, '0');
  final h = d.inHours, m = d.inMinutes % 60, s = d.inSeconds % 60;
  return h > 0 ? '$h:${two(m)}:${two(s)}' : '$m:${two(s)}';
}

/// Pulsing red "LIVE" pill.
class LiveBadge extends StatefulWidget {
  const LiveBadge({super.key, this.small = false});
  final bool small;

  @override
  State<LiveBadge> createState() => _LiveBadgeState();
}

class _LiveBadgeState extends State<LiveBadge>
    with SingleTickerProviderStateMixin {
  late final _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(
      horizontal: widget.small ? 6 : 9,
      vertical: widget.small ? 2 : 4,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(999),
      gradient: const LinearGradient(
        colors: [Color(0xFFE11D48), Color(0xFFDB2777)],
      ),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FadeTransition(
          opacity: Tween(begin: 0.35, end: 1.0).animate(_c),
          child: Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          'LIVE',
          style: AppText.body(
            widget.small ? 9.5 : 11,
            weight: FontWeight.w800,
          ).copyWith(letterSpacing: 0.8),
        ),
      ],
    ),
  );
}

/// Home: a stories-style row of companions who are live, or a small card when nobody is.
class LiveNowRow extends ConsumerStatefulWidget {
  const LiveNowRow({super.key, this.onSeeAll});

  /// Opens the Live tab.
  final VoidCallback? onSeeAll;

  @override
  ConsumerState<LiveNowRow> createState() => _LiveNowRowState();
}

class _LiveNowRowState extends ConsumerState<LiveNowRow> {
  Timer? _poll;

  @override
  void initState() {
    super.initState();
    _poll = Timer.periodic(
      const Duration(seconds: 20),
      (_) => ref.invalidate(livesProvider),
    );
  }

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(livesProvider).valueOrNull;
    final lives = data?.lives ?? const <LiveCard>[];
    if (lives.isEmpty) return const _NobodyLive();
    void open(String id) => context.push(
      '/live',
      extra: LiveFeedArgs(startId: id, initial: lives, total: data!.total),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const LiveBadge(),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Live now',
                  style: AppText.heading(17, weight: FontWeight.w700),
                ),
              ),
              TextButton(
                onPressed: widget.onSeeAll ?? () => open(lives.first.id),
                child: Text(
                  widget.onSeeAll != null
                      ? 'See all ${data!.total} →'
                      : 'Watch',
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 104,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: lives.length,
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (_, i) {
                final l = lives[i];
                return Semantics(
                  button: true,
                  label:
                      '${l.host.displayName} is live: ${l.title}. ${l.viewers} watching',
                  excludeSemantics: true,
                  child: GestureDetector(
                    onTap: () => open(l.id),
                    child: SizedBox(
                      width: 72,
                      child: Column(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.bottomCenter,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFE11D48),
                                      Color(0xFFDB2777),
                                      Color(0xFF7C3AED),
                                    ],
                                  ),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.background,
                                  ),
                                  child: Avatar(
                                    key: ValueKey(l.host.photoUrl),
                                    name: l.host.displayName,
                                    avatarId: l.host.avatarId,
                                    photoUrl: l.host.photoUrl,
                                    size: 58,
                                  ),
                                ),
                              ),
                              const Positioned(
                                bottom: -6,
                                child: LiveBadge(small: true),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            l.host.displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.body(12.5, weight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Shown on Home while nobody is live, so people know Live exists.
class _NobodyLive extends StatelessWidget {
  const _NobodyLive();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFE11D48).withValues(alpha: 0.16),
            ),
            child: const Icon(Icons.live_tv_rounded, color: Color(0xFFFDA4AF)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Live', style: AppText.heading(16)),
                    const SizedBox(width: 8),
                    const LiveBadge(small: true),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Nobody is live right now. Favourite companions to get a ping when they go live.',
                  style: AppText.body(12.5, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/// A heart that floats up and fades (someone sent a heart).
class FloatingHeart extends StatelessWidget {
  const FloatingHeart({super.key, required this.seed});
  final int seed;

  @override
  Widget build(BuildContext context) {
    final drift = (Random(seed).nextDouble() - 0.5) * 60;
    return Positioned(
      right: 30,
      bottom: 90,
      child: IgnorePointer(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 1700),
          curve: Curves.easeOut,
          builder: (_, t, _) => Transform.translate(
            offset: Offset(drift * t, -260 * t),
            child: Opacity(
              opacity: (1 - t).clamp(0, 1),
              child: Transform.scale(
                scale: 0.8 + t * 0.6,
                child: const Icon(
                  Icons.favorite_rounded,
                  color: Color(0xFFF472B6),
                  size: 30,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Chat over live video: newest line at the bottom and the list sticks there as
/// messages arrive; swipe up to read older ones. The top edge fades out so the
/// video stays visible.
class LiveChatOverlay extends StatelessWidget {
  const LiveChatOverlay({
    super.key,
    required this.count,
    required this.itemBuilder,
    this.height = 220,
  });
  final int count;

  /// Builds line [index], 0 = oldest.
  final Widget Function(BuildContext context, int index) itemBuilder;
  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    child: ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: (rect) => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.transparent, Colors.white],
        stops: [0, 0.18],
      ).createShader(rect),
      child: ListView.builder(
        reverse: true,
        padding: const EdgeInsets.only(top: 28),
        itemCount: count,
        itemBuilder: (context, i) => itemBuilder(context, count - 1 - i),
      ),
    ),
  );
}
