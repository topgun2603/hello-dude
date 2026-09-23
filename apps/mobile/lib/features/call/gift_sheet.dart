import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pesu_api/api.dart';

import '../../app/theme.dart';
import '../../data/errors.dart';
import '../../data/ids.dart';
import '../../data/session.dart';
import '../../widgets/common.dart';
import '../home/home_data.dart';
import '../home/home_screen.dart' show CoinIcon;

final giftsProvider = FutureProvider<List<Gift>>((ref) {
  final api = ref.watch(apiProvider);
  return api.call(() => api.calls.listGifts());
});

/// Design: Gifts.dc.html — grid of gifts, balance, "Send Rose · 10 coins".
Future<Gift?> showGiftSheet(
  BuildContext context, {
  required String callId,
  required String toName,
}) {
  return showModalBottomSheet<Gift>(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFF16142C),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _GiftSheet(callId: callId, toName: toName),
  );
}

class _GiftSheet extends ConsumerStatefulWidget {
  const _GiftSheet({required this.callId, required this.toName});
  final String callId, toName;

  @override
  ConsumerState<_GiftSheet> createState() => _GiftSheetState();
}

class _GiftSheetState extends ConsumerState<_GiftSheet> {
  Gift? _picked;
  bool _sending = false;
  String? _clientRef; // stays the same while retrying one send

  Future<void> _send() async {
    final g = _picked!;
    setState(() => _sending = true);
    _clientRef ??= uuidV4();
    final api = ref.read(apiProvider);
    try {
      await api.call(
        () => api.calls.sendGift(
          widget.callId,
          SendGiftRequest(giftId: g.id, clientRef: _clientRef!),
        ),
      );
      ref.invalidate(walletProvider);
      if (mounted) Navigator.pop(context, g);
    } catch (e) {
      if (!mounted) return;
      setState(() => _sending = false);
      showError(
        context,
        errorCode(e) == 'INSUFFICIENT_BALANCE'
            ? 'Not enough coins for a ${g.name}'
            : friendlyError(e),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final gifts = ref.watch(giftsProvider);
    final coins = ref.watch(walletProvider).valueOrNull?.coins;
    return SafeArea(
      // Scrolls on short screens instead of overflowing.
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Send ${widget.toName} a gift',
                    style: AppText.heading(20),
                  ),
                ),
                const CoinIcon(size: 18),
                const SizedBox(width: 6),
                Text(
                  '${coins ?? '–'}',
                  style: AppText.body(15, weight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 16),
            gifts.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.pink),
                ),
              ),
              error: (e, _) => Text(friendlyError(e)),
              data: (list) => GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  mainAxisExtent: 96,
                ),
                children: [
                  for (final g in list)
                    Semantics(
                      button: true,
                      selected: _picked?.id == g.id,
                      label: '${g.name}, ${g.coins} coins',
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _picked = g;
                          _clientRef = null;
                        }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: _picked?.id == g.id
                                ? const Color(0x29EC4899)
                                : AppColors.card,
                            border: Border.all(
                              color: _picked?.id == g.id
                                  ? AppColors.pink
                                  : AppColors.cardBorder,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                g.emoji,
                                style: const TextStyle(fontSize: 30),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                g.name,
                                style: AppText.body(
                                  12.5,
                                  weight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${g.coins}',
                                style: AppText.body(
                                  12,
                                  color: const Color(0xFFFCD34D),
                                  weight: FontWeight.w700,
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
            const SizedBox(height: 12),
            Text(
              '${widget.toName} gets a share of every gift you send.',
              textAlign: TextAlign.center,
              style: AppText.body(13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 14),
            GradientButton(
              label: _picked == null
                  ? 'Pick a gift'
                  : 'Send ${_picked!.name} · ${_picked!.coins} coins',
              loading: _sending,
              onPressed:
                  _picked == null || (coins != null && coins < _picked!.coins)
                  ? null
                  : _send,
            ),
            if (_picked != null && coins != null && coins < _picked!.coins)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'You need ${_picked!.coins - coins} more coins',
                  textAlign: TextAlign.center,
                  style: AppText.body(13, color: AppColors.warning),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
