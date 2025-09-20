import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/errors/exception.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/entities/oauth_session.dart';
import '../../domain/entities/deriv_account.dart';
import 'auth_remote_data_source.dart';

@Injectable(as: IAuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements IAuthRemoteDataSource {
  // TODO: Replace with your actual Deriv App ID from https://api.deriv.com/dashboard
  static const String _derivAppId = '1089'; // Demo app ID - replace with yours
  static const String _oauthBaseUrl =
      'https://oauth.deriv.com/oauth2/authorize';

  @override
  Future<String> startOAuthFlow() async {
    try {
      final oauthUrl = '$_oauthBaseUrl?app_id=$_derivAppId';

      final uri = Uri.parse(oauthUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return oauthUrl;
      } else {
        throw const ServerException(message: 'Could not launch OAuth URL');
      }
    } catch (e) {
      throw ServerException(message: 'Failed to start OAuth flow: $e');
    }
  }

  @override
  Future<List<OAuthSession>> handleOAuthCallback(String redirectUrl) async {
    try {
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
