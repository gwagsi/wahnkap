import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth_event.dart';
import '../features/auth/presentation/bloc/auth_state.dart';

class DebugOAuthPage extends StatelessWidget {
  const DebugOAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debug OAuth')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is AuthSessionsReceived) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Success! Got ${state.sessions.length} sessions'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Current State: ${state.runtimeType}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),

                if (state is AuthLoginInProgress)
                  const Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'OAuth in progress... Check your browser and return to the app',
                      ),
                    ],
                  ),

                if (state is AuthSessionsReceived) ...[
                  Text('Sessions received: ${state.sessions.length}'),
                  const SizedBox(height: 8),
                  ...state.sessions.map(
                    (session) => Card(
                      child: ListTile(
                        title: Text('Account: ${session.account}'),
                        subtitle: Text('Currency: ${session.currency}'),
                        trailing: Text(
                          session.token.length > 20
                              ? '${session.token.substring(0, 20)}...'
                              : session.token,
                        ),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: state is AuthLoginInProgress
                      ? null
                      : () {
                          debugPrint('🔴 User tapped OAuth button');
                          context.read<AuthBloc>().add(AuthLoginStarted());
                        },
                  child: const Text('Start OAuth Flow'),
                ),

                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    debugPrint('🔴 Manual test deep link');
                    // Test the deep link parsing manually
                    context.read<AuthBloc>().add(
                      AuthOAuthCallbackReceived(
                        redirectUrl:
                            'wahnkap://oauth-callback?acct1=TEST123&token1=test-token&cur1=USD',
                      ),
                    );
                  },
                  child: const Text('Test Manual Callback'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
