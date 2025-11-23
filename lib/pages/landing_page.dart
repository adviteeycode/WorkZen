import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width < 1200;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section - Responsive
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                ),
              ),
              padding: EdgeInsets.all(isMobile ? 24 : 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white30, width: 2),
                    ),
                    child: Icon(
                      Icons.work,
                      color: Colors.white,
                      size: isMobile ? 24 : 32,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'WorkZen',
                    style: TextStyle(
                      fontSize: isMobile ? 36 : 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Complete HRMS Solution for Your Business',
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 18,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: isMobile
                        ? Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () =>
                                      Navigator.pushNamed(context, '/login'),
                                  icon: const Icon(Icons.login, size: 20),
                                  label: const Text('Login'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: theme.colorScheme.primary,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: () =>
                                      Navigator.pushNamed(context, '/register'),
                                  icon: const Icon(Icons.person_add, size: 20),
                                  label: const Text('Register'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    side: const BorderSide(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () =>
                                      Navigator.pushNamed(context, '/login'),
                                  icon: const Icon(Icons.login, size: 20),
                                  label: const Text('Login'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: theme.colorScheme.primary,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () =>
                                      Navigator.pushNamed(context, '/register'),
                                  icon: const Icon(Icons.person_add, size: 20),
                                  label: const Text('Register'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    side: const BorderSide(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),

            // Stats Section
            Padding(
              padding: EdgeInsets.fromLTRB(
                isMobile ? 16 : 32,
                isMobile ? 32 : 48,
                isMobile ? 16 : 32,
                isMobile ? 24 : 32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Platform Statistics',
                    style: theme.textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 24),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('companies')
                        .snapshots(),
                    builder: (context, companySnapshot) {
                      int totalCompanies =
                          companySnapshot.data?.docs.length ?? 0;

                      return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .snapshots(),
                        builder: (context, userSnapshot) {
                          int totalUsers = userSnapshot.data?.docs.length ?? 0;

                          return GridView.count(
                            crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 1.2,
                            children: [
                              _buildStatCard(
                                context,
                                'Registered\nCompanies',
                                totalCompanies.toString(),
                                Icons.business,
                                theme.colorScheme.primary,
                              ),
                              _buildStatCard(
                                context,
                                'Active\nUsers',
                                totalUsers.toString(),
                                Icons.people,
                                Colors.blue,
                              ),
                              _buildStatCard(
                                context,
                                'System\nStatus',
                                'Active',
                                Icons.check_circle,
                                Colors.green,
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            // Features Section
            Padding(
              padding: EdgeInsets.fromLTRB(
                isMobile ? 16 : 32,
                isMobile ? 32 : 48,
                isMobile ? 16 : 32,
                isMobile ? 24 : 32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Key Features', style: theme.textTheme.headlineLarge),
                  const SizedBox(height: 24),
                  GridView.count(
                    crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.0,
                    children: [
                      _buildFeatureCard(
                        context,
                        'Easy Management',
                        'Streamlined employee and company management',
                        Icons.dashboard,
                        theme,
                      ),
                      _buildFeatureCard(
                        context,
                        'Attendance',
                        'Track employee attendance and punctuality',
                        Icons.calendar_today,
                        theme,
                      ),
                      _buildFeatureCard(
                        context,
                        'Leave Management',
                        'Manage leave requests and approvals',
                        Icons.event_available,
                        theme,
                      ),
                      _buildFeatureCard(
                        context,
                        'Payroll Processing',
                        'Automated payroll and salary management',
                        Icons.attach_money,
                        theme,
                      ),
                      _buildFeatureCard(
                        context,
                        'Reports',
                        'Comprehensive analytics and reporting',
                        Icons.assessment,
                        theme,
                      ),
                      _buildFeatureCard(
                        context,
                        'Security',
                        'Enterprise-grade security and compliance',
                        Icons.security,
                        theme,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Companies Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    'Featured Companies',
                    style: theme.textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 24),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('companies')
                        .orderBy('createdAt', descending: true)
                        .limit(6)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(48),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.business_center,
                                  size: isMobile ? 60 : 80,
                                  color: Colors.grey[300],
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'No companies registered yet',
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(color: Colors.grey[600]),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Be the first to register your company!',
                                  style: theme.textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final companies = snapshot.data!.docs;
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.0,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: companies.length,
                        itemBuilder: (context, index) {
                          final company =
                              companies[index].data() as Map<String, dynamic>;
                          final companyName =
                              company['name'] ?? 'Unknown Company';
                          final createdAt = (company['createdAt'] as Timestamp?)
                              ?.toDate();

                          return _buildCompanyCard(
                            context,
                            companyName,
                            createdAt,
                            theme,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            // Footer
            Padding(
              padding: EdgeInsets.all(isMobile ? 16 : 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),
                  Divider(color: Colors.grey[300]),
                  const SizedBox(height: 24),
                  Text(
                    '© 2025 WorkZen - Complete HRMS Solution',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Manage your workforce efficiently',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.colorScheme.outline, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 32, color: color),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(color: color),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  static Widget _buildCompanyCard(
    BuildContext context,
    String companyName,
    DateTime? createdAt,
    ThemeData theme,
  ) {
    final dateStr = createdAt != null
        ? '${createdAt.day}/${createdAt.month}/${createdAt.year}'
        : 'N/A';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.colorScheme.outline, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.primary.withOpacity(0.1),
            ),
            child: Icon(
              Icons.business,
              size: 48,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            companyName,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Text(
            'Registered: $dateStr',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  static Widget _buildFeatureCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.colorScheme.outline, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 32, color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
