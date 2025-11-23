import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workzen/providers/auth_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final user = authProvider.currentUser;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              Text('Profile Settings', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                'View your personal information',
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 32),

              // Profile Info Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: theme.colorScheme.surface,
                  border: Border.all(color: theme.colorScheme.outline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar Section
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: theme.colorScheme.primary,
                            child: Text(
                              '${user?.firstName[0].toUpperCase() ?? 'U'}${user?.lastName[0].toUpperCase() ?? ''}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            user?.email ?? 'user@example.com',
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              user?.role.toString().split('.').last ?? 'User',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Profile Info Display
                    _buildInfoRow('First Name', user?.firstName ?? 'N/A'),
                    const Divider(height: 20),
                    _buildInfoRow('Last Name', user?.lastName ?? 'N/A'),
                    const Divider(height: 20),
                    _buildInfoRow('Email', user?.email ?? 'N/A'),
                    const Divider(height: 20),
                    _buildInfoRow('Phone', user?.phone ?? 'N/A'),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Account Information Section
              Text(
                'Account Information',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: theme.colorScheme.surface,
                  border: Border.all(color: theme.colorScheme.outline),
                ),
                child: Column(
                  children: [
                    _buildInfoRow('User ID', user?.userId ?? 'N/A'),
                    const Divider(height: 20),
                    _buildInfoRow(
                      'Role',
                      user?.role.toString().split('.').last ?? 'N/A',
                    ),
                    const Divider(height: 20),
                    _buildInfoRow('Company', user?.companyId ?? 'N/A'),
                    const Divider(height: 20),
                    _buildInfoRow(
                      'Member Since',
                      user?.createdAt.toString().split(' ')[0] ?? 'N/A',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Security Section
              Text('Security', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.lock),
                  label: const Text('Change Password'),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
