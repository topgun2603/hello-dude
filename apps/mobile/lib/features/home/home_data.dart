import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pesu_api/api.dart';

import '../../data/session.dart';

export '../history/call_history.dart' show callHistoryProvider;

final walletProvider = FutureProvider.autoDispose<GetWallet200Response>((ref) {
  final api = ref.watch(apiProvider);
  return api.call(() => api.wallet.getWallet());
});

/// Who is online: in one language (Home), or everyone when null (Online tab).
final onlineCompanionsProvider = FutureProvider.autoDispose
    .family<List<OnlineCompanion>, String?>((ref, language) async {
      final api = ref.watch(apiProvider);
      final res = await api.call(
        () => api.companions.listOnlineCompanions(language: language),
      );
      return res.companions;
    });

final coinPackagesProvider =
    FutureProvider.autoDispose<List<ListCoinPackages200ResponseInner>>((ref) {
      final api = ref.watch(apiProvider);
      return api.call(() => api.wallet.listCoinPackages());
    });
