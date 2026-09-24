import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/realtime.dart';

import '../../app/theme.dart';
import '../../widgets/common.dart';
import 'home_data.dart';
import 'home_screen.dart';
import 'online_tab.dart';
import 'other_tabs.dart';
import '../growth/checkin_screen.dart';
import '../promotions/promo_sheet.dart';
import 'package:pesu_api/api.dart' show PromotionCtaActionEnum;

/// Signed-in shell with the bottom navigation from the Home design.
class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _tab = 0;
  StreamSubscription<Map<String, dynamic>>? _events;

  @override
  void initState() {
    super.initState();
    // On open: the admin's offer sheet (if any), then the daily bonus popup
    // (once per app session, if today's isn't claimed yet).
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await _showOffer();
      if (mounted) offerDailyBonus(context, ref);
    });
    // Coming back after a while counts as opening the app again.
    _lifecycle = AppLifecycleListener(
      onHide: () => _hiddenAt = DateTime.now(),
      onShow: () {
        final away = _hiddenAt == null
            ? Duration.zero
            : DateTime.now().difference(_hiddenAt!);
        _hiddenAt = null;
        // Only on the tabs themselves, never over a call or another screen.
        if (away >= reopenAfter &&
            (ModalRoute.of(context)?.isCurrent ?? false)) {
          _showOffer();
        }
      },
    );
    _events = ref
        .read(realtimeProvider)
        .events
        .where((e) => e['t'] == 'favourite_online')
        .listen((e) {
          final c = (e['companion'] as Map?) ?? const {};
          if (!mounted) return;
          ref.invalidate(onlineCompanionsProvider);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${c['displayName'] ?? 'A favourite'} is online now',
              ),
              action: SnackBarAction(
                label: 'Call',
                onPressed: () => context.push('/favourites'),
              ),
              duration: const Duration(seconds: 6),
            ),
          );
        });
  }

  late final AppLifecycleListener _lifecycle;
  DateTime? _hiddenAt;

  /// How long the app must be in the background before the offer shows again.
  static const reopenAfter = Duration(minutes: 10);

  Future<void> _showOffer() => showAppOpenPromotion(
    context,
    ref,
    onAction: (a) {
      if (!mounted) return;
      switch (a) {
        case PromotionCtaActionEnum.wallet:
          setState(() => _tab = 3);
        case PromotionCtaActionEnum.online:
          setState(() => _tab = 1);
        case PromotionCtaActionEnum.vip:
          context.push('/vip');
        case PromotionCtaActionEnum.checkin:
          context.push('/checkin');
        case PromotionCtaActionEnum.referral:
          context.push('/referral');
        case PromotionCtaActionEnum.rooms:
          context.push('/rooms');
        case PromotionCtaActionEnum.rewards:
          context.push('/rewards');
        default:
          break;
      }
    },
  );

  @override
  void dispose() {
    _lifecycle.dispose();
    _events?.cancel();
    super.dispose();
  }

  static const _tabs = [
    (Icons.home_rounded, 'Home'),
    (Icons.people_alt_rounded, 'Online'),
    (Icons.schedule_rounded, 'Calls'),
    (Icons.account_balance_wallet_outlined, 'Wallet'),
    (Icons.person_outline_rounded, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    ref.watch(
      realtimeProvider,
    ); // keeps the live connection open while signed in
    final pages = [
      HomeTab(
        onOpenWallet: () => setState(() => _tab = 3),
        onSeeAllOnline: () => setState(() => _tab = 1),
      ),
      OnlineTab(active: _tab == 1),
      const CallsTab(),
      const WalletTab(),
      const ProfileTab(),
    ];
    return Scaffold(
      body: GlowBackground(
        child: SafeArea(
          bottom: false,
          child: IndexedStack(index: _tab, children: pages),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xF50C0B1C),
          border: Border(
            top: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: Row(
              children: [
                for (var i = 0; i < _tabs.length; i++)
                  Expanded(
                    child: Semantics(
                      selected: i == _tab,
                      button: true,
                      child: InkWell(
                        onTap: () => setState(() => _tab = i),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _tabs[i].$1,
                              size: 23,
                              color: i == _tab
                                  ? AppColors.pinkSoft
                                  : AppColors.navInactive,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _tabs[i].$2,
                              style: AppText.body(
                                12,
                                weight: FontWeight.w600,
                                color: i == _tab
                                    ? AppColors.pinkSoft
                                    : AppColors.navInactive,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
