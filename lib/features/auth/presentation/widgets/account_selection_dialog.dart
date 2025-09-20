import 'package:flutter/material.dart';
import '../../domain/entities/oauth_session.dart';

class AccountSelectionDialog extends StatelessWidget {
  final List<OAuthSession> sessions;
  final Function(String token) onAccountSelected;

  const AccountSelectionDialog({
    super.key,
    required this.sessions,
    required this.onAccountSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Account'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Choose which Deriv account to connect:'),
          const SizedBox(height: 16),
          ...sessions.map((session) => _buildAccountTile(context, session)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  Widget _buildAccountTile(BuildContext context, OAuthSession session) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text(session.currency)),
        title: Text('Account: ${session.account}'),
        subtitle: Text('Currency: ${session.currency}'),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onAccountSelected(session.token);
          },
          child: const Text('Connect'),
        ),
      ),
    );
  }
}
