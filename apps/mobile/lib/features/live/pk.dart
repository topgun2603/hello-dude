// PK battles: two lives side by side for 5 minutes; gift coins decide the winner.
// Shared by the host screen and the viewer feed. The other live's video comes from a
// second, listen-only LiveKit room (the server hands out that token).
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:pesu_api/api.dart';

import '../../app/theme.dart';
import '../../data/api.dart';
import '../../widgets/common.dart';

/// Battle state for one screen, seen from the live `fromLiveId` ("mine" = left).
class PkController extends ChangeNotifier {
  PkController({required this.api, required this.fromLiveId});
  final PesuApi api;
  final String fromLiveId;

  PkBattle? battle;
  VideoTrack? otherVideo;
  Room? _room;
  EventsListener<RoomEvent>? _roomEvents;
  Timer? _clear;
  bool _disposed = false;

  bool get active => battle?.status == PkBattleStatusEnum.active;
  bool get ended => battle?.status == PkBattleStatusEnum.ended;
  bool get showing => active || ended;
  PkSide? get mine => battle == null ? null : (battle!.a.liveId == fromLiveId ? battle!.a : battle!.b);
  PkSide? get theirs => battle == null ? null : (battle!.a.liveId == fromLiveId ? battle!.b : battle!.a);

  /// Load a battle (e.g. joined mid-battle) and connect to the other side's video.
  Future<void> load(String battleId) async {
    try {
      final r = await api.call(() => api.lives.getPk(fromLiveId, battleId));
      if (_disposed) return;
      battle = r.battle;
      notifyListeners();
      final other = r.other;
      if (other != null && active) await _connect(other);
    } catch (_) {
      /* no battle view; the live itself still works */
    }
  }

  /// Handles pk_* live events; returns true if it was one.
  bool handle(Map<String, dynamic> e) {
    switch (e['kind']) {
      case 'pk_started':
        final b = PkBattle.fromJson(e['battle']);
        if (b != null) unawaited(load(b.id));
        return true;
      case 'pk_score':
        final b = battle;
        if (b != null && b.id == e['battleId']) {
          b.a.score = (e['scoreA'] as num?)?.toInt() ?? b.a.score;
          b.b.score = (e['scoreB'] as num?)?.toInt() ?? b.b.score;
          notifyListeners();
        }
        return true;
      case 'pk_ended':
        final b = battle;
        if (b != null && b.id == e['battleId']) {
          b.a.score = (e['scoreA'] as num?)?.toInt() ?? b.a.score;
          b.b.score = (e['scoreB'] as num?)?.toInt() ?? b.b.score;
          b.winnerHostId = e['winnerHostId'] as String?;
          b.status = PkBattleStatusEnum.ended;
          _disconnect();
          notifyListeners();
          _clear?.cancel();
          _clear = Timer(const Duration(seconds: 8), () {
            if (_disposed) return;
            battle = null;
            notifyListeners();
          });
        }
        return true;
    }
    return false;
  }

  Future<void> _connect(GetPk200ResponseOther other) async {
    _disconnect();
    final room = Room(roomOptions: const RoomOptions(adaptiveStream: true, dynacast: true));
    _room = room;
    _roomEvents = room.createListener()
      ..on<TrackSubscribedEvent>((e) {
        if (e.track is VideoTrack && !_disposed) {
          otherVideo = e.track as VideoTrack;
          notifyListeners();
        }
      })
      ..on<TrackUnsubscribedEvent>((e) {
        if (e.track == otherVideo && !_disposed) {
          otherVideo = null;
          notifyListeners();
        }
      });
    try {
      await room.connect(other.liveKitUrl, other.token);
      for (final p in room.remoteParticipants.values) {
        for (final pub in p.videoTrackPublications) {
          if (pub.track != null) otherVideo = pub.track;
        }
      }
      if (!_disposed) notifyListeners();
    } catch (_) {
      /* the score bar still works without the other video */
    }
  }

  void _disconnect() {
    _roomEvents?.dispose();
    _roomEvents = null;
    otherVideo = null;
    final r = _room;
    _room = null;
    if (r != null) unawaited(r.disconnect().then((_) => r.dispose()));
  }

  @override
  void dispose() {
    _disposed = true;
    _clear?.cancel();
    _disconnect();
    super.dispose();
  }
}

String pkClock(Duration d) {
  final s = d.isNegative ? 0 : d.inSeconds;
  return '${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')}';
}

/// Score bar + the two videos side by side + result banner.
class PkBattleView extends StatelessWidget {
  const PkBattleView({super.key, required this.pk, required this.myVideo});
  final PkController pk;
  final Widget myVideo;

  @override
  Widget build(BuildContext context) {
    final mine = pk.mine!, theirs = pk.theirs!;
    final b = pk.battle!;
    final total = mine.score + theirs.score;
    final share = total == 0 ? 0.5 : (mine.score / total).clamp(0.08, 0.92);
    final left = b.endsAt?.difference(DateTime.now()) ?? Duration.zero;
    Widget side(PkSide s, Widget video) => Expanded(
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: ClipRect(
          child: Stack(
            fit: StackFit.expand,
            children: [
              video,
              Positioned(
                left: 6,
                bottom: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(999)),
                  child: Text(s.hostName, style: AppText.body(12, weight: FontWeight.w700)),
                ),
              ),
              if (pk.ended && b.winnerHostId == s.hostId)
                const Positioned(top: 6, right: 6, child: Text('👑', style: TextStyle(fontSize: 26))),
            ],
          ),
        ),
      ),
    );
    Widget otherVideo() {
      final v = pk.otherVideo;
      if (v != null) return VideoTrackRenderer(v, fit: VideoViewFit.cover);
      return ColoredBox(
        color: const Color(0xFF16142C),
        child: Center(child: Avatar(name: theirs.hostName, avatarId: theirs.avatarId, size: 64)),
      );
    }

    String result() {
      if (b.winnerHostId == null) return "It's a draw!";
      return b.winnerHostId == mine.hostId ? '${mine.hostName} wins! 🎉' : '${theirs.hostName} wins!';
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Text('${mine.score}', style: AppText.body(14, weight: FontWeight.w800)),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: SizedBox(
                    height: 10,
                    child: Row(
                      children: [
                        Expanded(flex: (share * 1000).round(), child: const ColoredBox(color: Color(0xFFEC4899))),
                        const SizedBox(width: 2),
                        Expanded(flex: ((1 - share) * 1000).round(), child: const ColoredBox(color: Color(0xFF3B82F6))),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text('${theirs.score}', style: AppText.body(14, weight: FontWeight.w800)),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: pk.ended ? const Color(0xCCB45309) : Colors.black54,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            pk.ended ? result() : 'PK · ${pkClock(left)}',
            style: AppText.body(13, weight: FontWeight.w800),
          ),
        ),
        const SizedBox(height: 6),
        Row(children: [side(mine, myVideo), const SizedBox(width: 2), side(theirs, otherVideo())]),
      ],
    );
  }
}

/// Host: pick another live to challenge. Returns the opponent's live id.
Future<String?> pickPkOpponent(BuildContext context, PesuApi api, String myHostId) async {
  final list = await api.call(() => api.lives.listLives(sort: 'popular', limit: 50));
  final lives = list.lives.where((l) => l.host.id != myHostId && l.pkBattleId == null).toList();
  if (!context.mounted) return null;
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: const Color(0xFF16142C),
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
            child: Text('Challenge to a PK battle', style: AppText.heading(18)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Text(
              '5 minutes side by side. Whoever gets more gift coins wins a PK winner badge. She has 30 s to accept.',
              style: AppText.body(13, color: AppColors.textSecondary),
            ),
          ),
          if (lives.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text('Nobody else is live right now.', style: AppText.body(14)),
            ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final l in lives)
                  ListTile(
                    leading: Avatar(name: l.host.displayName, avatarId: l.host.avatarId, photoUrl: l.host.photoUrl, size: 40),
                    title: Text(l.host.displayName, style: AppText.body(15, weight: FontWeight.w700)),
                    subtitle: Text('${l.title} · ${l.viewers} watching', style: AppText.body(12.5, color: AppColors.textSecondary)),
                    trailing: const Icon(Icons.bolt_rounded, color: Color(0xFFF59E0B)),
                    onTap: () => Navigator.pop(ctx, l.id),
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/// Viewer during a battle: which host gets the gift. Returns a host id.
Future<String?> pickPkSide(BuildContext context, PkController pk) {
  final mine = pk.mine!, theirs = pk.theirs!;
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: const Color(0xFF16142C),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Who gets your gift?', style: AppText.heading(18)),
            const SizedBox(height: 12),
            Row(
              children: [
                for (final (s, color) in [(mine, const Color(0xFFEC4899)), (theirs, const Color(0xFF3B82F6))])
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FilledButton(
                        style: FilledButton.styleFrom(backgroundColor: color, padding: const EdgeInsets.symmetric(vertical: 14)),
                        onPressed: () => Navigator.pop(ctx, s.hostId),
                        child: Text(s.hostName, overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
