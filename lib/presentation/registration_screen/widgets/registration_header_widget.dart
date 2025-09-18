import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RegistrationHeaderWidget extends StatelessWidget {
  const RegistrationHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.lightTheme.colorScheme.primary,
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Government Logo
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'account_balance',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 10.w,
                ),
              ),
            ),
            SizedBox(height: 2.h),

            // Government of Jharkhand Text
            Text(
              'Government of Jharkhand',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 0.5.h),

            // App Title
            Text(
              'Jharkhand Civic Reporter',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),

            // Create Account Title
            Text(
              'Create Account',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 0.5.h),

            // Subtitle
            Text(
              'Join thousands of citizens making Jharkhand better',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimary
                    .withValues(alpha: 0.9),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
