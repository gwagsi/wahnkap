import '../../domain/entities/auth_user.dart';
import '../../domain/entities/oauth_session.dart';

abstract class IAuthLocalDataSource {
  /// Store user session locally
  Future<void> storeUserSession(AuthUser user, String token);

  /// Store all OAuth sessions with primary account
  Future<void> storeOAuthSessions(
    List<OAuthSession> sessions,
    String primaryToken,
  );

  /// Get current stored user
  Future<AuthUser?> getCurrentUser();

  /// Get stored auth token
  Future<String?> getStoredToken();

  /// Get all stored OAuth sessions
  Future<List<OAuthSession>> getStoredSessions();

  /// Get primary account token
  Future<String?> getPrimaryToken();

  /// Clear stored user session
  Future<void> clearUserSession();

  /// Check if user session exists
  Future<bool> hasUserSession();
}
