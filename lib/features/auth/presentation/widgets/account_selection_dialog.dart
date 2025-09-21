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
      content: SizedBox(
        width: double.maxFinite,
        height: 400, // Fixed height to prevent overflow
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Choose which Deriv account to connect:'),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  return _buildAccountTile(context, sessions[index]);
                },
              ),
            ),
          ],
        ),
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
    // Get account type for better display
    final isDemo = session.account.startsWith('VRTC');
    final accountType = isDemo ? 'Demo' : 'Real';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: isDemo ? Colors.orange : Colors.green,
          child: Text(
            session.currency,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        title: Text(
          session.account,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '$accountType Account • ${session.currency}',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onAccountSelected(session.token);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: const Text('Connect'),
        ),
      ),
    );
  }
}
