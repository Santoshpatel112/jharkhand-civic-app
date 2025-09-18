import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BiometricAuthWidget extends StatefulWidget {
  final VoidCallback onBiometricSuccess;
  final bool isVisible;

  const BiometricAuthWidget({
    Key? key,
    required this.onBiometricSuccess,
    required this.isVisible,
  }) : super(key: key);

  @override
  State<BiometricAuthWidget> createState() => _BiometricAuthWidgetState();
}

class _BiometricAuthWidgetState extends State<BiometricAuthWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    if (widget.isVisible) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(BiometricAuthWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _animationController.forward();
    } else if (!widget.isVisible && oldWidget.isVisible) {
      _animationController.reverse();
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    if (_isAuthenticating) return;

    setState(() {
      _isAuthenticating = true;
    });

    try {
      // Simulate biometric authentication
      await Future.delayed(const Duration(milliseconds: 1500));

      // Provide haptic feedback for success
      HapticFeedback.lightImpact();

      widget.onBiometricSuccess();
    } catch (e) {
      // Handle biometric authentication failure
      HapticFeedback.heavyImpact();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Biometric authentication failed. Please try again.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onError,
              ),
            ),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 2.h),
            child: Column(
              children: [
                // Divider with "OR" text
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: AppTheme.lightTheme.colorScheme.outline,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Text(
                        'OR',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: AppTheme.lightTheme.colorScheme.outline,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 3.h),

                // Biometric Authentication Button
                GestureDetector(
                  onTap: _isAuthenticating ? null : _authenticateWithBiometrics,
                  child: Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.lightTheme.colorScheme.surface,
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: _isAuthenticating
                        ? Center(
                            child: SizedBox(
                              width: 8.w,
                              height: 8.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.lightTheme.colorScheme.primary,
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: CustomIconWidget(
                              iconName: 'fingerprint',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 10.w,
                            ),
                          ),
                  ),
                ),

                SizedBox(height: 2.h),

                // Biometric Authentication Text
                Text(
                  _isAuthenticating
                      ? 'Authenticating...'
                      : 'Use Biometric Authentication',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 1.h),

                Text(
                  'Touch the fingerprint sensor or use Face ID',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
