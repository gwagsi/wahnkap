import '../../domain/entities/auth_user.dart';
import '../../domain/entities/oauth_session.dart';

abstract class IAuthRemoteDataSource {
  /// Start OAuth authentication flow
  Future<String> startOAuthFlow();

  /// Start complete OAuth flow and wait for callback
  Future<List<OAuthSession>> startCompleteOAuthFlow();

  /// Handle OAuth redirect and extract sessions
  Future<List<OAuthSession>> handleOAuthCallback(String redirectUrl);

  /// Authorize user with Deriv API using session token
  Future<AuthUser> authorizeUser(String token);
}
