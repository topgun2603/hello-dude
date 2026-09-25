import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pesu_api/api.dart';

import '../growth/leaderboard_screen.dart' show CallerLevelCard;
import '../../app/theme.dart';
import '../../data/errors.dart';
import '../../data/languages.dart';
import '../../data/session.dart';
import '../../widgets/common.dart';
import '../vip/vip_screen.dart';
import '../../widgets/love_loader.dart';
import '../history/coin_history.dart'
    show CoinHistoryPreview, coinHistoryPreviewProvider;
import 'buy_coins.dart';
import 'coin_shop.dart';
import 'home_data.dart';
import 'home_screen.dart' show CoinIcon, CoinStack;
import '../companion/profile_photo.dart' show MyAvatar, ProfilePhotoTile;

class _TabPage extends StatelessWidget {
  const _TabPage({required this.title, required this.children, this.onRefresh});
  final String title;
  final List<Widget> children;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final list = ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        Text(title, style: AppText.heading(26, spacing: -0.6)),
        const SizedBox(height: 18),
        ...children,
      ],
    );
    return onRefresh == null
        ? list
        : RefreshIndicator(
            color: AppColors.pink,
            onRefresh: onRefresh!,
            child: list,
          );
  }
}

BoxDecoration _card() => BoxDecoration(
  color: AppColors.card,
  borderRadius: BorderRadius.circular(20),
  border: Border.all(color: AppColors.cardBorder),
);

// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------
class WalletTab extends ConsumerWidget {
  const WalletTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet = ref.watch(walletProvider);
    final packs = ref.watch(coinPackagesProvider);
    return _TabPage(
      title: 'Wallet',
      onRefresh: () async {
        ref.invalidate(walletProvider);
        ref.invalidate(coinPackagesProvider);
        ref.invalidate(coinHistoryPreviewProvider);
      },
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: AppColors.instantMatch,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your coins',
                          style: AppText.body(
                            14,
                            color: const Color(0xFFFCE7F3),
                            weight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const CoinIcon(size: 30),
                            const SizedBox(width: 10),
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  wallet.valueOrNull?.coins.toString() ?? '–',
                                  style: AppText.heading(36),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const CoinStack(width: 112),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Voice calls cost 10 coins a minute. You only pay once both of you have joined.',
                style: AppText.body(
                  13,
                  color: const Color(0xFFFDF2F8),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        packs.when(
          data: (list) =>
              CoinShop(packs: list, onBuy: (p) => buyCoins(context, ref, p)),
          loading: () => const Padding(
            padding: EdgeInsets.all(24),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.pink),
            ),
          ),
          error: (e, _) => Text(
            friendlyError(e),
            style: AppText.body(14, color: AppColors.textMuted),
          ),
        ),
        const SizedBox(height: 28),
        const CoinHistoryPreview(),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  Future<void> _editName(
    BuildContext context,
    WidgetRef ref,
    String current,
  ) async {
    final controller = TextEditingController(text: current);
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16142C),
        title: const Text('Your first name'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 30,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            helperText: 'Others see only this and your avatar',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (name == null || name.isEmpty || name == current) return;
    final api = ref.read(apiProvider);
    try {
      final p = await api.call(
        () => api.profile.updateMe(UpdateMeRequest(displayName: name)),
      );
      await ref.read(sessionProvider.notifier).setProfile(p);
    } catch (e) {
      if (context.mounted) showError(context, friendlyError(e));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(sessionProvider).profile!;
    return _TabPage(
      title: 'Profile',
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: _card(),
          child: Row(
            children: [
              const MyAvatar(size: 64),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.displayName, style: AppText.heading(20)),
                    const SizedBox(height: 4),
                    Text(
                      p.phone,
                      style: AppText.body(14, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Edit name',
                onPressed: () => _editName(context, ref, p.displayName),
                icon: const Icon(Icons.edit_outlined, color: AppColors.lilac),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (p.role == ProfileRoleEnum.caller) const CallerLevelCard(),
        Container(
          decoration: _card(),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.translate_rounded),
                title: const Text('Languages'),
                subtitle: Text(languageNames(p.languages)),
              ),
              const Divider(height: 1, color: AppColors.cardBorder),
              ListTile(
                leading: const Icon(
                  Icons.emoji_events_outlined,
                  color: Color(0xFFFCD34D),
                ),
                title: const Text('Leaderboards'),
                subtitle: const Text('Top companions and fans this week'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push('/leaderboards'),
              ),
              const Divider(height: 1, color: AppColors.cardBorder),
              if (p.role == ProfileRoleEnum.caller)
                ListTile(
                  leading: const Icon(
                    Icons.record_voice_over_outlined,
                    color: Color(0xFF6EE7B7),
                  ),
                  title: const Text('Become a companion'),
                  subtitle: const Text('Earn by taking calls in your language'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push('/become-companion'),
                )
              else if (p.role == ProfileRoleEnum.companion) ...[
                const ProfilePhotoTile(),
                const Divider(height: 1, color: AppColors.cardBorder),
                ListTile(
                  leading: const Icon(
                    Icons.verified_user_outlined,
                    color: Color(0xFF6EE7B7),
                  ),
                  title: const Text('Verification & UPI'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push('/kyc'),
                ),
              ],
              if (p.role == ProfileRoleEnum.caller) ...[
                const Divider(height: 1, color: AppColors.cardBorder),
                ListTile(
                  leading: const Icon(
                    Icons.history_rounded,
                    color: AppColors.lilac,
                  ),
                  title: const Text('Call history'),
                  subtitle: const Text('Every call, with dates and filters'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push('/call-history'),
                ),
                const Divider(height: 1, color: AppColors.cardBorder),
                ListTile(
                  leading: const Icon(
                    Icons.workspace_premium_rounded,
                    color: Color(0xFFF59E0B),
                  ),
                  title: const Text('Hello Dude! VIP'),
                  subtitle: Text(
                    p.vipUntil != null
                        ? 'Active'
                        : 'Cheaper calls, first pick, free Rose',
                  ),
                  trailing: p.vipUntil != null
                      ? const VipBadge()
                      : const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push('/vip'),
                ),
                const Divider(height: 1, color: AppColors.cardBorder),
                ListTile(
                  leading: const Icon(
                    Icons.card_giftcard_rounded,
                    color: AppColors.pinkSoft,
                  ),
                  title: const Text('Invite friends'),
                  subtitle: const Text('You both get free coins'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push('/referral'),
                ),
                const Divider(height: 1, color: AppColors.cardBorder),
                ListTile(
                  leading: const Icon(
                    Icons.local_fire_department_rounded,
                    color: Color(0xFFF59E0B),
                  ),
                  title: const Text('Daily bonus'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push('/checkin'),
                ),
              ],
              const Divider(height: 1, color: AppColors.cardBorder),
              ListTile(
                leading: const Icon(Icons.event_note_rounded),
                title: Text(
                  p.role == ProfileRoleEnum.companion
                      ? 'Call requests'
                      : 'My bookings',
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push('/bookings'),
              ),
              const Divider(height: 1, color: AppColors.cardBorder),
              ListTile(
                leading: const Icon(Icons.favorite_border_rounded),
                title: const Text('Favourites'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push('/favourites'),
              ),
              const Divider(height: 1, color: AppColors.cardBorder),
              ListTile(
                leading: const Icon(Icons.gavel_rounded),
                title: const Text('Legal & policies'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push('/legal'),
              ),
              const Divider(height: 1, color: AppColors.cardBorder),
              ListTile(
                leading: const Icon(
                  Icons.person_remove_outlined,
                  color: AppColors.textSecondary,
                ),
                title: const Text('Delete account'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push('/delete-account'),
              ),
              const Divider(height: 1, color: AppColors.cardBorder),
              ListTile(
                leading: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.danger,
                ),
                title: const Text(
                  'Sign out',
                  style: TextStyle(color: AppColors.danger),
                ),
                onTap: () => withLoveLoader(
                  context,
                  title: 'Signing you out…',
                  subtitle: 'See you soon, dude ♥',
                  task: () => ref.read(sessionProvider.notifier).signOut(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
