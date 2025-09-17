import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_state_widget.dart';
import './widgets/feature_card.dart';
import './widgets/quick_stats_card.dart';
import './widgets/recent_report_card.dart';
import './widgets/welcome_header.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  String _username = 'Rajesh Kumar';
  DateTime _lastUpdated = DateTime.now();

  // Mock data for dashboard
  final List<Map<String, dynamic>> _recentReports = [
    {
      "id": 1,
      "title": "Broken Street Light on Main Road",
      "category": "Infrastructure",
      "status": "In Progress",
      "imageUrl":
          "https://images.pexels.com/photos/1108572/pexels-photo-1108572.jpeg?auto=compress&cs=tinysrgb&w=400",
      "submissionDate": DateTime.now().subtract(Duration(days: 2)),
      "location": "Main Road, Ranchi",
    },
    {
      "id": 2,
      "title": "Pothole Near School Gate",
      "category": "Road Maintenance",
      "status": "Submitted",
      "imageUrl":
          "https://images.pexels.com/photos/163064/play-stone-network-networked-interactive-163064.jpeg?auto=compress&cs=tinysrgb&w=400",
      "submissionDate": DateTime.now().subtract(Duration(days: 5)),
      "location": "School Road, Dhanbad",
    },
    {
      "id": 3,
      "title": "Water Logging in Residential Area",
      "category": "Drainage",
      "status": "Resolved",
      "imageUrl":
          "https://images.pexels.com/photos/1108572/pexels-photo-1108572.jpeg?auto=compress&cs=tinysrgb&w=400",
      "submissionDate": DateTime.now().subtract(Duration(days: 10)),
      "location": "Housing Colony, Jamshedpur",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadDashboardData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(Duration(milliseconds: 800));

    setState(() {
      _isLoading = false;
      _lastUpdated = DateTime.now();
    });
  }

  Future<void> _refreshDashboard() async {
    await _loadDashboardData();
  }

  void _navigateToNewReport() {
    Navigator.pushNamed(context, '/new-report-screen');
  }

  void _navigateToReportDetails(Map<String, dynamic> report) {
    Navigator.pushNamed(
      context,
      '/report-details-screen',
      arguments: report,
    );
  }

  void _showReportActions(Map<String, dynamic> report) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'visibility',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: Text('View Details'),
              onTap: () {
                Navigator.pop(context);
                _navigateToReportDetails(report);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 24,
              ),
              title: Text('Share Report'),
              onTap: () {
                Navigator.pop(context);
                // Implement share functionality
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  int get _totalReports => _recentReports.length;
  int get _submittedCount => _recentReports
      .where((r) => (r['status'] as String).toLowerCase() == 'submitted')
      .length;
  int get _inProgressCount => _recentReports
      .where((r) => (r['status'] as String).toLowerCase() == 'in progress')
      .length;
  int get _resolvedCount => _recentReports
      .where((r) => (r['status'] as String).toLowerCase() == 'resolved')
      .length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Welcome Header
          WelcomeHeader(username: _username),

          // Tab Bar
          Container(
            color: AppTheme.lightTheme.scaffoldBackgroundColor,
            child: TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  icon: CustomIconWidget(
                    iconName: 'dashboard',
                    color: _tabController.index == 0
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  text: 'Dashboard',
                ),
                Tab(
                  icon: CustomIconWidget(
                    iconName: 'assignment',
                    color: _tabController.index == 1
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  text: 'My Reports',
                ),
                Tab(
                  icon: CustomIconWidget(
                    iconName: 'notifications',
                    color: _tabController.index == 2
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  text: 'Notifications',
                ),
                Tab(
                  icon: CustomIconWidget(
                    iconName: 'person',
                    color: _tabController.index == 3
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  text: 'Profile',
                ),
              ],
              labelColor: AppTheme.lightTheme.primaryColor,
              unselectedLabelColor:
                  AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              indicatorColor: AppTheme.lightTheme.primaryColor,
              labelStyle: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: AppTheme.lightTheme.textTheme.labelSmall,
            ),
          ),

          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDashboardTab(),
                _buildMyReportsTab(),
                _buildNotificationsTab(),
                _buildProfileTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToNewReport,
        backgroundColor: AppTheme.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        child: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildDashboardTab() {
    return RefreshIndicator(
      onRefresh: _refreshDashboard,
      color: AppTheme.lightTheme.primaryColor,
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppTheme.lightTheme.primaryColor,
              ),
            )
          : SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),

                  // Quick Stats Card
                  QuickStatsCard(
                    totalReports: _totalReports,
                    submittedCount: _submittedCount,
                    inProgressCount: _inProgressCount,
                    resolvedCount: _resolvedCount,
                  ),

                  SizedBox(height: 2.h),

                  // Recent Activity Section
                  if (_recentReports.isNotEmpty) ...[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Activity',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _tabController.animateTo(1);
                            },
                            child: Text(
                              'View All',
                              style: AppTheme.lightTheme.textTheme.labelMedium
                                  ?.copyWith(
                                color: AppTheme.lightTheme.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Recent Reports List
                    ...(_recentReports
                        .take(3)
                        .map((report) => RecentReportCard(
                              report: report,
                              onTap: () => _navigateToReportDetails(report),
                              onLongPress: () => _showReportActions(report),
                            ))
                        .toList()),
                  ],

                  SizedBox(height: 2.h),

                  // Feature Cards Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Text(
                      'Quick Actions',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h),

                  FeatureCard(
                    title: 'View All Reports',
                    subtitle: 'See all your submitted reports and their status',
                    iconName: 'list_alt',
                    onTap: () {
                      _tabController.animateTo(1);
                    },
                  ),

                  FeatureCard(
                    title: 'Emergency Issues',
                    subtitle:
                        'Report urgent civic issues that need immediate attention',
                    iconName: 'emergency',
                    iconColor: Colors.red,
                    onTap: () {
                      Navigator.pushNamed(context, '/new-report-screen',
                          arguments: {'emergency': true});
                    },
                  ),

                  FeatureCard(
                    title: 'Government Updates',
                    subtitle:
                        'Latest news and announcements from Jharkhand Government',
                    iconName: 'campaign',
                    iconColor: AppTheme.lightTheme.colorScheme.secondary,
                    onTap: () {
                      // Navigate to government updates
                    },
                  ),

                  SizedBox(height: 2.h),

                  // Last Updated Info
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'sync',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 16,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Last updated: ${_formatLastUpdated(_lastUpdated)}',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
    );
  }

  Widget _buildMyReportsTab() {
    return _recentReports.isEmpty
        ? EmptyStateWidget(
            onCreateReport: _navigateToNewReport,
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 2.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'All Reports (${_recentReports.length})',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Show filter options
                        },
                        icon: CustomIconWidget(
                          iconName: 'filter_list',
                          color: AppTheme.lightTheme.primaryColor,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                ..._recentReports
                    .map((report) => RecentReportCard(
                          report: report,
                          onTap: () => _navigateToReportDetails(report),
                          onLongPress: () => _showReportActions(report),
                        ))
                    .toList(),
                SizedBox(height: 4.h),
              ],
            ),
          );
  }

  Widget _buildNotificationsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'notifications_none',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'No Notifications',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'You\'ll receive updates about your reports here',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 4.h),
          // Profile Avatar
          Container(
            width: 25.w,
            height: 25.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.lightTheme.primaryColor,
                size: 48,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            _username,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            'rajesh.kumar@email.com',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 4.h),

          // Profile Options
          _buildProfileOption('Edit Profile', 'person_outline', () {}),
          _buildProfileOption('Change Password', 'lock_outline', () {}),
          _buildProfileOption('Privacy Policy', 'privacy_tip_outlined', () {}),
          _buildProfileOption(
              'Terms of Service', 'description_outlined', () {}),
          _buildProfileOption('Help & Support', 'help_outline', () {}),
          _buildProfileOption('Logout', 'logout', () {
            Navigator.pushNamedAndRemoveUntil(
                context, '/login-screen', (route) => false);
          }, isDestructive: true),

          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildProfileOption(String title, String iconName, VoidCallback onTap,
      {bool isDestructive = false}) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
      child: ListTile(
        leading: CustomIconWidget(
          iconName: iconName,
          color: isDestructive ? Colors.red : AppTheme.lightTheme.primaryColor,
          size: 24,
        ),
        title: Text(
          title,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: isDestructive ? Colors.red : null,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: CustomIconWidget(
          iconName: 'chevron_right',
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 20,
        ),
        onTap: onTap,
      ),
    );
  }

  String _formatLastUpdated(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
