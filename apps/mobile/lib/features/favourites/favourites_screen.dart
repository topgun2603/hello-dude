import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pesu_api/api.dart';

import '../../app/theme.dart';
import '../../data/errors.dart';
import '../../data/session.dart';
import '../../widgets/common.dart';
import '../call/start_call.dart';
import '../home/home_data.dart';

final favouritesProvider = FutureProvider.autoDispose<List<Favourite>>((ref) {
  final api = ref.watch(apiProvider);
  return api.call(() => api.favourites.listFavourites());
});

/// Adds or removes a favourite, then refreshes the lists that show hearts.
Future<void> setFavourite(
  WidgetRef ref,
  String companionId,
  bool fav, {
  bool? notify,
}) async {
  final api = ref.read(apiProvider);
  if (fav) {
    await api.call(
      () => api.favourites.addFavourite(
        companionId,
        AddFavouriteRequest(notify: notify),
      ),
    );
  } else {
    await api.call(() => api.favourites.removeFavourite(companionId));
  }
  ref.invalidate(favouritesProvider);
  ref.invalidate(onlineCompanionsProvider);
}

String _lastSeen(DateTime? t) {
  if (t == null) return 'Not online recently';
  final d = DateTime.now().difference(t);
  if (d.inMinutes < 60)
    return 'Last online ${d.inMinutes.clamp(1, 59)} min ago';
  if (d.inHours < 24) return 'Last online ${d.inHours} h ago';
  if (d.inDays == 1) return 'Last online yesterday';
  return 'Last online ${d.inDays} days ago';
}

/// Design: Favourites.dc.html
class FavouritesScreen extends ConsumerWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favs = ref.watch(favouritesProvider);
    return Scaffold(
      body: GlowBackground(
        child: SafeArea(
          child: RefreshIndicator(
            color: AppColors.pink,
            onRefresh: () async => ref.invalidate(favouritesProvider),
            child: ListView(
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
                    Text('Favourites', style: AppText.heading(24)),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Call the people you liked talking to. Tap the bell to get told when they come online.',
                  style: AppText.body(
                    14,
                    color: AppColors.textMuted,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 16),
                favs.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.pink),
                    ),
                  ),
                  error: (e, _) => Text(friendlyError(e)),
                  data: (list) => list.isEmpty
                      ? Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.favorite_border_rounded,
                                color: AppColors.pinkSoft,
                                size: 36,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'No favourites yet',
                                style: AppText.body(
                                  15,
                                  weight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Tap the heart on the rating screen after a call, or next to anyone on Home.',
                                textAlign: TextAlign.center,
                                style: AppText.body(
                                  13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Column(children: [for (final f in list) _Row(f)]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Row extends ConsumerWidget {
  const _Row(this.f);
  final Favourite f;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final free = f.online && !f.busy;
    final status = f.busy
        ? 'In a call'
        : f.online
        ? 'Online now'
        : _lastSeen(f.lastOnlineAt);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Avatar(
            name: f.displayName,
            avatarId: f.avatarId,
            statusColor: f.busy
                ? AppColors.warning
                : f.online
                ? AppColors.success
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  f.displayName,
                  style: AppText.body(15.5, weight: FontWeight.w700),
                ),
                Text(
                  status,
                  style: AppText.body(
                    13,
                    color: f.online
                        ? (f.busy ? const Color(0xFFFCD34D) : AppColors.success)
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: f.notify ? 'Stop online alerts' : 'Alert me when online',
            onPressed: () => setFavourite(ref, f.id, true, notify: !f.notify)
                .catchError((Object e) {
                  if (context.mounted) showError(context, friendlyError(e));
                }),
            icon: Icon(
              f.notify
                  ? Icons.notifications_active_rounded
                  : Icons.notifications_off_outlined,
              color: f.notify
                  ? const Color(0xFFFCD34D)
                  : AppColors.textSecondary,
            ),
          ),
          Semantics(
            button: true,
            enabled: free,
            label: 'Voice call ${f.displayName}',
            child: GestureDetector(
              onTap: !free
                  ? null
                  : () => startCallFlow(
                      context,
                      ref,
                      language: f.languages.firstOrNull ?? 'ta',
                      video: false,
                      companion: OnlineCompanion(
                        id: f.id,
                        displayName: f.displayName,
                        avatarId: f.avatarId,
                        primaryLanguage: f.languages.firstOrNull ?? 'ta',
                        languages: f.languages,
                        rating: null,
                        ratingCount: 0,
                        videoEnabled: f.videoEnabled,
                        busy: f.busy,
                        isFavourite: true,
                        rates: CompanionRates(
                          audioCoinsPerMin: f.rates.audioCoinsPerMin,
                          videoCoinsPerMin: f.rates.videoCoinsPerMin,
                        ),
                      ),
                    ),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: free
                      ? const LinearGradient(
                          colors: [Color(0xFF7C3AED), Color(0xFFDB2777)],
                        )
                      : null,
                  color: free ? null : Colors.white.withValues(alpha: 0.08),
                ),
                child: Icon(
                  Icons.call_rounded,
                  size: 19,
                  color: free ? Colors.white : AppColors.hint,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Heart toggle used on Home rows.
class FavouriteHeart extends ConsumerStatefulWidget {
  const FavouriteHeart({
    super.key,
    required this.companionId,
    required this.name,
    required this.initial,
  });
  final String companionId, name;
  final bool initial;

  @override
  ConsumerState<FavouriteHeart> createState() => _FavouriteHeartState();
}

class _FavouriteHeartState extends ConsumerState<FavouriteHeart> {
  late bool _on = widget.initial;

  @override
  void didUpdateWidget(FavouriteHeart old) {
    super.didUpdateWidget(old);
    if (old.initial != widget.initial) _on = widget.initial;
  }

  @override
  Widget build(BuildContext context) => IconButton(
    visualDensity: VisualDensity.compact,
    tooltip: _on
        ? 'Remove ${widget.name} from favourites'
        : 'Add ${widget.name} to favourites',
    onPressed: () async {
      setState(() => _on = !_on);
      try {
        await setFavourite(ref, widget.companionId, _on);
      } catch (e) {
        if (mounted) {
          setState(() => _on = !_on);
          showError(context, friendlyError(e));
        }
      }
    },
    icon: AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
      child: Icon(
        _on ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        key: ValueKey(_on),
        color: _on ? AppColors.pinkSoft : AppColors.textSecondary,
        size: 22,
      ),
    ),
  );
}
