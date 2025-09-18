import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconName;
  final Color? iconColor;
  final VoidCallback? onTap;

  const FeatureCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.iconName,
    this.iconColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.all(4.w),
          child: Row(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: (iconColor ?? AppTheme.lightTheme.primaryColor)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: iconName,
                    color: iconColor ?? AppTheme.lightTheme.primaryColor,
                    size: 24,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      subtitle,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              CustomIconWidget(
                iconName: 'chevron_right',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
