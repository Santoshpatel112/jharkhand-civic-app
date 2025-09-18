import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/auth_service.dart';
import './widgets/biometric_auth_widget.dart';
import './widgets/demo_credentials_widget.dart';
import './widgets/government_logo_widget.dart';
import './widgets/login_form_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _isLoading = false;
  bool _showBiometricAuth = false;

  final AuthService _authService = AuthService.instance;

  @override
  void initState() {
    super.initState();
    // Check if user is already logged in
    _checkAuthState();
  }

  void _checkAuthState() {
    final user = _authService.currentUser;
    if (user != null) {
      // User is already logged in, navigate to dashboard
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
      });
    }
  }

  void _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showToast('Please enter email and password');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _authService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (response.user != null) {
        _showToast('Login successful!');
        Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
      } else {
        _showToast('Login failed. Please try again.');
      }
    } catch (error) {
      String errorMessage = 'Login failed. Please check your credentials.';
      if (error.toString().contains('Invalid login credentials')) {
        errorMessage = 'Invalid email or password. Please try again.';
      } else if (error.toString().contains('Email not confirmed')) {
        errorMessage = 'Please confirm your email address.';
      }
      _showToast(errorMessage);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _forgotPassword() {
    if (_emailController.text.isEmpty) {
      _showToast('Please enter your email address first');
      return;
    }

    _authService.resetPassword(_emailController.text.trim()).then((_) {
      _showToast('Password reset email sent. Please check your inbox.');
    }).catchError((error) {
      _showToast('Failed to send reset email. Please try again.');
    });
  }

  void _register() {
    Navigator.pushNamed(context, AppRoutes.registration);
  }

  void _onCredentialSelected(String email, String password) {
    setState(() {
      _emailController.text = email;
      _passwordController.text = password;
    });
    _showToast('Credentials filled. Click Login to continue.');
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      textColor: AppTheme.lightTheme.colorScheme.onSurface,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 8.h),

              // Government Logo
              const GovernmentLogoWidget(),

              SizedBox(height: 6.h),

              // Title
              Text(
                'Welcome Back',
                style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 1.h),

              // Subtitle
              Text(
                'Sign in to report civic issues',
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 4.h),

              // Login Form
              LoginFormWidget(
                emailController: _emailController,
                passwordController: _passwordController,
                isLoading: _isLoading,
                onLogin: _login,
                onForgotPassword: _forgotPassword,
                onRegister: _register,
              ),

              // Demo Credentials Section
              DemoCredentialsWidget(
                onCredentialSelected: _onCredentialSelected,
              ),

              SizedBox(height: 4.h),

              // Biometric Authentication (if available)
              BiometricAuthWidget(
                onBiometricSuccess: () {
                  _showToast('Biometric authentication feature coming soon!');
                },
                isVisible: true,
              ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
}