import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _loadingAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _loadingOpacityAnimation;

  bool _isInitializing = true;
  String _statusMessage = "Initializing...";

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startInitialization();
  }

  void _initializeAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Loading animation controller
    _loadingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    // Logo opacity animation
    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    // Loading opacity animation
    _loadingOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingAnimationController,
      curve: Curves.easeIn,
    ));

    // Start logo animation
    _logoAnimationController.forward();
  }

  Future<void> _startInitialization() async {
    try {
      // Start loading animation after logo appears
      await Future.delayed(const Duration(milliseconds: 800));
      _loadingAnimationController.forward();

      // Simulate initialization tasks
      await _performInitializationTasks();

      // Navigate based on authentication status
      await _navigateToNextScreen();
    } catch (e) {
      _handleInitializationError(e);
    }
  }

  Future<void> _performInitializationTasks() async {
    // Task 1: Check JWT token validity
    setState(() => _statusMessage = "Checking authentication...");
    await Future.delayed(const Duration(milliseconds: 600));

    // Task 2: Load user preferences
    setState(() => _statusMessage = "Loading preferences...");
    await Future.delayed(const Duration(milliseconds: 500));

    // Task 3: Initialize secure storage
    setState(() => _statusMessage = "Initializing secure storage...");
    await Future.delayed(const Duration(milliseconds: 400));

    // Task 4: Prepare cached report data
    setState(() => _statusMessage = "Preparing data...");
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() => _statusMessage = "Ready!");
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> _navigateToNextScreen() async {
    // Simulate authentication check
    final bool isAuthenticated = await _checkAuthenticationStatus();
    final bool isFirstTime = await _checkFirstTimeUser();

    // Smooth fade transition
    await Future.delayed(const Duration(milliseconds: 200));

    if (!mounted) return;

    if (isAuthenticated) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else if (isFirstTime) {
      Navigator.pushReplacementNamed(context, '/registration-screen');
    } else {
      Navigator.pushReplacementNamed(context, '/login-screen');
    }
  }

  Future<bool> _checkAuthenticationStatus() async {
    // Simulate JWT token validation
    await Future.delayed(const Duration(milliseconds: 200));
    // For demo purposes, return false to show login flow
    return false;
  }

  Future<bool> _checkFirstTimeUser() async {
    // Simulate checking if user has registered before
    await Future.delayed(const Duration(milliseconds: 100));
    // For demo purposes, return false to show login screen
    return false;
  }

  void _handleInitializationError(dynamic error) {
    setState(() {
      _statusMessage = "Connection timeout";
      _isInitializing = false;
    });

    // Show retry option after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        _showRetryDialog();
      }
    });
  }

  void _showRetryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: Text(
            'Connection Error',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          content: Text(
            'Unable to connect to government servers. Please check your internet connection and try again.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _isInitializing = true;
                  _statusMessage = "Retrying...";
                });
                _startInitialization();
              },
              child: Text(
                'Retry',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _loadingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.lightTheme.colorScheme.surface,
                AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.95),
                Colors.grey[50]!,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Spacer to push content to center
              const Spacer(flex: 2),

              // Government Logo Section
              AnimatedBuilder(
                animation: _logoAnimationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _logoOpacityAnimation.value,
                    child: Transform.scale(
                      scale: _logoScaleAnimation.value,
                      child: _buildGovernmentLogo(),
                    ),
                  );
                },
              ),

              SizedBox(height: 4.h),

              // App Title
              AnimatedBuilder(
                animation: _logoAnimationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _logoOpacityAnimation.value,
                    child: Column(
                      children: [
                        Text(
                          'Jharkhand Civic Reporter',
                          style: AppTheme.lightTheme.textTheme.headlineMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Government of Jharkhand',
                          style:
                              AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),

              const Spacer(flex: 1),

              // Loading Section
              AnimatedBuilder(
                animation: _loadingAnimationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _loadingOpacityAnimation.value,
                    child: _buildLoadingSection(),
                  );
                },
              ),

              const Spacer(flex: 2),

              // Footer
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGovernmentLogo() {
    return Container(
      width: 25.w,
      height: 25.w,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'account_balance',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 8.w,
            ),
            SizedBox(height: 0.5.h),
            Text(
              'JH',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingSection() {
    return Column(
      children: [
        // Loading Indicator
        SizedBox(
          width: 6.w,
          height: 6.w,
          child: CircularProgressIndicator(
            strokeWidth: 3.0,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.lightTheme.colorScheme.primary,
            ),
            backgroundColor:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
          ),
        ),
        SizedBox(height: 2.h),

        // Status Message
        if (_isInitializing) ...[
          Text(
            _statusMessage,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ] else ...[
          Text(
            _statusMessage,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.error,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      child: Column(
        children: [
          Text(
            'Secure • Transparent • Efficient',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.6),
              fontWeight: FontWeight.w500,
              letterSpacing: 1.0,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            'Version 1.0.0 • © 2024 Government of Jharkhand',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.5),
              fontSize: 10.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
