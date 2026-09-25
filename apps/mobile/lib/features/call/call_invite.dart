import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../data/errors.dart';
import '../../data/session.dart';
import '../../widgets/common.dart';
import 'start_call.dart';

/// A companion invited this caller ("Priya wants to talk"): show her, and let
/// him call now (he starts the call and pays as usual) or not.
Future<void> showCallInviteSheet(
  BuildContext context,
  WidgetRef ref,
  String companionId,
) async {
  final api = ref.read(apiProvider);
  try {
    final r = await api.call(() => api.companions.getCompanion(companionId));
    if (!context.mounted) return;
    final c = r.companion;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF16142C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Avatar(
                name: c.displayName,
                avatarId: c.avatarId,
                photoUrl: c.photoUrl,
                size: 84,
                statusColor: r.online && !c.busy
                    ? AppColors.success
                    : AppColors.warning,
              ),
              const SizedBox(height: 12),
              Text(
                '${c.displayName} wants to talk',
                textAlign: TextAlign.center,
                style: AppText.heading(20),
              ),
              const SizedBox(height: 6),
              Text(
                !r.online
                    ? "She's offline now — try again later."
                    : c.busy
                    ? "She's on another call right now."
                    : 'She\'s online. Calls are charged per minute as usual.',
                textAlign: TextAlign.center,
                style: AppText.body(14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  if (c.audioEnabled)
                    Expanded(
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.pink,
                          minimumSize: const Size.fromHeight(50),
                        ),
                        onPressed: r.online && !c.busy
                            ? () {
                                Navigator.pop(ctx);
                                startCallFlow(
                                  context,
                                  ref,
                                  companion: c,
                                  language: c.primaryLanguage,
                                  video: false,
                                );
                              }
                            : null,
                        icon: const Icon(Icons.call_rounded),
                        label: const Text('Voice call'),
                      ),
                    ),
                  if (c.audioEnabled && c.videoEnabled)
                    const SizedBox(width: 10),
                  if (c.videoEnabled)
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        onPressed: r.online && !c.busy
                            ? () {
                                Navigator.pop(ctx);
                                startCallFlow(
                                  context,
                                  ref,
                                  companion: c,
                                  language: c.primaryLanguage,
                                  video: true,
                                );
                              }
                            : null,
                        icon: const Icon(Icons.videocam_rounded),
                        label: const Text('Video call'),
                      ),
                    ),
                ],
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Not now'),
              ),
            ],
          ),
        ),
      ),
    );
  } catch (e) {
    if (context.mounted) showError(context, friendlyError(e));
  }
}
