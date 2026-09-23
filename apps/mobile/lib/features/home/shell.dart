import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/realtime.dart';

import '../../app/theme.dart';
import '../../widgets/common.dart';
import 'home_data.dart';
import 'home_screen.dart';
import 'other_tabs.dart';
import '../growth/checkin_screen.dart';

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
    // Daily bonus popup, once per app session, if today's isn't claimed yet.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) offerDailyBonus(context, ref);
    });
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

  @override
  void dispose() {
    _events?.cancel();
    super.dispose();
  }

  static const _tabs = [
    (Icons.home_rounded, 'Home'),
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
      HomeTab(onOpenWallet: () => setState(() => _tab = 2)),
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
