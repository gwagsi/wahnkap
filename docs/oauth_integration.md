# OAuth Integration Guide

## Overview
This document explains how OAuth authentication works in the Wahnkap Flutter app, specifically for Deriv API integration.

## Architecture

### OAuth Service (`lib/features/auth/data/services/oauth_service.dart`)
The main service that handles the complete OAuth flow:

1. **OAuth URL Construction**: Creates the Deriv OAuth URL with proper redirect URI
2. **Deep Link Listening**: Sets up listeners for OAuth callback deep links
3. **Browser Launch**: Opens the OAuth URL in an external browser
4. **Callback Handling**: Processes the redirect back to the app
5. **Token Extraction**: Parses OAuth sessions from the callback URL

### Key Components

#### 1. OAuth Flow Initiation
```dart
Future<List<OAuthSession>> startOAuthFlow() async
```
- Constructs OAuth URL: `https://oauth.deriv.com/oauth2/authorize?app_id=53485&redirect_uri=wahnkap://oauth-callback`
- Sets up deep link listeners before launching browser
- Returns list of OAuth sessions after successful authentication

#### 2. Deep Link Configuration

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="wahnkap" android:host="oauth-callback" />
</intent-filter>
```

**iOS** (`ios/Runner/Info.plist`):
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>wahnkap.oauth</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>wahnkap</string>
        </array>
    </dict>
</array>
```

#### 3. URL Structure

**OAuth URL**: 
```
https://oauth.deriv.com/oauth2/authorize?app_id=53485&redirect_uri=wahnkap://oauth-callback
```

**Callback URL**: 
```
wahnkap://oauth-callback?acct1=CR123456&token1=a1-abc123&cur1=USD&acct2=VRTC123456&token2=a1-def456&cur2=USD
```

#### 4. Session Parsing
The service extracts multiple trading accounts from the callback URL:
- `acct1`, `acct2`, ... - Account identifiers
- `token1`, `token2`, ... - API tokens for each account
- `cur1`, `cur2`, ... - Account currencies

## Usage Example

```dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final OAuthService oauthService;

  AuthBloc(this.oauthService) : super(AuthInitial()) {
    on<AuthStartOAuth>(_onStartOAuth);
  }

  Future<void> _onStartOAuth(AuthStartOAuth event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final sessions = await oauthService.startOAuthFlow();
      // Process the OAuth sessions...
      emit(AuthOAuthSuccess(sessions));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
```

## Error Handling

The OAuth service includes comprehensive error handling for:
- Network failures
- Invalid callback URLs
- Timeout scenarios (5-minute limit)
- Deep link configuration issues

## Testing

Test files are located at:
- `test/features/auth/oauth_service_test.dart` - Unit tests for OAuth service

## Security Considerations

1. **App ID**: Using demo app ID (53485) - replace with production ID
2. **Redirect URI**: Must match exactly between OAuth service and platform configurations
3. **Token Storage**: Consider secure storage for production OAuth tokens
4. **Timeout**: 5-minute timeout prevents indefinite waiting

## Dependencies

- `app_links: ^6.3.2` - Deep link handling
- `url_launcher: ^6.0.0` - Browser launching
- `injectable: ^2.4.4` - Dependency injection

## Troubleshooting

### Common Issues:

1. **App not opening after OAuth**: Check platform deep link configurations
2. **OAuth URL not launching**: Verify `url_launcher` permissions
3. **Callback not received**: Ensure redirect URI matches exactly
4. **Parse errors**: Check OAuth callback URL format

### Debug Steps:

1. Verify Android intent filters are correctly configured
2. Check iOS URL schemes in Info.plist
3. Test deep link manually: `adb shell am start -W -a android.intent.action.VIEW -d "wahnkap://oauth-callback?test=true"`
4. Monitor logs during OAuth flow for error messages

## Production Deployment

Before production deployment:

1. **Replace Demo App ID**: Update `_derivAppId` with your production Deriv app ID
2. **Secure Token Storage**: Implement secure storage for OAuth tokens
3. **Error Monitoring**: Add comprehensive error tracking
4. **Testing**: Test OAuth flow on physical devices for both platforms

## Integration with Clean Architecture

The OAuth service follows Clean Architecture principles:

- **Domain Layer**: `OAuthSession` entity defines the contract
- **Data Layer**: `OAuthService` implements the OAuth logic
- **Presentation Layer**: `AuthBloc` coordinates between UI and OAuth service

This separation ensures testability and maintainability of the OAuth implementation.