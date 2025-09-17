import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StatusTimelineWidget extends StatelessWidget {
  final Map<String, dynamic> reportData;

  const StatusTimelineWidget({
    Key? key,
    required this.reportData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> timelineSteps = [
      {
        'title': 'Submitted',
        'date': reportData['submittedDate'] ?? '2025-01-08',
        'department': 'Citizen Portal',
        'isCompleted': true,
        'isCurrent': false,
      },
      {
        'title': 'Under Review',
        'date': reportData['reviewDate'] ?? '2025-01-09',
        'department': 'Municipal Office',
        'isCompleted': reportData['status'] != 'Submitted',
        'isCurrent': reportData['status'] == 'Under Review',
      },
      {
        'title': 'In Progress',
        'date': reportData['progressDate'] ?? '',
        'department':
            reportData['assignedDepartment'] ?? 'Public Works Department',
        'isCompleted': reportData['status'] == 'In Progress' ||
            reportData['status'] == 'Resolved',
        'isCurrent': reportData['status'] == 'In Progress',
      },
      {
        'title': 'Resolved',
        'date': reportData['resolvedDate'] ?? '',
        'department':
            reportData['assignedDepartment'] ?? 'Public Works Department',
        'isCompleted': reportData['status'] == 'Resolved',
        'isCurrent': false,
      },
    ];

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status Timeline',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          ...timelineSteps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            final isLast = index == timelineSteps.length - 1;

            return _buildTimelineStep(
              step: step,
              isLast: isLast,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTimelineStep({
    required Map<String, dynamic> step,
    required bool isLast,
  }) {
    final bool isCompleted = step['isCompleted'] as bool;
    final bool isCurrent = step['isCurrent'] as bool;
    final String date = step['date'] as String;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 6.w,
              height: 6.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? AppTheme.lightTheme.colorScheme.secondary
                    : isCurrent
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.lightTheme.colorScheme.outline,
                border: isCurrent
                    ? Border.all(
                        color: AppTheme.lightTheme.primaryColor,
                        width: 2,
                      )
                    : null,
              ),
              child: isCompleted
                  ? Center(
                      child: CustomIconWidget(
                        iconName: 'check',
                        color: Colors.white,
                        size: 12,
                      ),
                    )
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 8.h,
                color: isCompleted
                    ? AppTheme.lightTheme.colorScheme.secondary
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
              ),
          ],
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 3.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step['title'] as String,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w500,
                    color: isCurrent
                        ? AppTheme.lightTheme.primaryColor
                        : isCompleted
                            ? AppTheme.lightTheme.colorScheme.onSurface
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (date.isNotEmpty) ...[
                  SizedBox(height: 0.5.h),
                  Text(
                    date,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                SizedBox(height: 0.5.h),
                Text(
                  step['department'] as String,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                if (isCurrent && step['title'] == 'In Progress') ...[
                  SizedBox(height: 1.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Estimated completion: 5-7 days',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
