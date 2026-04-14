import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/utils/const.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(Const.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'My Profile',
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 32),
              
              // Profile Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                  child: Column(
                    children: [
                      // Avatar
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [theme.primaryColor, theme.primaryColor.withValues(alpha: 0.7)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: theme.primaryColor.withValues(alpha: 0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.person_rounded, size: 50, color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      if (user != null) ...[
                        Text(
                          user.name,
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: user.isAdmin ? Colors.red.withValues(alpha: 0.1) : Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            user.role.toUpperCase(),
                            style: TextStyle(
                              color: user.isAdmin ? Colors.red : Colors.green,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              
              // Settings list
              _buildSettingItem(context, Icons.person_outline, 'Personal Information', () {}),
              _buildSettingItem(context, Icons.notifications_none_outlined, 'Notifications', () {}),
              _buildSettingItem(context, Icons.security_outlined, 'Security & Password', () {}),
              _buildSettingItem(context, Icons.help_outline, 'Help Center', () {}),
              const SizedBox(height: 40),
              
              // Logout Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: TextButton(
                  onPressed: () async {
                    await auth.logout();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                    backgroundColor: Colors.red.withValues(alpha: 0.05),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, size: 20),
                      const SizedBox(width: 12),
                      Text('Log Out', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.grey.shade700, size: 22),
          ),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
          onTap: onTap,
        ),
        Divider(color: Colors.grey.shade50, height: 1),
      ],
    );
  }
}
