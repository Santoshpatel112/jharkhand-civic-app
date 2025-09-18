import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GovernmentLogoWidget extends StatelessWidget {
  const GovernmentLogoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 4.h),
      child: Column(
        children: [
          // Government Logo Container
          Container(
            width: 25.w,
            height: 25.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.lightTheme.colorScheme.primary,
                      AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.8),
                    ],
                  ),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'account_balance',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 10.w,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Government Title
          Text(
            'Government of Jharkhand',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 0.5.h),

          // Application Title
          Text(
            'Civic Reporter',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 1.h),

          // Subtitle
          Text(
            'Secure Citizen Login',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
