import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exception.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/entities/oauth_session.dart';
import '../models/auth_user_model.dart';
import 'auth_local_data_source.dart';

@Injectable(as: IAuthLocalDataSource)
class AuthLocalDataSourceImpl implements IAuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String _userKey = 'CACHED_USER';
  static const String _tokenKey = 'AUTH_TOKEN';
  static const String _sessionsKey = 'OAUTH_SESSIONS';
  static const String _primaryTokenKey = 'PRIMARY_TOKEN';

  AuthLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> storeUserSession(AuthUser user, String token) async {
    try {
      final userModel = AuthUserModel(
        userId: user.userId,
        email: user.email,
        fullName: user.fullName,
        country: user.country,
        preferredLanguage: user.preferredLanguage,
        scopes: user.scopes,
        accounts: user.accounts,
        currentAccount: user.currentAccount,
      );

      await Future.wait([
        sharedPreferences.setString(_userKey, json.encode(userModel.toJson())),
        sharedPreferences.setString(_tokenKey, token),
      ]);
    } catch (e) {
      throw CacheException(message: 'Failed to store user session: $e');
    }
  }

  @override
  Future<AuthUser?> getCurrentUser() async {
    try {
      final userJson = sharedPreferences.getString(_userKey);
      if (userJson != null) {
        final userMap = json.decode(userJson) as Map<String, dynamic>;
        return AuthUserModel.fromJson(userMap);
      }
      return null;
    } catch (e) {
      throw CacheException(message: 'Failed to get current user: $e');
    }
  }

  @override
  Future<String?> getStoredToken() async {
    try {
      return sharedPreferences.getString(_tokenKey);
    } catch (e) {
      throw CacheException(message: 'Failed to get stored token: $e');
    }
  }

  @override
  Future<void> clearUserSession() async {
    try {
      await Future.wait([
        sharedPreferences.remove(_userKey),
        sharedPreferences.remove(_tokenKey),
        sharedPreferences.remove(_sessionsKey),
        sharedPreferences.remove(_primaryTokenKey),
      ]);
    } catch (e) {
      throw CacheException(message: 'Failed to clear user session: $e');
    }
  }

  @override
  Future<bool> hasUserSession() async {
    try {
      return sharedPreferences.containsKey(_userKey) &&
          sharedPreferences.containsKey(_tokenKey);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> storeOAuthSessions(List<OAuthSession> sessions, String primaryToken) async {
    try {
      final sessionsJson = sessions.map((session) => {
        'account': session.account,
        'token': session.token,
        'currency': session.currency,
      }).toList();

      await Future.wait([
        sharedPreferences.setString(_sessionsKey, json.encode(sessionsJson)),
        sharedPreferences.setString(_primaryTokenKey, primaryToken),
      ]);
    } catch (e) {
      throw CacheException(message: 'Failed to store OAuth sessions: $e');
    }
  }

  @override
  Future<List<OAuthSession>> getStoredSessions() async {
    try {
      final sessionsJson = sharedPreferences.getString(_sessionsKey);
      if (sessionsJson != null) {
        final sessionsList = json.decode(sessionsJson) as List<dynamic>;
        return sessionsList.map((sessionMap) {
          final map = sessionMap as Map<String, dynamic>;
          return OAuthSession(
            account: map['account'] as String,
            token: map['token'] as String,
            currency: map['currency'] as String,
          );
        }).toList();
      }
      return [];
    } catch (e) {
      throw CacheException(message: 'Failed to get stored sessions: $e');
    }
  }

  @override
  Future<String?> getPrimaryToken() async {
    try {
      return sharedPreferences.getString(_primaryTokenKey);
    } catch (e) {
      return null;
    }
  }
}
