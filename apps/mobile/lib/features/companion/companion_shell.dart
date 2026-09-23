import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../data/push.dart';
import '../../data/realtime.dart';
import '../../data/session.dart';
import '../../widgets/common.dart';
import '../home/other_tabs.dart' show ProfileTab;
import 'companion_data.dart';
import 'companion_home.dart';
import 'earnings_screen.dart';
import 'incoming_screen.dart';

/// Signed-in shell for companions (green accents, per the design).
class CompanionShell extends ConsumerStatefulWidget {
  const CompanionShell({super.key});

  @override
  ConsumerState<CompanionShell> createState() => _CompanionShellState();
}

class _CompanionShellState extends ConsumerState<CompanionShell> {
  int _tab = 0;
  StreamSubscription<Map<String, dynamic>>? _events;
  String? _ringing;

  static const _tabs = [
    (Icons.home_rounded, 'Home'),
    (Icons.account_balance_wallet_outlined, 'Earnings'),
    (Icons.person_outline_rounded, 'Profile'),
  ];

  @override
  void initState() {
    super.initState();
    _events = ref.read(realtimeProvider).events.listen((e) async {
      switch (e['t']) {
        case 'incoming_call':
          await _ring(incomingFromEvent(e));
        case 'call_ended':
          ref.invalidate(companionHomeProvider);
          ref.invalidate(earningsProvider);
      }
    });
    // Accept / Decline on the native lock-screen call UI (push).
    final push = ref.read(pushProvider);
    _pushActions = push.actions.listen(_onPushAction);
    // Accepted while the app was closed: the tap launched the app.
    push.acceptedWhileClosed().then((a) {
      if (a != null) _onPushAction(a);
    });
  }

  StreamSubscription<CallAction>? _pushActions;

  Future<void> _ring(IncomingArgs args) async {
    if (_ringing == args.callId || !mounted) return;
    _ringing = args.callId;
    await context.push('/incoming', extra: args);
    _ringing = null;
    ref.invalidate(companionHomeProvider);
  }

  Future<void> _onPushAction(CallAction a) async {
    // An open incoming screen for this call handles the action itself.
    if (_ringing == a.callId) return;
    switch (a.kind) {
      case CallActionKind.accept:
        await _ring(incomingFromPush(a.callId, a.data, autoAccept: true));
      case CallActionKind.decline:
        final api = ref.read(apiProvider);
        try {
          await api.call(() => api.calls.rejectCall(a.callId));
        } catch (_) {
          /* already over */
        }
    }
  }

  @override
  void dispose() {
    _events?.cancel();
    _pushActions?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(realtimeProvider); // live connection while signed in
    ref.watch(presenceProvider);
    const pages = [CompanionHomeTab(), EarningsTab(), ProfileTab()];
    const accent = Color(0xFF6EE7B7);
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
                        onTap: () {
                          setState(() => _tab = i);
                          if (i == 1) ref.invalidate(earningsProvider);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _tabs[i].$1,
                              size: 23,
                              color: i == _tab ? accent : AppColors.navInactive,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _tabs[i].$2,
                              style: AppText.body(
                                12,
                                weight: FontWeight.w600,
                                color: i == _tab
                                    ? accent
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
