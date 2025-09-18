import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WelcomeHeader extends StatelessWidget {
  final String username;

  const WelcomeHeader({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, $username',
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        'Welcome to Jharkhand Civic Reporter',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 4.w),
                Container(
                  width: 16.w,
                  height: 16.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'account_balance',
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'info_outline',
                    color: Colors.white,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Report civic issues and track their resolution status',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
