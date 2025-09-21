import 'package:injectable/injectable.dart';
import '../../../../core/errors/exception.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/entities/oauth_session.dart';
import '../../domain/entities/deriv_account.dart';
import 'auth_remote_data_source.dart';
import '../services/oauth_service.dart';

@Injectable(as: IAuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements IAuthRemoteDataSource {
  final OAuthService _oauthService;

  const AuthRemoteDataSourceImpl(this._oauthService);

  @override
  Future<String> startOAuthFlow() async {
    try {
      final sessions = await _oauthService.startOAuthFlow();
      // For backward compatibility, return a success message
      return 'OAuth flow completed with ${sessions.length} sessions';
    } catch (e) {
      throw ServerException(message: 'Failed to start OAuth flow: $e');
    }
  }

  @override
  Future<List<OAuthSession>> startCompleteOAuthFlow() async {
    try {
      return await _oauthService.startOAuthFlow();
    } catch (e) {
      throw ServerException(message: 'Failed to complete OAuth flow: $e');
    }
  }

  @override
  Future<List<OAuthSession>> handleOAuthCallback(String redirectUrl) async {
    try {
      // The OAuth service handles the callback automatically during startOAuthFlow
      // This method can be used for manual callback handling if needed
      final uri = Uri.parse(redirectUrl);
      final queryParams = uri.queryParameters;

      final sessions = <OAuthSession>[];

      // Parse account sessions from query parameters
      // Format: ?acct1=CR123&token1=abc123&cur1=USD&acct2=VR456&token2=def456&cur2=USD
      int accountIndex = 1;
      while (queryParams.containsKey('acct$accountIndex')) {
        final account = queryParams['acct$accountIndex']!;
        final token = queryParams['token$accountIndex']!;
        final currency = queryParams['cur$accountIndex']!;

        sessions.add(
          OAuthSession(account: account, token: token, currency: currency),
        );

        accountIndex++;
      }

      if (sessions.isEmpty) {
        throw const ServerException(
          message: 'No valid sessions found in OAuth callback',
        );
      }

      return sessions;
    } catch (e) {
      throw ServerException(message: 'Failed to handle OAuth callback: $e');
    }
  }

  @override
  Future<AuthUser> authorizeUser(String token) async {
    try {
      // TODO: Replace with actual Deriv API integration
      // For now, return a mock user for development purposes
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      return AuthUser(
        userId: '12345',
        email: 'user@example.com',
        fullName: 'John Doe',
        country: 'US',
        preferredLanguage: 'EN',
        scopes: ['read', 'trade'],
        accounts: [
          DerivAccount(
            loginId: 'CR123456',
            accountType: 'trading',
            currency: 'USD',
            balance: 1000.0,
            isVirtual: false,
            isDisabled: false,
            landingCompanyName: 'svg',
            createdAt: DateTime.now(),
          ),
        ],
        currentAccount: DerivAccount(
          loginId: 'CR123456',
          accountType: 'trading',
          currency: 'USD',
          balance: 1000.0,
          isVirtual: false,
          isDisabled: false,
          landingCompanyName: 'svg',
          createdAt: DateTime.now(),
        ),
      );
    } catch (e) {
      throw ServerException(message: 'Failed to authorize user: $e');
    }
  }
}
