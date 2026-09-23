import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pesu_api/api.dart';

import '../../data/session.dart';

final kycProvider = FutureProvider.autoDispose<KycState>((ref) {
  final api = ref.watch(apiProvider);
  return api.call(() => api.companion.getKyc());
});

final companionHomeProvider =
    FutureProvider.autoDispose<CompanionHome200Response>((ref) {
      final api = ref.watch(apiProvider);
      return api.call(() => api.companion.companionHome());
    });

final earningsProvider =
    FutureProvider.autoDispose<CompanionEarnings200Response>((ref) {
      final api = ref.watch(apiProvider);
      return api.call(() => api.companion.companionEarnings());
    });

/// Online/offline for a companion. While online (and the app is open) a
/// heartbeat goes to the server every 60 s; if the app is closed or killed the
/// server takes them offline within 2 minutes. (Ringing a locked phone needs
/// FCM push, which comes with the Firebase setup.)
class PresenceController extends Notifier<bool> with WidgetsBindingObserver {
  Timer? _beat;

  @override
  bool build() {
    WidgetsBinding.instance.addObserver(this);
    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(this);
      _beat?.cancel();
    });
    return false;
  }

  /// Sync with what the server says (e.g. after app start).
  void adopt(bool online) {
    if (online == state) return;
    state = online;
    online ? _startBeat() : _beat?.cancel();
  }

  Future<void> set(bool online) async {
    final api = ref.read(apiProvider);
    await api.call(
      () => api.companion.setPresence(SetPresenceRequest(online: online)),
    );
    state = online;
    online ? _startBeat() : _beat?.cancel();
  }

  void _startBeat() {
    _beat?.cancel();
    _beat = Timer.periodic(const Duration(seconds: 60), (_) async {
      final api = ref.read(apiProvider);
      try {
        await api.call(
          () => api.companion.setPresence(SetPresenceRequest(online: true)),
        );
      } catch (_) {
        /* next beat retries */
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState s) {
    if (!state) return;
    if (s == AppLifecycleState.resumed) {
      set(true).catchError((_) {});
    } else if (s == AppLifecycleState.paused) {
      _beat
          ?.cancel(); // let the server time us out rather than claim we're reachable
    }
  }
}

final presenceProvider = NotifierProvider<PresenceController, bool>(
  PresenceController.new,
);

final _inr = NumberFormat.currency(
  locale: 'en_IN',
  symbol: '₹',
  decimalDigits: 2,
);

/// 124000 paise -> "₹1,240" (Indian grouping; paise shown only when non-zero).
String rupees(int paise) => _inr.format(paise / 100).replaceAll('.00', '');

String talkTime(int seconds) {
  final h = seconds ~/ 3600, m = (seconds % 3600) ~/ 60;
  return h > 0 ? '${h}h ${m}m' : '${m}m';
}
