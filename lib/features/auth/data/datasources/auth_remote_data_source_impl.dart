import 'package:flutter_deriv_api/flutter_deriv_api.dart';
import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/errors/exception.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/entities/oauth_session.dart';
import '../models/auth_user_model.dart';
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
      // Initialize Deriv API
      APIInitializer().initialize();

      final api = Injector.getInjector()!.get<BaseAPI>();

      // Connect to Deriv WebSocket
      await api.connect(
        ConnectionInformation(
          appId: _derivAppId,
          brand: 'deriv',
          endpoint: 'frontend.binaryws.com',
          language: 'EN',
        ),
      );

      // Authorize user with the token
      final authorizeRequest = AuthorizeRequest(authorize: token);
      final response = await api.call(request: authorizeRequest);

      if (response is AuthorizeResponse) {
        // Convert response to our domain model
        return AuthUserModel.fromApiResponse(response.toJson());
      }

      throw const ServerException(message: 'Invalid authorize response');
    } catch (e) {
      throw ServerException(message: 'Failed to authorize user: $e');
    }
  }
}
