import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/government_response_widget.dart';
import './widgets/image_gallery_widget.dart';
import './widgets/location_map_widget.dart';
import './widgets/status_timeline_widget.dart';
import './widgets/voice_player_widget.dart';

class ReportDetailsScreen extends StatefulWidget {
  const ReportDetailsScreen({Key? key}) : super(key: key);

  @override
  State<ReportDetailsScreen> createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen> {
  // Mock data for the report details
  final Map<String, dynamic> reportData = {
    "id": "RPT-2025-001234",
    "title": "Broken Street Light on Main Road",
    "category": "Infrastructure",
    "priority": "Medium",
    "status": "In Progress",
    "description":
        """The street light near the bus stop on Main Road has been broken for the past week. This is causing safety concerns for pedestrians, especially during evening hours. The light pole appears to be intact, but the bulb and electrical connections seem to be damaged. 

This area is frequently used by students and office workers returning home in the evening. The lack of proper lighting is making it difficult for people to walk safely, and there have been reports of minor accidents due to poor visibility.

I request the concerned authorities to please fix this issue at the earliest to ensure public safety.""",
    "submittedDate": "08/01/2025",
    "reviewDate": "09/01/2025",
    "progressDate": "10/01/2025",
    "resolvedDate": "",
    "assignedDepartment": "Public Works Department",
    "contactNumber": "+91 9876543210",
    "estimatedCompletion": "5-7 working days",
    "location": {
      "address": "Main Road, Near Bus Stop, Ranchi, Jharkhand 834001",
      "latitude": 23.3441,
      "longitude": 85.3096,
    },
    "images": [
      "https://images.pexels.com/photos/1108572/pexels-photo-1108572.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "https://images.pexels.com/photos/2219024/pexels-photo-2219024.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "https://images.pexels.com/photos/1108117/pexels-photo-1108117.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    ],
    "audioPath": "/path/to/voice/recording.m4a",
    "responses": [
      {
        "date": "10/01/2025",
        "department": "Public Works Department",
        "message":
            "We have received your complaint and assigned a team to inspect the damaged street light. Our technical team will visit the location within 2 working days to assess the issue and provide a repair timeline.",
        "officerName": "Rajesh Kumar, Assistant Engineer"
      }
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero Image Gallery
                    ImageGalleryWidget(
                      images: (reportData['images'] as List<dynamic>)
                          .cast<String>(),
                      initialIndex: 0,
                    ),

                    // Report Details Content
                    Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title and Category
                          _buildTitleSection(),
                          SizedBox(height: 3.h),

                          // Status Timeline
                          StatusTimelineWidget(reportData: reportData),
                          SizedBox(height: 3.h),

                          // Description
                          _buildDescriptionSection(),
                          SizedBox(height: 3.h),

                          // Voice Recording (if available)
                          VoicePlayerWidget(audioPath: reportData['audioPath']),
                          SizedBox(height: 3.h),

                          // Location
                          LocationMapWidget(
                            latitude: reportData['location']['latitude'],
                            longitude: reportData['location']['longitude'],
                            address: reportData['location']['address'],
                          ),
                          SizedBox(height: 3.h),

                          // Government Response
                          GovernmentResponseWidget(reportData: reportData),
                          SizedBox(height: 10.h), // Space for floating buttons
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildActionButtons(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: CustomIconWidget(
                iconName: 'arrow_back',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Report Details',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'ID: ${reportData['id']}',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _shareReport(),
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          reportData['title'],
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                reportData['category'],
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: _getPriorityColor(reportData['priority'])
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: _getPriorityIcon(reportData['priority']),
                    color: _getPriorityColor(reportData['priority']),
                    size: 12,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    '${reportData['priority']} Priority',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: _getPriorityColor(reportData['priority']),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'description',
              color: AppTheme.lightTheme.primaryColor,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              'Description',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Text(
          reportData['description'],
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    final String status = reportData['status'];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _shareReport(),
              icon: CustomIconWidget(
                iconName: 'share',
                color: Colors.white,
                size: 18,
              ),
              label: Text('Share Report'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          if (status != 'Resolved') ...[
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _reportIssue(),
                icon: CustomIconWidget(
                  iconName: 'report_problem',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 18,
                ),
                label: Text('Report Issue'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
              ),
            ),
          ] else ...[
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _rateService(),
                icon: CustomIconWidget(
                  iconName: 'star',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 18,
                ),
                label: Text('Rate Service'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppTheme.lightTheme.colorScheme.error;
      case 'medium':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'low':
        return AppTheme.lightTheme.colorScheme.secondary;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _getPriorityIcon(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return 'priority_high';
      case 'medium':
        return 'remove';
      case 'low':
        return 'keyboard_arrow_down';
      default:
        return 'help_outline';
    }
  }

  void _shareReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Report shared successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _reportIssue() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Report an Issue'),
          content: Text(
              'Do you want to report a problem with this complaint resolution?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Issue reported to authorities'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Text('Report'),
            ),
          ],
        );
      },
    );
  }

  void _rateService() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rate Service'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('How satisfied are you with the resolution of this issue?'),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Thank you for your feedback!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1.w),
                      child: CustomIconWidget(
                        iconName: 'star',
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                        size: 32,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
