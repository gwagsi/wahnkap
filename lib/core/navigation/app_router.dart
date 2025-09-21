import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../debug/debug_oauth_page.dart';
import '../../features/auth/presentation/pages/welcome_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import 'app_shell.dart';

class AppRouter {
  static const String welcome = '/';
  static const String dashboard = '/dashboard';
  static const String payments = '/payments';
  static const String tradingBots = '/trading-bots';
  static const String investments = '/investments';
  static const String profile = '/profile';
  static const String debugOAuth = '/debug-oauth';

  static final GoRouter _router = GoRouter(
    initialLocation: welcome,
    routes: [
      GoRoute(path: welcome, builder: (context, state) => const WelcomePage()),
      GoRoute(
        path: debugOAuth,
        builder: (context, state) => const DebugOAuthPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: dashboard,
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: payments,
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Payments Page - Coming Soon')),
            ),
          ),
          GoRoute(
            path: tradingBots,
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Trading Bots Page - Coming Soon')),
            ),
          ),
          GoRoute(
            path: investments,
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Investments Page - Coming Soon')),
            ),
          ),
          GoRoute(
            path: profile,
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Profile Page - Coming Soon')),
            ),
          ),
        ],
      ),
    ],
  );

  static GoRouter get router => _router;
}
