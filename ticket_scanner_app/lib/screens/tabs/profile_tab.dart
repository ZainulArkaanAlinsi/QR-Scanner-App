import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF1A237E),
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
            if (user != null) ...[
              Text(
                user.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                user.email,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 10),
              Chip(
                label: Text(user.role.toUpperCase()),
                backgroundColor:
                    user.isAdmin ? Colors.red.shade100 : Colors.green.shade100,
                labelStyle: TextStyle(
                  color: user.isAdmin
                      ? Colors.red.shade900
                      : Colors.green.shade900,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            const Divider(height: 40),
            ElevatedButton.icon(
              onPressed: () => auth.logout(),
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
