import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickStatsCard extends StatelessWidget {
  final int totalReports;
  final int submittedCount;
  final int inProgressCount;
  final int resolvedCount;

  const QuickStatsCard({
    Key? key,
    required this.totalReports,
    required this.submittedCount,
    required this.inProgressCount,
    required this.resolvedCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'assessment',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Text(
                  'My Reports Overview',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    totalReports.toString(),
                    style:
                        AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Total Reports',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: _buildStatusItem(
                    'Submitted',
                    submittedCount,
                    AppTheme.lightTheme.colorScheme.tertiary,
                    context,
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: _buildStatusItem(
                    'In Progress',
                    inProgressCount,
                    Colors.orange,
                    context,
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: _buildStatusItem(
                    'Resolved',
                    resolvedCount,
                    AppTheme.lightTheme.colorScheme.secondary,
                    context,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(
      String label, int count, Color color, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
