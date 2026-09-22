import 'package:flutter/material.dart';
import 'package:frontend_admin/app/theme/app_colors.dart';
import 'package:frontend_admin/app/theme/app_text_styles.dart';
import 'package:frontend_admin/features/admin/dashboard/presentation/widgets/admin_layout.dart';
import 'package:frontend_admin/features/admin/dashboard/presentation/widgets/admin_stat_card.dart';
import 'package:frontend_admin/features/admin/dashboard/presentation/widgets/recent_activity_card.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Statistics
    final stats = [
      {
        'title': 'Total Users',
        'value': '1,248',
        'subtitle': 'from last month',
        'trend': '+12.4%',
        'icon': Icons.people_outline_rounded,
        'iconColor': AppColors.primary,
        'iconBgColor': AppColors.primaryContainer,
      },
      {
        'title': 'Active Users',
        'value': '1,084',
        'subtitle': '86.8% active rate',
        'trend': '+8.1%',
        'icon': Icons.person_pin_circle_outlined,
        'iconColor': AppColors.success,
        'iconBgColor': AppColors.successLight,
      },
      {
        'title': 'Total Resumes',
        'value': '3,412',
        'subtitle': '2.7 avg / user',
        'trend': '+18.5%',
        'icon': Icons.description_outlined,
        'iconColor': AppColors.secondary,
        'iconBgColor': const Color(0xFFE0F2FE),
      },
      {
        'title': 'Resumes Today',
        'value': '78',
        'subtitle': 'vs yesterday (62)',
        'trend': '+25.8%',
        'icon': Icons.today_outlined,
        'iconColor': AppColors.accent,
        'iconBgColor': const Color(0xFFF3E8FF),
      },
      {
        'title': 'Average ATS Score',
        'value': '84.6',
        'subtitle': '100-pt Readability',
        'trend': '+3.2%',
        'icon': Icons.analytics_outlined,
        'iconColor': AppColors.warning,
        'iconBgColor': AppColors.warningLight,
      },
      {
        'title': 'Total Templates',
        'value': '4',
        'subtitle': '100% ATS Compliant',
        'trend': 'Stable',
        'icon': Icons.dashboard_customize_outlined,
        'iconColor': AppColors.info,
        'iconBgColor': AppColors.infoLight,
      },
    ];

    final recentUsers = [
      {'name': 'Rohan Sharma', 'email': 'rohan.sharma@example.com', 'status': 'Active', 'joined': 'Today, 2:15 PM'},
      {'name': 'Priya Patel', 'email': 'priya.patel@example.com', 'status': 'Active', 'joined': 'Today, 1:40 PM'},
      {'name': 'Vikram Singh', 'email': 'vikram.singh@example.com', 'status': 'Inactive', 'joined': 'Yesterday'},
      {'name': 'Ananya Roy', 'email': 'ananya.roy@example.com', 'status': 'Active', 'joined': 'Sep 16, 2026'},
      {'name': 'Sameer Joshi', 'email': 'sameer.j@example.com', 'status': 'Active', 'joined': 'Sep 15, 2026'},
    ];

    final recentResumes = [
      {'resume': 'Software_Engineer_v2.pdf', 'user': 'Rohan Sharma', 'template': 'ATS Classic', 'atsScore': 92, 'updated': '10m ago'},
      {'resume': 'Product_Manager_Resume.pdf', 'user': 'Priya Patel', 'template': 'ATS Professional', 'atsScore': 86, 'updated': '35m ago'},
      {'resume': 'Data_Analyst_Fresher.pdf', 'user': 'Vikram Singh', 'template': 'ATS Fresher', 'atsScore': 58, 'updated': '2h ago'},
      {'resume': 'DevOps_Architect.pdf', 'user': 'Ananya Roy', 'template': 'ATS Experienced', 'atsScore': 94, 'updated': '4h ago'},
      {'resume': 'Frontend_Lead.pdf', 'user': 'Sameer Joshi', 'template': 'ATS Professional', 'atsScore': 74, 'updated': '1d ago'},
    ];

    return AdminLayout(
      title: 'Dashboard Overview',
      currentPath: '/admin/dashboard',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ResumeForge ATS Metrics & Management',
                          style: AppTextStyles.h2(color: Colors.white),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Monitor real-time user registrations, resume generation, and ATS readability health.',
                          style: AppTextStyles.bodyMedium(color: Colors.white.withValues(alpha: 0.85)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Stat Cards Grid
            LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = 3;
                if (constraints.maxWidth < 640) {
                  crossAxisCount = 1;
                } else if (constraints.maxWidth < 1100) {
                  crossAxisCount = 2;
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    mainAxisExtent: 140,
                  ),
                  itemCount: stats.length,
                  itemBuilder: (context, index) {
                    final item = stats[index];
                    return AdminStatCard(
                      title: item['title'] as String,
                      value: item['value'] as String,
                      subtitle: item['subtitle'] as String?,
                      trend: item['trend'] as String?,
                      icon: item['icon'] as IconData,
                      iconColor: item['iconColor'] as Color?,
                      iconBgColor: item['iconBgColor'] as Color?,
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 24),

            // ATS Overview Card
            const AtsOverviewCard(
              averageScore: 84.6,
              highScore: 2420,
              mediumScore: 780,
              lowScore: 212,
            ),
            const SizedBox(height: 24),

            // Recent Tables Layout
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= 1000) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: RecentUsersCard(users: recentUsers)),
                      const SizedBox(width: 20),
                      Expanded(child: RecentResumesCard(resumes: recentResumes)),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      RecentUsersCard(users: recentUsers),
                      const SizedBox(height: 20),
                      RecentResumesCard(resumes: recentResumes),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
