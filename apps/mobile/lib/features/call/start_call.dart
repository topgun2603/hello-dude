import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pesu_api/api.dart';

import '../../app/theme.dart';
import '../../data/errors.dart';
import '../../data/languages.dart';
import '../../data/session.dart';
import '../../widgets/common.dart';
import '../home/home_data.dart';
import '../home/home_screen.dart' show CoinIcon;

/// Everything the call screen needs, from POST /calls or /calls/match.
class CallArgs {
  const CallArgs({
    required this.callId,
    required this.liveKitUrl,
    required this.room,
    required this.token,
    required this.coinsPerMin,
    required this.video,
    required this.otherName,
    required this.otherAvatarId,
    required this.subtitle,
    this.asCompanion = false,
  });
  final String callId, liveKitUrl, room, token, otherName, subtitle;
  final int coinsPerMin, otherAvatarId;
  final bool video;

  /// The companion side: already answered, no rating, earnings instead of coins.
  final bool asCompanion;
}

/// Call a specific companion, or instant-match when [companion] is null.
Future<void> startCallFlow(
  BuildContext context,
  WidgetRef ref, {
  OnlineCompanion? companion,
  required String language,
  required bool video,
}) async {
  final rate = companion == null
      ? null
      : video
      ? companion.rates.videoCoinsPerMin
      : companion.rates.audioCoinsPerMin;
  final coins = ref.read(walletProvider).valueOrNull?.coins;
  final who =
      companion?.displayName ??
      'someone who speaks ${languageInfo(language).english}';

  final ok = await _confirm(
    context,
    who: who,
    video: video,
    coinsPerMin: rate,
    coins: coins,
  );
  if (ok != true || !context.mounted) return;

  // Ask for the microphone (and camera) before ringing anyone.
  final perms = await [
    Permission.microphone,
    if (video) Permission.camera,
  ].request();
  if (perms.values.any((s) => !s.isGranted)) {
    if (context.mounted) {
      showError(
        context,
        video
            ? 'Allow microphone and camera to make a video call'
            : 'Allow the microphone to make a call',
      );
    }
    if (perms.values.any((s) => s.isPermanentlyDenied)) await openAppSettings();
    return;
  }

  final api = ref.read(apiProvider);
  try {
    final CallArgs args;
    if (companion != null) {
      final r = await api.call(
        () => api.calls.startCall(
          StartCallRequest(
            companionId: companion.id,
            type: video
                ? StartCallRequestTypeEnum.video
                : StartCallRequestTypeEnum.audio,
          ),
        ),
      );
      args = CallArgs(
        callId: r.callId,
        liveKitUrl: r.liveKitUrl,
        room: r.room,
        token: r.token,
        coinsPerMin: r.coinsPerMin,
        video: video,
        otherName: companion.displayName,
        otherAvatarId: companion.avatarId,
        subtitle: languageNames(companion.languages),
      );
    } else {
      final r = await api.call(
        () => api.calls.matchCall(
          MatchCallRequest(
            language: language,
            type: video
                ? MatchCallRequestTypeEnum.video
                : MatchCallRequestTypeEnum.audio,
          ),
        ),
      );
      args = CallArgs(
        callId: r.callId,
        liveKitUrl: r.liveKitUrl,
        room: r.room,
        token: r.token,
        coinsPerMin: r.coinsPerMin,
        video: video,
        otherName: r.companion.displayName,
        otherAvatarId: r.companion.avatarId,
        subtitle: languageInfo(language).english,
      );
    }
    if (context.mounted) await context.push('/call', extra: args);
  } catch (e) {
    if (!context.mounted) return;
    final code = errorCode(e);
    showError(context, switch (code) {
      'INSUFFICIENT_BALANCE' =>
        'Not enough coins for a minute. Add coins to call.',
      'BUSY' =>
        '${companion?.displayName ?? 'They'} just got another call. Try someone else.',
      'OFFLINE' => '${companion?.displayName ?? 'They'} just went offline.',
      _ => friendlyError(e),
    });
    ref.invalidate(onlineCompanionsProvider);
  } finally {
    ref.invalidate(walletProvider);
  }
}

Future<bool?> _confirm(
  BuildContext context, {
  required String who,
  required bool video,
  int? coinsPerMin,
  int? coins,
}) {
  return showModalBottomSheet<bool>(
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
          children: [
            Icon(
              video ? Icons.videocam_rounded : Icons.call_rounded,
              color: AppColors.pinkSoft,
              size: 40,
            ),
            const SizedBox(height: 12),
            Text(
              '${video ? 'Video' : 'Voice'} call $who',
              textAlign: TextAlign.center,
              style: AppText.heading(20),
            ),
            const SizedBox(height: 10),
            if (coinsPerMin != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CoinIcon(size: 16),
                  const SizedBox(width: 6),
                  Text(
                    '$coinsPerMin coins per minute',
                    style: AppText.body(15, color: AppColors.textMuted),
                  ),
                ],
              ),
            if (coins != null) ...[
              const SizedBox(height: 4),
              Text(
                'You have $coins coins',
                style: AppText.body(13.5, color: AppColors.textSecondary),
              ),
            ],
            const SizedBox(height: 12),
            Text(
              "You're only charged once they pick up. Calls under 10 seconds are refunded.",
              textAlign: TextAlign.center,
              style: AppText.body(
                13.5,
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 20),
            GradientButton(
              label: 'Call now',
              icon: Icons.call_rounded,
              onPressed: () => Navigator.pop(context, true),
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
}
