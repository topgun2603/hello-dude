import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pesu_api/api.dart';

import '../../app/theme.dart';
import '../../data/errors.dart';
import '../../data/languages.dart';
import '../../data/session.dart';
import '../../widgets/common.dart';
import '../home/online_tab.dart' show FilterPill, SearchField;
import 'live_data.dart';

/// Bottom-nav "Live" tab: every companion live now, as a grid of snapshot
/// cards, with sort, favourites, language chips and search (all server-side),
/// loading more as you scroll. Tapping a card opens the swipe feed in the same
/// order.
class LiveTab extends ConsumerStatefulWidget {
  const LiveTab({super.key, required this.active});

  /// Only refresh on a timer while this tab is on screen.
  final bool active;

  @override
  ConsumerState<LiveTab> createState() => _LiveTabState();
}

class _LiveTabState extends ConsumerState<LiveTab> {
  static const _page = 20;

  final _search = TextEditingController();
  final _scroll = ScrollController();
  LiveQuery _q = const LiveQuery();
  List<LiveCard> _lives = const [];
  int _total = 0;
  bool _loading = true, _loadingMore = false;
  Object? _error;
  Timer? _poll, _debounce;
  int _seq = 0; // drops answers to an older query

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.extentAfter < 600) _more();
    });
    _reload();
    _syncPolling();
  }

  @override
  void didUpdateWidget(LiveTab old) {
    super.didUpdateWidget(old);
    if (old.active != widget.active) {
      if (widget.active) _refresh();
      _syncPolling();
    }
  }

  @override
  void dispose() {
    _poll?.cancel();
    _debounce?.cancel();
    _search.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _syncPolling() {
    _poll?.cancel();
    _poll = widget.active
        ? Timer.periodic(const Duration(seconds: 20), (_) => _refresh())
        : null;
  }

  void _set(LiveQuery q) {
    if (q == _q) return;
    setState(() => _q = q);
    _reload();
  }

  /// New query: start from the first page.
  Future<void> _reload() async {
    final seq = ++_seq;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final r = await fetchLives(ref.read(apiProvider), _q, limit: _page);
      if (!mounted || seq != _seq) return;
      setState(() {
        _lives = r.lives;
        _total = r.total;
        _loading = false;
      });
    } catch (e) {
      if (!mounted || seq != _seq) return;
      setState(() {
        _error = e;
        _loading = false;
      });
    }
  }

  /// Same query, fresh numbers: reload what's already on screen.
  Future<void> _refresh() async {
    final seq = _seq;
    try {
      final r = await fetchLives(
        ref.read(apiProvider),
        _q,
        limit: _lives.length.clamp(_page, 100),
      );
      if (!mounted || seq != _seq) return;
      setState(() {
        _lives = r.lives;
        _total = r.total;
        _error = null;
      });
    } catch (_) {
      /* keep what we have */
    }
  }

  Future<void> _more() async {
    if (_loading || _loadingMore || _lives.length >= _total) return;
    final seq = _seq;
    setState(() => _loadingMore = true);
    try {
      final r = await fetchLives(
        ref.read(apiProvider),
        _q,
        offset: _lives.length,
        limit: _page,
      );
      if (!mounted || seq != _seq) return;
      setState(() {
        _lives = [
          ..._lives,
          for (final l in r.lives)
            if (!_lives.any((x) => x.id == l.id)) l,
        ];
        _total = r.total;
      });
    } catch (_) {
      /* the next scroll tries again */
    } finally {
      if (mounted) setState(() => _loadingMore = false);
    }
  }

  void _open(LiveCard l) => context.push(
    '/live',
    extra: LiveFeedArgs(
      startId: l.id,
      initial: _lives,
      total: _total,
      query: _q,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final myLang = ref.watch(sessionProvider).profile?.primaryLanguage;
    final langs = [
      ?myLang,
      for (final l in languages)
        if (l.code != myLang) l.code,
    ];
    final filtered =
        _q.language != null || _q.favourites || _q.q.trim().isNotEmpty;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Live now',
                  style: AppText.heading(26, spacing: -0.6),
                ),
              ),
              if (!_loading) _Count(total: _total),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchField(
            controller: _search,
            hint: 'Search by name or title',
            onChanged: (v) {
              _debounce?.cancel();
              _debounce = Timer(
                const Duration(milliseconds: 350),
                () => _set(_q.copyWith(q: v)),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 38,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              for (final s in LiveSort.values)
                FilterPill(
                  icon: s.icon,
                  label: s.label,
                  selected: _q.sort == s,
                  onTap: () => _set(_q.copyWith(sort: s)),
                ),
              FilterPill(
                icon: Icons.favorite_border_rounded,
                label: 'Favourites',
                selected: _q.favourites,
                onTap: () => _set(_q.copyWith(favourites: !_q.favourites)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 38,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              FilterPill(
                label: 'All languages',
                selected: _q.language == null,
                onTap: () => _set(_q.copyWith(language: () => null)),
              ),
              for (final l in langs)
                FilterPill(
                  label: languageInfo(l).english,
                  selected: _q.language == l,
                  onTap: () => _set(
                    _q.copyWith(language: () => _q.language == l ? null : l),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: RefreshIndicator(
            color: AppColors.pink,
            onRefresh: _refresh,
            child: _body(filtered),
          ),
        ),
      ],
    );
  }

  Widget _body(bool filtered) {
    if (_loading)
      return const Center(
        child: CircularProgressIndicator(color: AppColors.pink),
      );
    if (_error != null && _lives.isEmpty) {
      return ListView(
        children: [
          _Message(icon: Icons.wifi_off_rounded, text: friendlyError(_error!)),
        ],
      );
    }
    if (_lives.isEmpty) {
      return ListView(
        children: [
          _Message(
            icon: Icons.live_tv_rounded,
            text: filtered
                ? 'Nobody matches right now. Try another language or clear the search.'
                : 'Nobody is live right now. Favourite companions to get a ping when they go live.',
          ),
        ],
      );
    }
    return GridView.builder(
      controller: _scroll,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 3 / 4.3,
      ),
      itemCount: _lives.length + (_loadingMore ? 1 : 0),
      itemBuilder: (_, i) => i >= _lives.length
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.pink),
            )
          : LiveGridCard(card: _lives[i], onTap: () => _open(_lives[i])),
    );
  }
}

class _Count extends StatelessWidget {
  const _Count({required this.total});
  final int total;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: AppColors.danger.withValues(alpha: 0.14),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: AppColors.danger.withValues(alpha: 0.4)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const LiveBadge(small: true),
        const SizedBox(width: 7),
        Text(
          '$total live',
          style: AppText.body(
            12.5,
            weight: FontWeight.w700,
            color: const Color(0xFFFDA4AF),
          ),
        ),
      ],
    ),
  );
}

class _Message extends StatelessWidget {
  const _Message({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(32, 60, 32, 0),
    child: Column(
      children: [
        Icon(icon, size: 44, color: AppColors.lilac),
        const SizedBox(height: 12),
        Text(
          text,
          textAlign: TextAlign.center,
          style: AppText.body(
            14.5,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
      ],
    ),
  );
}

/// Portrait card: the live's latest snapshot (else the host's photo/avatar),
/// LIVE badge, viewers, name, language and title.
class LiveGridCard extends StatelessWidget {
  const LiveGridCard({super.key, required this.card, required this.onTap});
  final LiveCard card;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = card;
    final fallback = ColoredBox(
      color: const Color(0xFF1E1B3A),
      child: Center(
        child: Avatar(
          name: c.host.displayName,
          avatarId: c.host.avatarId,
          photoUrl: c.host.photoUrl,
          size: 84,
        ),
      ),
    );
    return Semantics(
      button: true,
      label: '${c.host.displayName} is live: ${c.title}. ${c.viewers} watching',
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (c.snapshotUrl != null)
                Image.network(
                  Avatar.photoSrc(c.snapshotUrl!),
                  fit: BoxFit.cover,
                  gaplessPlayback:
                      true, // no flash when a newer snapshot arrives
                  errorBuilder: (_, _, _) => fallback,
                  frameBuilder: (_, child, frame, sync) =>
                      frame == null && !sync ? fallback : child,
                )
              else
                fallback,
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x66000000),
                      Colors.transparent,
                      Color(0xE6000000),
                    ],
                    stops: [0, 0.35, 1],
                  ),
                ),
              ),
              Positioned(
                left: 8,
                top: 8,
                right: 8,
                child: Row(
                  children: [
                    const LiveBadge(small: true),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.visibility_outlined,
                            size: 12,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            compactCount(c.viewers),
                            style: AppText.body(11, weight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 10,
                right: 10,
                bottom: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            c.host.displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.heading(14.5),
                          ),
                        ),
                        if (c.host.isFavourite) ...[
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.favorite_rounded,
                            size: 13,
                            color: Color(0xFFF472B6),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      '${languageInfo(c.language).english} · ${c.title}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.body(12, color: Colors.white70),
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
}

/// 950 → "950", 1234 → "1.2K".
String compactCount(int n) {
  if (n < 1000) return '$n';
  final k = n / 1000;
  return '${k >= 10 ? k.round() : (k * 10).round() / 10}K'.replaceAll(
    '.0K',
    'K',
  );
}
