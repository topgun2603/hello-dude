import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pesu_api/api.dart';

import '../../data/session.dart';

final walletProvider = FutureProvider.autoDispose<GetWallet200Response>((ref) {
  final api = ref.watch(apiProvider);
  return api.call(() => api.wallet.getWallet());
});

final onlineCompanionsProvider = FutureProvider.autoDispose
    .family<List<OnlineCompanion>, String>((ref, language) async {
      final api = ref.watch(apiProvider);
      final res = await api.call(
        () => api.companions.listOnlineCompanions(language),
      );
      return res.companions;
    });

final coinPackagesProvider =
    FutureProvider.autoDispose<List<ListCoinPackages200ResponseInner>>((ref) {
      final api = ref.watch(apiProvider);
      return api.call(() => api.wallet.listCoinPackages());
    });

final callHistoryProvider = FutureProvider.autoDispose<List<CallSummary>>((
  ref,
) async {
  final api = ref.watch(apiProvider);
  return (await api.call(() => api.calls.listCalls())).calls;
});
