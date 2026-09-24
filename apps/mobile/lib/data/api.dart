import 'package:pesu_api/api.dart';

import '../app/config.dart';

/// One generated-client instance for the whole app, plus the "refresh the
/// access token once on 401 and retry" rule every signed-in call needs.
class PesuApi {
  PesuApi() : _bearer = HttpBearerAuth() {
    _client = ApiClient(
      basePath: AppConfig.apiBaseUrl,
      authentication: _bearer,
    );
    auth = AuthApi(_client);
    profile = ProfileApi(_client);
    wallet = WalletApi(_client);
    companions = CompanionsApi(_client);
    calls = CallsApi(_client);
    safety = SafetyApi(_client);
    companion = CompanionApi(_client);
    favourites = FavouritesApi(_client);
    legal = LegalApi(_client);
    notifications = NotificationsApi(_client);
    growth = GrowthApi(_client);
    chat = ChatApi(_client);
    bookings = BookingsApi(_client);
    vip = VipApi(_client);
    rooms = RoomsApi(_client);
    promotions = PromotionsApi(_client);
    lives = LivesApi(_client);
    groups = GroupsApi(_client);
    photos = PhotosApi(_client);
  }

  final HttpBearerAuth _bearer;
  late final ApiClient _client;
  late final AuthApi auth;
  late final ProfileApi profile;
  late final WalletApi wallet;
  late final CompanionsApi companions;
  late final CallsApi calls;
  late final SafetyApi safety;
  late final CompanionApi companion;
  late final FavouritesApi favourites;
  late final LegalApi legal;
  late final NotificationsApi notifications;
  late final GrowthApi growth;
  late final ChatApi chat;
  late final BookingsApi bookings;
  late final VipApi vip;
  late final RoomsApi rooms;
  late final PromotionsApi promotions;
  late final LivesApi lives;
  late final GroupsApi groups;
  late final PhotosApi photos;

  /// Set by the session: returns a fresh access token, or null if signed out.
  Future<String?> Function()? onUnauthorized;

  String? _token;
  String? get currentAccessToken => _token;
  set accessToken(String? token) {
    _token = token;
    _bearer.accessToken = token ?? '';
  }

  /// Runs [request]; on 401 asks the session for a new token and retries once.
  Future<T> call<T>(Future<T?> Function() request) async {
    try {
      return _required(await request());
    } on ApiException catch (e) {
      if (e.code != 401 || onUnauthorized == null) rethrow;
      final fresh = await onUnauthorized!();
      if (fresh == null) rethrow;
      accessToken = fresh;
      return _required(await request());
    }
  }

  /// For requests that answer "204 No Content" (save, delete, mark read…):
  /// like [call], but an empty reply is success, not an error.
  Future<void> send(Future<Object?> Function() request) async {
    try {
      await request();
    } on ApiException catch (e) {
      if (e.code != 401 || onUnauthorized == null) rethrow;
      final fresh = await onUnauthorized!();
      if (fresh == null) rethrow;
      accessToken = fresh;
      await request();
    }
  }

  T _required<T>(T? value) {
    if (value == null && null is! T)
      throw ApiException(500, 'Empty response from server');
    return value as T;
  }
}
