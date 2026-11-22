import 'package:dio/dio.dart';
import 'package:ronditrack_app/core/data/api_client.dart';
import 'package:ronditrack_app/core/data/auth_calls.dart';
import 'package:ronditrack_app/core/session/refresh_token_store.dart';
import 'package:ronditrack_app/core/session/session.dart';

import 'fake_auth_server.dart';
import 'flavour_config.dart';

/// The app's real session, interceptor and both clients, over a
/// [FakeAuthServer] that rotates and detects reuse the way the API does.
/// One clock for the phone and the server.
class SessionRig {
  /// Builds the rig at [start] (noon on 22 November 2026 by default).
  new({DateTime? start}) : now = start ?? DateTime.utc(2026, 11, 22, 12) {
    server = FakeAuthServer(now: () => now);
    bare = createBareClient(baseUri: _base, log: log.add, adapter: server);
    calls = AuthCalls(bare, cookieName: refreshCookieName);
    session = Session(
      calls: calls,
      store: store,
      onEnded: () => ended++,
      clock: () => now,
    );
    dio = createApiClient(
      baseUri: _base,
      session: session,
      retryClient: bare,
      log: log.add,
      adapter: server,
    );
  }

  static final Uri _base = Uri.parse('http://127.0.0.1:8081');

  /// The phone's and the server's clock.
  DateTime now;

  /// The fake API.
  late final FakeAuthServer server;

  /// The bare client (auth calls and retries).
  late final Dio bare;

  /// The auth calls.
  late final AuthCalls calls;

  /// The session under test.
  late final Session session;

  /// The client every repository uses.
  late final Dio dio;

  /// The phone's refresh token store.
  final InMemoryRefreshTokenStore store = InMemoryRefreshTokenStore();

  /// The app's log lines (the Run console).
  final List<String> log = [];

  /// How many times the session ended.
  int ended = 0;

  /// Signs in through the real login call.
  Future<void> signIn() async => await session.start(
    await calls.login(
      email: 'lerato@ronditrack.example',
      password: server.password,
    ),
  );

  /// GETs [path] on the session's client: its status, or the error.
  Future<Object> get(String path) async {
    try {
      return (await dio.get<Object?>(path)).statusCode!;
    } on DioException catch (error) {
      return error;
    }
  }

  /// How many answers to [path] had [status].
  int answered(String path, int status) =>
      server.log.where((line) => line == '$path $status').length;
}
