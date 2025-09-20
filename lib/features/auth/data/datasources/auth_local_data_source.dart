import '../../domain/entities/auth_user.dart';

abstract class IAuthLocalDataSource {
  /// Store user session locally
  Future<void> storeUserSession(AuthUser user, String token);

  /// Get current stored user
  Future<AuthUser?> getCurrentUser();

  /// Get stored auth token
  Future<String?> getStoredToken();

  /// Clear stored user session
  Future<void> clearUserSession();

  /// Check if user session exists
  Future<bool> hasUserSession();
}
