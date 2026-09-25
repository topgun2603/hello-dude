import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pesu_api/api.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../app/theme.dart';
import '../../data/errors.dart';
import '../../data/session.dart';
import 'coin_shop.dart';
import 'home_data.dart';

/// Buys a coin pack with Razorpay checkout inside the app (CLAUDE.md: User
/// Choice Billing). The server creates the order at the pack's price and adds
/// the coins only after it has checked the payment itself — the app never
/// decides. Returns true when coins were added.
///
/// Play policy: never send people to a website to pay and never mention
/// cheaper prices elsewhere.
Future<bool> buyCoins(
  BuildContext context,
  WidgetRef ref,
  CoinPack pack,
) async {
  if (_busy) return false;
  _busy = true;
  final api = ref.read(apiProvider);
  final messenger = ScaffoldMessenger.of(context);
  final razorpay = Razorpay();
  try {
    final order = await _withSpinner(
      context,
      api.call(
        () => api.wallet.createRazorpayOrder(
          CreateRazorpayOrderRequest(sku: pack.sku),
        ),
      ),
    );

    final done = Completer<PaymentSuccessResponse?>();
    razorpay
      ..on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse r) {
        if (!done.isCompleted) done.complete(r);
      })
      ..on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse r) {
        if (done.isCompleted) return;
        done.complete(null);
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              r.code == Razorpay.PAYMENT_CANCELLED
                  ? 'Payment cancelled — no coins were charged'
                  : 'Payment didn\'t go through. No money was taken — try again.',
            ),
          ),
        );
      })
      // Wallet apps (Paytm etc.) finish on their side; Razorpay's webhook
      // credits the coins, so just wait for the balance to update.
      ..on(Razorpay.EVENT_EXTERNAL_WALLET, (ExternalWalletResponse _) {
        if (!done.isCompleted) done.complete(null);
      });
    razorpay.open({
      'key': order.keyId,
      'order_id': order.orderId,
      'amount': order.amountPaise,
      'currency': order.currency,
      'name': order.name,
      'description': order.description,
      if (order.phone != null) 'prefill': {'contact': order.phone},
      'theme': {'color': '#7C3AED'},
      'retry': {'enabled': true, 'max_count': 2},
      'send_sms_hash': true,
    });

    final paid = await done.future;
    if (paid == null || paid.orderId == null || paid.paymentId == null) {
      return false;
    }
    if (!context.mounted) return false;
    final result = await _withSpinner(
      context,
      api.call(
        () => api.wallet.verifyRazorpayPayment(
          VerifyRazorpayPaymentRequest(
            orderId: paid.orderId!,
            paymentId: paid.paymentId!,
            signature: paid.signature ?? '',
          ),
        ),
      ),
    );
    ref
      ..invalidate(walletProvider)
      ..invalidate(coinPackagesProvider);
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          result.status == PurchaseResultStatusEnum.credited
              ? '${result.coins} coins added 🎉'
              : result.message,
        ),
      ),
    );
    return result.status == PurchaseResultStatusEnum.credited;
  } catch (e) {
    messenger.showSnackBar(SnackBar(content: Text(friendlyError(e))));
    return false;
  } finally {
    razorpay.clear();
    _busy = false;
  }
}

bool _busy = false;

/// Blocks the screen with a small spinner while the server works.
Future<T> _withSpinner<T>(BuildContext context, Future<T> work) async {
  final nav = Navigator.of(context, rootNavigator: true);
  var shown = true;
  unawaited(
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) => const PopScope(
        canPop: false,
        child: Center(child: CircularProgressIndicator(color: AppColors.pink)),
      ),
    ).whenComplete(() => shown = false),
  );
  try {
    return await work;
  } finally {
    if (shown) nav.pop();
  }
}

/// Coin packs in a bottom sheet (e.g. "Add coins" during a call).
Future<void> showBuyCoinsSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF16142C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _BuyCoinsSheet(),
    );

class _BuyCoinsSheet extends ConsumerWidget {
  const _BuyCoinsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packs = ref.watch(coinPackagesProvider);
    return SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Add coins', style: AppText.heading(20)),
              const SizedBox(height: 14),
              packs.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Text(friendlyError(e)),
                data: (list) => CoinShop(
                  packs: list,
                  onBuy: (p) async {
                    if (await buyCoins(context, ref, p) && context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
