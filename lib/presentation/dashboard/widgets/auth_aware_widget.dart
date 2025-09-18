import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/app_export.dart';
import '../../../services/auth_service.dart';

class AuthAwareWidget extends StatefulWidget {
  final Widget child;
  final Widget? previewWidget;
  final bool requireAuth;

  const AuthAwareWidget({
    Key? key,
    required this.child,
    this.previewWidget,
    this.requireAuth = true,
  }) : super(key: key);

  @override
  State<AuthAwareWidget> createState() => _AuthAwareWidgetState();
}

class _AuthAwareWidgetState extends State<AuthAwareWidget> {
  final AuthService _authService = AuthService.instance;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = _authService.currentUser;

    // Listen to auth state changes
    _authService.authStateChanges.listen((AuthState state) {
      if (mounted) {
        setState(() {
          _currentUser = state.session?.user;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // If authentication is not required, always show the child
    if (!widget.requireAuth) {
      return widget.child;
    }

    // If user is authenticated, show the actual content
    if (_currentUser != null) {
      return widget.child;
    }

    // If user is not authenticated, show preview mode or login prompt
    return widget.previewWidget ?? _buildPreviewMode();
  }

  Widget _buildPreviewMode() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withAlpha(77),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary.withAlpha(26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'preview',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Preview Mode',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Sign in to access full functionality',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.loginScreen);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                  foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                  padding:
                      EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Sign In',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.registrationScreen);
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.primary),
                  padding:
                      EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Register',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
