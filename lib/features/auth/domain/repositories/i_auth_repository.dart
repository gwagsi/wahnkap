import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/auth_user.dart';
import '../entities/oauth_session.dart';

abstract class IAuthRepository {
  /// Start OAuth authentication flow
  Future<Either<Failure, String>> startOAuthFlow();

  /// Start complete OAuth flow and wait for callback
  Future<Either<Failure, List<OAuthSession>>> startCompleteOAuthFlow();

  /// Handle OAuth redirect and extract sessions
  Future<Either<Failure, List<OAuthSession>>> handleOAuthCallback(
    String redirectUrl,
  );

  /// Authorize user with Deriv API using session token
  Future<Either<Failure, AuthUser>> authorizeUser(String token);

  /// Get current authenticated user
  Future<Either<Failure, AuthUser?>> getCurrentUser();

  /// Logout user and clear session
  Future<Either<Failure, void>> logout();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();

  /// Store user session locally
  Future<Either<Failure, void>> storeUserSession(AuthUser user, String token);

  /// Clear stored user session
  Future<Either<Failure, void>> clearUserSession();
}
