import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pesu_api/api.dart';

import '../../app/theme.dart';
import '../../data/errors.dart';
import '../../data/session.dart';
import '../../widgets/common.dart';
import '../home/home_data.dart';

final callDetailsProvider = FutureProvider.autoDispose
    .family<CallDetails, String>((ref, id) {
      final api = ref.watch(apiProvider);
      return api.call(() => api.calls.getCall(id));
    });

String _time(DateTime t) {
  final l = t.toLocal();
  return '${l.hour.toString().padLeft(2, '0')}:${l.minute.toString().padLeft(2, '0')}:${l.second.toString().padLeft(2, '0')}';
}

/// Design: CallDetails.dc.html — every coin of a call, minute by minute, and "Request a refund".
class CallDetailsScreen extends ConsumerWidget {
  const CallDetailsScreen({super.key, required this.callId});
  final String callId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(callDetailsProvider(callId));
    return Scaffold(
      body: GlowBackground(
        child: SafeArea(
          child: details.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.pink),
            ),
            error: (e, _) => Center(child: Text(friendlyError(e))),
            data: (d) => ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: [
                Row(
                  children: [
                    CircleIconButton(
                      icon: Icons.arrow_back_rounded,
                      tooltip: 'Back',
                      onPressed: () => context.pop(),
                    ),
                    const SizedBox(width: 12),
                    Text('Call details', style: AppText.heading(22)),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Avatar(
                      name: d.other.displayName,
                      avatarId: d.other.avatarId,
                      size: 52,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${d.type == CallDetailsTypeEnum.video ? 'Video' : 'Voice'} call with ${d.other.displayName}',
                            style: AppText.body(16, weight: FontWeight.w700),
                          ),
                          Text(
                            '${_date(d.createdAt)} · Call ID ${d.id.substring(0, 4).toUpperCase()}-${d.id.substring(4, 8).toUpperCase()}',
                            style: AppText.body(
                              13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _Big(
                      value: d.durationSeconds == null
                          ? '—'
                          : _mmss(d.durationSeconds!),
                      label: 'Talk time',
                    ),
                    _Big(value: '${d.minutesCharged}', label: 'Minutes billed'),
                    _Big(
                      value: d.coinsCharged == 0
                          ? '0'
                          : '−${d.coinsCharged - d.coinsRefunded}',
                      label: 'Coins',
                    ),
                  ],
                ),
                if (d.coinsRefunded > 0) ...[
                  const SizedBox(height: 8),
                  Text(
                    '${d.coinsRefunded} coins were refunded for this call.',
                    style: AppText.body(13, color: AppColors.success),
                  ),
                ],
                const SizedBox(height: 20),
                Text(
                  'Minute by minute',
                  style: AppText.heading(17, weight: FontWeight.w700),
                ),
                Text(
                  'Charged at the start of each minute',
                  style: AppText.body(12.5, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 10),
                if (d.minutes.isEmpty)
                  Text(
                    'No minutes were charged — the call never connected.',
                    style: AppText.body(13.5, color: AppColors.textSecondary),
                  ),
                for (final m in d.minutes)
                  _Line(
                    leading: '${m.minuteNo}',
                    title: 'Minute ${m.minuteNo}',
                    sub: _time(m.chargedAt),
                    amount: '−${m.coins}',
                  ),
                for (final g in d.gifts)
                  _Line(
                    leading: g.emoji,
                    title: '${g.name} gift',
                    sub: _time(g.at),
                    amount: '−${g.coins}',
                  ),
                if (d.direction == CallDetailsDirectionEnum.outgoing &&
                    d.startedAt != null &&
                    d.status == CallDetailsStatusEnum.ended) ...[
                  const SizedBox(height: 22),
                  _Refund(d),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _mmss(int s) =>
      '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';
  static String _date(DateTime t) {
    final l = t.toLocal();
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final h = l.hour % 12 == 0 ? 12 : l.hour % 12;
    return '${l.day} ${months[l.month - 1]}, $h:${l.minute.toString().padLeft(2, '0')} ${l.hour < 12 ? 'AM' : 'PM'}';
  }
}

class _Big extends StatelessWidget {
  const _Big({required this.value, required this.label});
  final String value, label;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Text(value, style: AppText.heading(20)),
          const SizedBox(height: 2),
          Text(label, style: AppText.body(12, color: AppColors.textSecondary)),
        ],
      ),
    ),
  );
}

class _Line extends StatelessWidget {
  const _Line({
    required this.leading,
    required this.title,
    required this.sub,
    required this.amount,
  });
  final String leading, title, sub, amount;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: [
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.08),
          ),
          child: Text(
            leading,
            style: AppText.body(13, weight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppText.body(14.5, weight: FontWeight.w600)),
              Text(
                sub,
                style: AppText.body(12.5, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        Text(amount, style: AppText.body(15, weight: FontWeight.w700)),
      ],
    ),
  );
}

class _Refund extends ConsumerStatefulWidget {
  const _Refund(this.d);
  final CallDetails d;

  @override
  ConsumerState<_Refund> createState() => _RefundState();
}

class _RefundState extends ConsumerState<_Refund> {
  RequestRefundRequestReasonEnum? _reason;
  final _details = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _details.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _busy = true);
    final api = ref.read(apiProvider);
    try {
      await api.call(
        () => api.calls.requestRefund(
          widget.d.id,
          RequestRefundRequest(
            reason: _reason!,
            details: _details.text.trim().isEmpty ? null : _details.text.trim(),
          ),
        ),
      );
      ref.invalidate(callDetailsProvider(widget.d.id));
      ref.invalidate(callHistoryProvider);
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Refund requested. We\'ll let you know.'),
          ),
        );
    } catch (e) {
      if (mounted) showError(context, friendlyError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rr = widget.d.refundRequest;
    if (rr != null) {
      final (text, color) = switch (rr.status) {
        RefundRequestStatusEnum.requested => (
          'Refund requested — waiting for review',
          const Color(0xFFFCD34D),
        ),
        RefundRequestStatusEnum.approved => (
          '${rr.coinsRefunded} coins refunded',
          AppColors.success,
        ),
        _ => ('Refund not approved', AppColors.danger),
      };
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text, style: AppText.body(15, weight: FontWeight.w700)),
            if (rr.note != null)
              Text(
                rr.note!,
                style: AppText.body(13, color: AppColors.textMuted),
              ),
          ],
        ),
      );
    }
    if (widget.d.coinsCharged - widget.d.coinsRefunded <= 0)
      return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Something went wrong?',
          style: AppText.heading(17, weight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final (r, label) in const [
              (RequestRefundRequestReasonEnum.callDropped, 'Call dropped'),
              (RequestRefundRequestReasonEnum.couldntHear, "Couldn't hear"),
              (RequestRefundRequestReasonEnum.wrongLanguage, 'Wrong language'),
              (RequestRefundRequestReasonEnum.other, 'Other'),
            ])
              ChoiceChip(
                label: Text(label),
                selected: _reason == r,
                selectedColor: const Color(0x33EC4899),
                onSelected: (_) => setState(() => _reason = r),
              ),
          ],
        ),
        if (_reason != null) ...[
          const SizedBox(height: 10),
          TextField(
            controller: _details,
            maxLength: 500,
            decoration: const InputDecoration(labelText: 'Details (optional)'),
          ),
        ],
        const SizedBox(height: 12),
        GradientButton(
          label: 'Request a refund',
          loading: _busy,
          onPressed: _reason == null ? null : _submit,
        ),
        const SizedBox(height: 8),
        Text(
          "You'll get a notification once it's reviewed.",
          textAlign: TextAlign.center,
          style: AppText.body(12.5, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
