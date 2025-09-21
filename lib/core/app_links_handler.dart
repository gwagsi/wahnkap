import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';

class AppLinksHandler extends StatefulWidget {
  final Widget child;

  const AppLinksHandler({super.key, required this.child});

  @override
  State<AppLinksHandler> createState() => _AppLinksHandlerState();
}

class _AppLinksHandlerState extends State<AppLinksHandler> {
  late AppLinks _appLinks;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _initializeAppLinks();
  }

  Future<void> _initializeAppLinks() async {
    // Handle app launch from deep link
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _handleDeepLink(initialUri);
    }

    // Handle deep links while app is running
    _appLinks.uriLinkStream.listen(
      (Uri uri) => _handleDeepLink(uri),
      onError: (err) => debugPrint('Deep link error: $err'),
    );
  }

  void _handleDeepLink(Uri uri) {
    if (uri.scheme == 'wahnkap' && uri.host == 'oauth-callback') {
      // This is an OAuth callback - let the AuthBloc handle it
      debugPrint('OAuth callback received: $uri');

      // The OAuthService will automatically handle this callback
      // No need to manually trigger anything here since the service
      // has its own listener that will complete the OAuth flow
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
