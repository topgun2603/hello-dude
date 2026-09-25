import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollDirection;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pesu_api/api.dart';

import '../../app/theme.dart';
import '../../data/errors.dart';
import '../../data/languages.dart';
import '../../data/session.dart';
import '../call/start_call.dart';
import 'home_data.dart';
import 'home_screen.dart';

/// How the Online tab orders companions.
enum OnlineSort {
  recommended('Recommended', Icons.auto_awesome_rounded),
  topRated('Top rated', Icons.star_rounded),
  mostReviewed('Most reviewed', Icons.reviews_outlined),
  lowestPrice('Lowest price', Icons.savings_outlined),
  name('Name A–Z', Icons.sort_by_alpha_rounded);

  const OnlineSort(this.label, this.icon);
  final String label;
  final IconData icon;
}

/// Search, filters and sort for the Online tab. Pure, so it's easy to test.
class OnlineFilter {
  const OnlineFilter({
    this.query = '',
    this.language,
    this.freeOnly = false,
    this.videoOnly = false,
    this.favouritesOnly = false,
    this.sort = OnlineSort.recommended,
  });

  final String query;

  /// null = every language.
  final String? language;
  final bool freeOnly, videoOnly, favouritesOnly;
  final OnlineSort sort;

  bool get isFiltered =>
      query.trim().isNotEmpty ||
      language != null ||
      freeOnly ||
      videoOnly ||
      favouritesOnly;

  OnlineFilter copyWith({
    String? query,
    String? Function()? language,
    bool? freeOnly,
    bool? videoOnly,
    bool? favouritesOnly,
    OnlineSort? sort,
  }) => OnlineFilter(
    query: query ?? this.query,
    language: language != null ? language() : this.language,
    freeOnly: freeOnly ?? this.freeOnly,
    videoOnly: videoOnly ?? this.videoOnly,
    favouritesOnly: favouritesOnly ?? this.favouritesOnly,
    sort: sort ?? this.sort,
  );

  /// Keeps the sort but drops every filter.
  OnlineFilter cleared() => OnlineFilter(sort: sort);

  List<OnlineCompanion> apply(List<OnlineCompanion> all) {
    final q = query.trim().toLowerCase();
    final out = all.where((c) {
      if (freeOnly && c.busy) return false;
      if (videoOnly && !c.videoEnabled) return false;
      if (favouritesOnly && !c.isFavourite) return false;
      if (language != null &&
          !c.languages.contains(language) &&
          c.primaryLanguage != language) {
        return false;
      }
      if (q.isNotEmpty) {
        final langs = c.languages.map(
          (l) => languageInfo(l).english.toLowerCase(),
        );
        if (!c.displayName.toLowerCase().contains(q) &&
            !langs.any((l) => l.contains(q))) {
          return false;
        }
      }
      return true;
    }).toList();

    int byRating(OnlineCompanion a, OnlineCompanion b) =>
        (b.rating ?? 0).compareTo(a.rating ?? 0);
    int byPrice(OnlineCompanion a, OnlineCompanion b) =>
        (a.rates.audioCoinsPerMin ?? 1 << 30).compareTo(
          b.rates.audioCoinsPerMin ?? 1 << 30,
        );
    int byName(OnlineCompanion a, OnlineCompanion b) =>
        a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase());
    int freeFirst(OnlineCompanion a, OnlineCompanion b) =>
        (a.busy ? 1 : 0) - (b.busy ? 1 : 0);

    out.sort(switch (sort) {
      // Free first, favourites next, then rating: who you can talk to right now.
      OnlineSort.recommended => (a, b) {
        final f = freeFirst(a, b);
        if (f != 0) return f;
        final fav = (b.isFavourite ? 1 : 0) - (a.isFavourite ? 1 : 0);
        return fav != 0 ? fav : byRating(a, b);
      },
      OnlineSort.topRated => (a, b) {
        final r = byRating(a, b);
        return r != 0 ? r : b.ratingCount.compareTo(a.ratingCount);
      },
      OnlineSort.mostReviewed => (a, b) {
        final r = b.ratingCount.compareTo(a.ratingCount);
        return r != 0 ? r : byRating(a, b);
      },
      OnlineSort.lowestPrice => (a, b) {
        final p = byPrice(a, b);
        return p != 0 ? p : freeFirst(a, b);
      },
      OnlineSort.name => byName,
    });
    return out;
  }
}

/// Bottom-nav "Online" tab: everyone online now, in every language, with search,
/// language chips, quick filters and sort.
class OnlineTab extends ConsumerStatefulWidget {
  const OnlineTab({super.key, required this.active});

  /// Only refresh on a timer while this tab is on screen.
  final bool active;

  @override
  ConsumerState<OnlineTab> createState() => _OnlineTabState();
}

class _OnlineTabState extends ConsumerState<OnlineTab> {
  final _search = TextEditingController();
  OnlineFilter _f = const OnlineFilter();
  Timer? _poll;

  /// The Random button shows its label until the list is scrolled down.
  bool _fabExpanded = true;

  @override
  void initState() {
    super.initState();
    _syncPolling();
  }

  @override
  void didUpdateWidget(OnlineTab old) {
    super.didUpdateWidget(old);
    if (old.active != widget.active) {
      if (widget.active) ref.invalidate(onlineCompanionsProvider(null));
      _syncPolling();
    }
  }

  void _syncPolling() {
    _poll?.cancel();
    _poll = widget.active
        ? Timer.periodic(
            const Duration(seconds: 15),
            (_) => ref.invalidate(onlineCompanionsProvider(null)),
          )
        : null;
  }

  @override
  void dispose() {
    _poll?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _set(OnlineFilter f) => setState(() => _f = f);

  Future<void> _pickSort() async {
    final picked = await showModalBottomSheet<OnlineSort>(
      context: context,
      backgroundColor: const Color(0xFF16142C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Sort by', style: AppText.heading(18)),
              const SizedBox(height: 8),
              for (final s in OnlineSort.values)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    s.icon,
                    color: s == _f.sort
                        ? AppColors.pinkSoft
                        : AppColors.textSecondary,
                  ),
                  title: Text(
                    s.label,
                    style: AppText.body(
                      15.5,
                      weight: FontWeight.w600,
                      color: s == _f.sort ? AppColors.pinkSoft : Colors.white,
                    ),
                  ),
                  trailing: s == _f.sort
                      ? const Icon(
                          Icons.check_rounded,
                          color: AppColors.pinkSoft,
                        )
                      : null,
                  onTap: () => Navigator.pop(ctx, s),
                ),
            ],
          ),
        ),
      ),
    );
    if (picked != null) _set(_f.copyWith(sort: picked));
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(onlineCompanionsProvider(null));
    final all = async.valueOrNull ?? const <OnlineCompanion>[];
    final myLang = ref.watch(sessionProvider).profile?.primaryLanguage;
    final shown = _f.apply(all);
    final free = all.where((c) => !c.busy).length;

    // Language chips: mine first, then any language someone online speaks.
    final counts = <String, int>{};
    for (final c in all) {
      for (final l in {...c.languages, c.primaryLanguage}) {
        counts[l] = (counts[l] ?? 0) + 1;
      }
    }
    final langs = [
      ?myLang,
      for (final l in languages.map((l) => l.code))
        if (l != myLang && counts.containsKey(l)) l,
    ];

    Future<void> refresh() async {
      ref.invalidate(onlineCompanionsProvider(null));
      await ref
          .read(onlineCompanionsProvider(null).future)
          .catchError((_) => <OnlineCompanion>[]);
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Online now',
                  style: AppText.heading(26, spacing: -0.6),
                ),
              ),
              if (async.hasValue)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: AppColors.success.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(width: 7),
                      Text(
                        '${all.length} online · $free free',
                        style: AppText.body(
                          12.5,
                          weight: FontWeight.w700,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchField(
            controller: _search,
            onChanged: (v) => _set(_f.copyWith(query: v)),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 38,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              FilterPill(
                icon: Icons.swap_vert_rounded,
                label: _f.sort.label,
                selected: _f.sort != OnlineSort.recommended,
                trailing: Icons.expand_more_rounded,
                onTap: _pickSort,
              ),
              FilterPill(
                icon: Icons.bolt_rounded,
                label: 'Free now',
                selected: _f.freeOnly,
                onTap: () => _set(_f.copyWith(freeOnly: !_f.freeOnly)),
              ),
              FilterPill(
                icon: Icons.videocam_outlined,
                label: 'Video',
                selected: _f.videoOnly,
                onTap: () => _set(_f.copyWith(videoOnly: !_f.videoOnly)),
              ),
              FilterPill(
                icon: Icons.favorite_border_rounded,
                label: 'Favourites',
                selected: _f.favouritesOnly,
                onTap: () =>
                    _set(_f.copyWith(favouritesOnly: !_f.favouritesOnly)),
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
                count: all.length,
                selected: _f.language == null,
                onTap: () => _set(_f.copyWith(language: () => null)),
              ),
              for (final l in langs)
                FilterPill(
                  label: languageInfo(l).english,
                  count: counts[l] ?? 0,
                  selected: _f.language == l,
                  onTap: () => _set(
                    _f.copyWith(language: () => _f.language == l ? null : l),
                  ),
                ),
            ],
          ),
        ),
        if (async.hasValue && _f.isFiltered)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 6, 12, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Showing ${shown.length} of ${all.length}',
                    style: AppText.body(13, color: AppColors.textSecondary),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _search.clear();
                    _set(_f.cleared());
                  },
                  child: const Text('Clear filters'),
                ),
              ],
            ),
          )
        else
          const SizedBox(height: 10),
        Expanded(
          child: Stack(
            children: [
              NotificationListener<UserScrollNotification>(
                onNotification: (n) {
                  final expand =
                      n.direction == ScrollDirection.forward ||
                      n.metrics.pixels <= 0;
                  final collapse = n.direction == ScrollDirection.reverse;
                  if (expand != collapse && expand != _fabExpanded) {
                    setState(() => _fabExpanded = expand);
                  }
                  return false;
                },
                child: RefreshIndicator(
                  color: AppColors.pink,
                  onRefresh: refresh,
                  child: async.when(
                    skipLoadingOnRefresh: true,
                    skipLoadingOnReload: true,
                    loading: () => const Center(
                      child: CircularProgressIndicator(color: AppColors.pink),
                    ),
                    error: (e, _) => ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        _Message(
                          icon: Icons.wifi_off_rounded,
                          title: friendlyError(e),
                          action: 'Try again',
                          onAction: refresh,
                        ),
                      ],
                    ),
                    data: (_) => shown.isEmpty
                        ? ListView(
                            padding: const EdgeInsets.all(20),
                            children: [
                              all.isEmpty
                                  ? const _Message(
                                      icon: Icons.nights_stay_outlined,
                                      title: 'Nobody is online right now',
                                      body:
                                          'Pull down to refresh. Favourite someone to get a ping when they come online.',
                                    )
                                  : _Message(
                                      icon: Icons.search_off_rounded,
                                      title: 'No one matches these filters',
                                      body:
                                          'Try another language or turn off a filter.',
                                      action: 'Clear filters',
                                      onAction: () {
                                        _search.clear();
                                        _set(_f.cleared());
                                      },
                                    ),
                            ],
                          )
                        : ListView.separated(
                            // Room at the bottom so the Random button never covers the last row.
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 96),
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: shown.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 10),
                            itemBuilder: (_, i) => CompanionRow(shown[i]),
                          ),
                  ),
                ),
              ),
              Positioned(
                right: 20,
                bottom: 20,
                child: RandomFab(
                  expanded: _fabExpanded,
                  onPressed: () => startCallFlow(
                    context,
                    ref,
                    language: myLang ?? 'ta',
                    video: false,
                    random: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hint = 'Search by name or language',
  });
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hint;

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, v, _) => TextField(
          controller: controller,
          onChanged: onChanged,
          textInputAction: TextInputAction.search,
          style: AppText.body(15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppText.body(15, color: AppColors.hint),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: AppColors.textSecondary,
            ),
            suffixIcon: v.text.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Clear search',
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      controller.clear();
                      onChanged('');
                    },
                  ),
            filled: true,
            fillColor: AppColors.card,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: AppColors.pinkSoft.withValues(alpha: 0.6),
              ),
            ),
          ),
        ),
      );
}

class FilterPill extends StatelessWidget {
  const FilterPill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    this.trailing,
    this.count,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon, trailing;
  final int? count;

  @override
  Widget build(BuildContext context) {
    final fg = selected ? Colors.white : AppColors.textSecondary;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Semantics(
        button: true,
        selected: selected,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              gradient: selected ? AppColors.brand : null,
              color: selected ? null : AppColors.card,
              border: Border.all(
                color: selected ? Colors.transparent : AppColors.cardBorder,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 16, color: fg),
                  const SizedBox(width: 6),
                ],
                Text(
                  label,
                  style: AppText.body(13.5, weight: FontWeight.w600, color: fg),
                ),
                if (count != null) ...[
                  const SizedBox(width: 6),
                  Text(
                    '$count',
                    style: AppText.body(
                      12.5,
                      weight: FontWeight.w700,
                      color: selected
                          ? Colors.white.withValues(alpha: 0.85)
                          : AppColors.hint,
                    ),
                  ),
                ],
                if (trailing != null) ...[
                  const SizedBox(width: 2),
                  Icon(trailing, size: 18, color: fg),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.icon,
    required this.title,
    this.body,
    this.action,
    this.onAction,
  });
  final IconData icon;
  final String title;
  final String? body, action;
  final VoidCallback? onAction;

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
        Icon(icon, color: AppColors.lilac, size: 36),
        const SizedBox(height: 10),
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppText.body(15, weight: FontWeight.w700),
        ),
        if (body != null) ...[
          const SizedBox(height: 4),
          Text(
            body!,
            textAlign: TextAlign.center,
            style: AppText.body(13, color: AppColors.textSecondary),
          ),
        ],
        if (action != null) ...[
          const SizedBox(height: 8),
          TextButton(onPressed: onAction, child: Text(action!)),
        ],
      ],
    ),
  );
}

/// Floating "Random" button: call anyone free right now, in any language.
/// Shrinks to just the icon while the list scrolls down.
class RandomFab extends StatelessWidget {
  const RandomFab({super.key, required this.expanded, required this.onPressed});
  final bool expanded;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: 'Random call: talk to anyone online now',
    excludeSemantics: true,
    child: Material(
      color: Colors.transparent,
      shape: const StadiumBorder(),
      elevation: 10,
      shadowColor: AppColors.pink.withValues(alpha: 0.6),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onPressed,
        child: Ink(
          height: 58,
          decoration: const ShapeDecoration(
            shape: StadiumBorder(),
            gradient: AppColors.brand,
          ),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: expanded ? 20 : 17),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.shuffle_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                  if (expanded) ...[
                    const SizedBox(width: 10),
                    Text(
                      'Random',
                      style: AppText.heading(16.5, weight: FontWeight.w700),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
