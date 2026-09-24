import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pesu_api/api.dart';

import '../data/session.dart';
import '../features/auth/language_screen.dart';
import '../features/auth/otp_screen.dart';
import '../features/auth/welcome_screen.dart';
import '../features/call/call_screen.dart';
import '../features/call/rate_screen.dart';
import '../features/call/start_call.dart';
import '../features/call/call_details_screen.dart';
import '../features/companion/academy_screen.dart';
import '../features/companion/apply_screen.dart';
import '../features/favourites/favourites_screen.dart';
import '../features/home/delete_account_screen.dart';
import '../features/companion/companion_shell.dart';
import '../features/companion/incoming_screen.dart';
import '../features/companion/kyc_screen.dart';
import '../features/home/shell.dart';
import '../features/legal/legal_screen.dart';
import '../features/notifications/notifications_screen.dart';
import '../features/growth/checkin_screen.dart';
import '../features/growth/referral_screen.dart';
import '../features/growth/share_card_screen.dart';
import '../features/chat/chat_screens.dart';
import '../features/bookings/bookings_screens.dart';
import '../features/vip/vip_screen.dart';
import '../features/companion/rewards_screen.dart';
import '../features/rooms/rooms_screens.dart';
import '../features/history/call_history.dart' show CallHistoryScreen;
import '../features/history/coin_history.dart' show CoinHistoryScreen;
import '../features/live/live_feed_screen.dart' show LiveFeedScreen;
import '../features/live/live_host_screen.dart' show LiveHostScreen;
import '../features/group/group_data.dart' show GroupsScreen;
import '../features/group/group_room_screen.dart' show GroupRoomScreen;
import 'package:pesu_api/api.dart' show LiveJoin;
import '../widgets/love_loader.dart';

/// Re-runs the router's redirect whenever the session changes.
class _SessionListenable extends ChangeNotifier {
  _SessionListenable(Ref ref) {
    ref.listen(sessionProvider, (_, _) => notifyListeners());
  }
}

/// Screens each role may open; anything else sends them to their home.
const signUpPaths = {'/welcome', '/otp', '/language'};
const callerPaths = {
  '/home',
  '/call',
  '/rate',
  '/become-companion',
  '/favourites',
  '/call-details',
  '/delete-account',
  '/notifications',
  '/checkin',
  '/referral',
  '/share',
  '/schedule',
  '/vip',
  '/coin-history',
  '/call-history',
  '/live',
  '/groups',
  '/group',
};
const companionPaths = {
  '/companion',
  '/kyc',
  '/incoming',
  '/call',
  '/academy',
  '/delete-account',
  '/notifications',
  '/rewards',
  '/call-history',
  '/call-details',
  '/live-host',
  '/group-host',
};

/// Whether `path` (a matched location like `/schedule/123`) is one of `allowed`,
/// either exactly or as a sub-path (`/schedule` allows `/schedule/123`).
bool routeAllowed(Set<String> allowed, String path) =>
    allowed.contains(path) || allowed.any((p) => path.startsWith('$p/'));

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: _SessionListenable(ref),
    redirect: (context, state) {
      final session = ref.read(sessionProvider);
      final path = state.matchedLocation;
      // Policies are readable by everyone, signed in or not.
      if (path.startsWith('/legal') && session.status != SessionStatus.loading)
        return null;
      // Chat, bookings and voice rooms are for both roles.
      if ((path == '/chats' ||
              path.startsWith('/chat/') ||
              path == '/bookings' ||
              path == '/rooms' ||
              path.startsWith('/room/')) &&
          session.status == SessionStatus.signedIn)
        return null;
      switch (session.status) {
        case SessionStatus.loading:
          return path == '/splash' ? null : '/splash';
        case SessionStatus.signedOut:
          return routeAllowed(signUpPaths, path) ? null : '/welcome';
        case SessionStatus.signedIn:
          // Each role has its own area; anything else goes to that role's home.
          if (session.profile?.role == ProfileRoleEnum.companion) {
            return routeAllowed(companionPaths, path) ? null : '/companion';
          }
          return routeAllowed(callerPaths, path) ? null : '/home';
      }
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, _) => const _Splash()),
      GoRoute(path: '/welcome', builder: (_, _) => const WelcomeScreen()),
      GoRoute(path: '/otp', builder: (_, _) => const OtpScreen()),
      GoRoute(path: '/language', builder: (_, _) => const LanguageScreen()),
      GoRoute(path: '/home', builder: (_, _) => const MainShell()),
      GoRoute(
        path: '/call',
        builder: (_, s) => CallScreen(args: s.extra! as CallArgs),
      ),
      GoRoute(
        path: '/rate',
        builder: (_, s) => RateScreen(args: s.extra! as CallArgs),
      ),
      GoRoute(
        path: '/become-companion',
        builder: (_, _) => const ApplyScreen(),
      ),
      GoRoute(path: '/companion', builder: (_, _) => const CompanionShell()),
      GoRoute(path: '/kyc', builder: (_, _) => const KycScreen()),
      GoRoute(path: '/academy', builder: (_, _) => const AcademyScreen()),
      GoRoute(path: '/favourites', builder: (_, _) => const FavouritesScreen()),
      GoRoute(
        path: '/notifications',
        builder: (_, _) => const NotificationsScreen(),
      ),
      GoRoute(path: '/checkin', builder: (_, _) => const CheckInScreen()),
      GoRoute(path: '/referral', builder: (_, _) => const ReferralScreen()),
      GoRoute(path: '/share', builder: (_, _) => const ShareCardScreen()),
      GoRoute(path: '/chats', builder: (_, _) => const ChatsScreen()),
      GoRoute(path: '/bookings', builder: (_, _) => const BookingsScreen()),
      GoRoute(path: '/vip', builder: (_, _) => const VipScreen()),
      GoRoute(path: '/rewards', builder: (_, _) => const RewardsScreen()),
      GoRoute(path: '/rooms', builder: (_, _) => const RoomsScreen()),
      GoRoute(
        path: '/live',
        builder: (_, s) => LiveFeedScreen(startId: s.extra as String?),
      ),
      GoRoute(
        path: '/live-host',
        builder: (_, s) => LiveHostScreen(join: s.extra! as LiveJoin),
      ),
      GoRoute(path: '/groups', builder: (_, _) => const GroupsScreen()),
      GoRoute(
        path: '/group',
        builder: (_, s) => GroupRoomScreen(groupId: s.extra! as String),
      ),
      GoRoute(
        path: '/group-host',
        builder: (_, s) => GroupRoomScreen(groupId: s.extra! as String, isHost: true),
      ),
      GoRoute(
        path: '/coin-history',
        builder: (_, _) => const CoinHistoryScreen(),
      ),
      GoRoute(
        path: '/call-history',
        builder: (_, _) => const CallHistoryScreen(),
      ),
      GoRoute(
        path: '/room/:id',
        builder: (_, s) => RoomLiveScreen(
          roomId: s.pathParameters['id']!,
          joined: s.extra as RoomJoin?,
        ),
      ),
      GoRoute(
        path: '/schedule/:id',
        builder: (_, s) => ScheduleScreen(companionId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/chat/:id',
        builder: (_, s) => ChatScreen(
          conversationId: s.pathParameters['id']!,
          conversation: s.extra as Conversation?,
        ),
      ),
      GoRoute(
        path: '/legal',
        builder: (_, _) => const LegalIndexScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (_, s) => LegalPageScreen(id: s.pathParameters['id']!),
          ),
        ],
      ),
      GoRoute(
        path: '/call-details',
        builder: (_, s) => CallDetailsScreen(callId: s.extra! as String),
      ),
      GoRoute(
        path: '/delete-account',
        builder: (_, _) => const DeleteAccountScreen(),
      ),
      GoRoute(
        path: '/incoming',
        builder: (_, s) => IncomingScreen(args: s.extra! as IncomingArgs),
      ),
    ],
  );
});

class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) => const Scaffold(
    body: LoveLoader(
      title: 'Hello Dude!',
      subtitle: 'Different languages. Same vibe.',
    ),
  );
}
