import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pesu_api/api.dart';

import '../../app/theme.dart';
import '../../data/errors.dart';
import '../../data/session.dart';
import 'companion_data.dart';
import 'kyc_screen.dart' show showChangeUpiSheet;

const _green = Color(0xFF10B981);

/// Design: Earnings.dc.html — available balance, UPI, withdraw, this week, withdrawals.
class EarningsTab extends ConsumerWidget {
  const EarningsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final e = ref.watch(earningsProvider);
    return RefreshIndicator(
      color: _green,
      onRefresh: () async => ref.invalidate(earningsProvider),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          Text('Earnings', style: AppText.heading(26, spacing: -0.6)),
          const SizedBox(height: 16),
          e.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(40),
              child: Center(child: CircularProgressIndicator(color: _green)),
            ),
            error: (err, _) => Text(
              friendlyError(err),
              style: AppText.body(14, color: AppColors.textMuted),
            ),
            data: (d) => _Body(d),
          ),
        ],
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body(this.d);
  final CompanionEarnings200Response d;

  Future<void> _withdraw(BuildContext context, WidgetRef ref) async {
    final gross = d.availablePaise;
    final tds = (gross * d.tdsBps / 10000).round();
    final ok = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: const Color(0xFF16142C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Withdraw to ${d.upi}', style: AppText.heading(20)),
              const SizedBox(height: 16),
              _Line('Amount', rupees(gross)),
              _Line('TDS (${d.tdsBps / 100}%)', '− ${rupees(tds)}'),
              const Divider(color: AppColors.cardBorder),
              _Line('You receive', rupees(gross - tds), bold: true),
              const SizedBox(height: 12),
              Text(
                'Usually reaches your bank within a day after approval.',
                style: AppText.body(13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: _green,
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Withdraw',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
    if (ok != true || !context.mounted) return;
    final api = ref.read(apiProvider);
    try {
      await api.call(() => api.companion.requestPayout(RequestPayoutRequest()));
      ref.invalidate(earningsProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Withdrawal requested')));
      }
    } catch (err) {
      if (context.mounted) showErrorSnack(context, friendlyError(err));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maxDay = d.week.fold<int>(1, (m, x) => x.paise > m ? x.paise : m);
    final weekTotal = d.week.fold<int>(0, (s, x) => s + x.paise);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [_green, Color(0xFF0E7490)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Available to withdraw',
                style: AppText.body(
                  14,
                  color: const Color(0xFFD1FAE5),
                  weight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(rupees(d.availablePaise), style: AppText.heading(38)),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.account_balance_outlined,
                    size: 18,
                    color: Color(0xFFD1FAE5),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      d.upi == null ? 'No UPI ID yet' : 'Pay to UPI  ${d.upi}',
                      style: AppText.body(14, color: const Color(0xFFD1FAE5)),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(foregroundColor: Colors.white),
                    onPressed: () => d.upi == null
                        ? context.push('/kyc')
                        : showChangeUpiSheet(context),
                    child: Text(d.upi == null ? 'Add' : 'Change'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF0E7490),
                  minimumSize: const Size.fromHeight(48),
                  disabledBackgroundColor: const Color(0x66FFFFFF),
                ),
                onPressed: d.canWithdraw ? () => _withdraw(context, ref) : null,
                child: Text(
                  d.canWithdraw
                      ? 'Withdraw ${rupees(d.availablePaise)}'
                      : (d.blockedReason ?? 'Withdraw'),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                d.panOnFile
                    ? 'TDS of ${d.tdsBps / 100}% is deducted before payout.'
                    : 'No PAN on file: ${d.tdsNoPanBps / 100}% TDS is deducted (${d.tdsWithPanBps / 100}% with a PAN).',
                style: AppText.body(12.5, color: const Color(0xFFD1FAE5)),
              ),
              if (!d.panOnFile)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () => context.push('/kyc'),
                    icon: const Icon(Icons.badge_outlined, size: 18),
                    label: const Text('Add PAN to pay less TDS'),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Text(
              'This week',
              style: AppText.heading(17, weight: FontWeight.w700),
            ),
            const Spacer(),
            Text(
              rupees(weekTotal),
              style: AppText.body(
                15,
                weight: FontWeight.w700,
                color: const Color(0xFF6EE7B7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Semantics(
          label: 'Earnings per day this week',
          child: SizedBox(
            height: 110,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final (i, day) in d.week.indexed)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          day.paise > 0 ? rupees(day.paise) : '–',
                          style: AppText.body(
                            10.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          width: 22,
                          height: 4 + 60 * day.paise / maxDay,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: i == d.week.length - 1
                                ? const Color(0xFF6EE7B7)
                                : const Color(0x6610B981),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _weekday(day.date),
                          style: AppText.body(
                            11.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Withdrawals',
          style: AppText.heading(17, weight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        if (d.payouts.isEmpty)
          Text(
            'No withdrawals yet.',
            style: AppText.body(13.5, color: AppColors.textSecondary),
          ),
        for (final p in d.payouts) _PayoutRow(p),
      ],
    );
  }
}

String _weekday(String isoDate) => const [
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
  'Sun',
][DateTime.parse(isoDate).weekday - 1];

class _Line extends StatelessWidget {
  const _Line(this.label, this.value, {this.bold = false});
  final String label, value;
  final bool bold;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Text(
          label,
          style: AppText.body(
            15,
            color: bold ? Colors.white : AppColors.textMuted,
            weight: bold ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: AppText.body(
            15,
            weight: bold ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

class _PayoutRow extends StatelessWidget {
  const _PayoutRow(this.p);
  final Payout p;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (p.status) {
      PayoutStatusEnum.paid => ('Paid', const Color(0xFF6EE7B7)),
      PayoutStatusEnum.requested => ('Requested', const Color(0xFFFCD34D)),
      PayoutStatusEnum.processing => ('Processing', const Color(0xFFFCD34D)),
      PayoutStatusEnum.failed => ('Returned to balance', AppColors.danger),
      _ => ('Rejected · returned', AppColors.danger),
    };
    final when = '${p.createdAt.toLocal().day}/${p.createdAt.toLocal().month}';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.status == PayoutStatusEnum.paid
                      ? '${rupees(p.netPaise)} received'
                      : rupees(p.grossPaise),
                  style: AppText.body(15, weight: FontWeight.w700),
                ),
                Text(
                  p.failureReason ??
                      '$when · ${rupees(p.grossPaise)} minus ${rupees(p.tdsPaise)} TDS',
                  style: AppText.body(12.5, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Text(
            label,
            style: AppText.body(13, weight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }
}

void showErrorSnack(BuildContext context, String message) =>
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), backgroundColor: AppColors.danger),
      );
