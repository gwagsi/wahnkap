import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/errors/exception.dart';
import '../../domain/entities/oauth_session.dart';

@injectable
class OAuthService {
  static const String _derivAppId = '53485'; // Demo app ID - replace with yours
  static const String _oauthBaseUrl =
      'https://oauth.deriv.com/oauth2/authorize';
  static const String _redirectUrl = 'wahnkap://oauth-callback';

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;
  Completer<List<OAuthSession>>? _oauthCompleter;

  /// Start the OAuth flow and wait for the callback
  Future<List<OAuthSession>> startOAuthFlow() async {
    try {
      debugPrint('🔄 Starting OAuth flow...');

      // Set up the OAuth completer
      _oauthCompleter = Completer<List<OAuthSession>>();

      // Listen for deep links
      await _setupDeepLinkListener();

      // Build OAuth URL with redirect
      final oauthUrl =
          '$_oauthBaseUrl?app_id=$_derivAppId&redirect_uri=${Uri.encodeComponent(_redirectUrl)}';

      debugPrint('🌐 OAuth URL: $oauthUrl');
      debugPrint('🔗 Redirect URL: $_redirectUrl');

      // Launch OAuth URL
      final uri = Uri.parse(oauthUrl);
      if (await canLaunchUrl(uri)) {
        debugPrint('🚀 Launching OAuth URL in browser...');
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        debugPrint('⏳ Waiting for OAuth callback...');
      } else {
        debugPrint('❌ Cannot launch OAuth URL: $oauthUrl');
        throw const ServerException(message: 'Could not launch OAuth URL');
      }

      // Wait for the callback with a timeout
      return await _oauthCompleter!.future.timeout(
        const Duration(minutes: 5),
        onTimeout: () {
          throw const ServerException(message: 'OAuth flow timed out');
        },
      );
    } catch (e) {
      _cleanup();
      throw ServerException(message: 'Failed to complete OAuth flow: $e');
    }
  }

  Future<void> _setupDeepLinkListener() async {
    try {
      debugPrint('🔧 Setting up deep link listener...');

      // Cancel existing subscription
      await _linkSubscription?.cancel();

      // Check for initial link (if app was launched from OAuth)
      final initialUri = await _appLinks.getInitialLink();
      debugPrint('🔍 Initial URI: $initialUri');

      if (initialUri != null && _isOAuthCallback(initialUri)) {
        debugPrint('✅ Found OAuth callback in initial URI');
        _handleOAuthCallback(initialUri);
        return;
      }

      // Listen for new links
      debugPrint('👂 Setting up URI link stream listener...');
      _linkSubscription = _appLinks.uriLinkStream.listen(
        (Uri uri) {
          debugPrint('📨 Received deep link: $uri');
          if (_isOAuthCallback(uri)) {
            debugPrint('✅ OAuth callback detected!');
            _handleOAuthCallback(uri);
          } else {
            debugPrint('❌ Not an OAuth callback: $uri');
          }
        },
        onError: (err) {
          debugPrint('❌ Deep link stream error: $err');
          _oauthCompleter?.completeError(
            ServerException(message: 'Deep link error: $err'),
          );
        },
      );

      debugPrint('✅ Deep link listener setup complete');
    } catch (e) {
      debugPrint('❌ Failed to set up deep link listener: $e');
      throw ServerException(message: 'Failed to set up deep link listener: $e');
    }
  }

  bool _isOAuthCallback(Uri uri) {
    final isCallback = uri.scheme == 'wahnkap' && uri.host == 'oauth-callback';
    debugPrint(
      '🔍 Checking if OAuth callback - Scheme: ${uri.scheme}, Host: ${uri.host}, IsCallback: $isCallback',
    );
    return isCallback;
  }

  void _handleOAuthCallback(Uri uri) {
    try {
      debugPrint('🎯 Processing OAuth callback: $uri');
      debugPrint('📋 Query parameters: ${uri.queryParameters}');

      final sessions = _parseOAuthSessions(uri);
      debugPrint('📊 Parsed ${sessions.length} OAuth sessions');

      if (sessions.isNotEmpty) {
        for (int i = 0; i < sessions.length; i++) {
          debugPrint(
            '💼 Session ${i + 1}: ${sessions[i].account} (${sessions[i].currency})',
          );
        }
        debugPrint('✅ Completing OAuth flow with sessions');
        _oauthCompleter?.complete(sessions);
      } else {
        debugPrint('❌ No valid sessions found in OAuth callback');
        _oauthCompleter?.completeError(
          const ServerException(
            message: 'No valid sessions found in OAuth callback',
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Error handling OAuth callback: $e');
      _oauthCompleter?.completeError(
        ServerException(message: 'Failed to parse OAuth callback: $e'),
      );
    } finally {
      _cleanup();
    }
  }

  List<OAuthSession> _parseOAuthSessions(Uri uri) {
    final sessions = <OAuthSession>[];
    final queryParams = uri.queryParameters;

    debugPrint('🔧 Parsing OAuth sessions from query parameters...');
    debugPrint('📋 Available parameters: ${queryParams.keys.toList()}');

    // Parse account sessions from query parameters
    int accountIndex = 1;
    while (queryParams.containsKey('acct$accountIndex')) {
      final account = queryParams['acct$accountIndex'];
      final token = queryParams['token$accountIndex'];
      final currency = queryParams['cur$accountIndex'];

      debugPrint(
        '🔍 Account $accountIndex - acct: $account, token: ${token?.substring(0, 10)}..., cur: $currency',
      );

      if (account != null && token != null && currency != null) {
        sessions.add(
          OAuthSession(account: account, token: token, currency: currency),
        );
        debugPrint('✅ Added session for account: $account');
      } else {
        debugPrint('❌ Incomplete session data for account $accountIndex');
      }

      accountIndex++;
    }

    debugPrint('📊 Total sessions parsed: ${sessions.length}');
    return sessions;
  }

  void _cleanup() {
    _linkSubscription?.cancel();
    _linkSubscription = null;
    _oauthCompleter = null;
  }

  void dispose() {
    _cleanup();
  }
}
