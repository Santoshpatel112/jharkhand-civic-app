import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LoginFormWidget extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final VoidCallback onLogin;
  final VoidCallback onForgotPassword;
  final VoidCallback onRegister;

  const LoginFormWidget({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.onLogin,
    required this.onForgotPassword,
    required this.onRegister,
  }) : super(key: key);

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  bool _isPasswordVisible = false;
  bool _isEmailValid = true;
  bool _isPasswordValid = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    widget.emailController.addListener(_validateEmail);
    widget.passwordController.addListener(_validatePassword);
  }

  void _validateEmail() {
    final email = widget.emailController.text;
    setState(() {
      _isEmailValid = email.isEmpty ||
          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
    });
  }

  void _validatePassword() {
    final password = widget.passwordController.text;
    setState(() {
      _isPasswordValid = password.isEmpty || password.length >= 6;
    });
  }

  bool get _isFormValid {
    return widget.emailController.text.isNotEmpty &&
        widget.passwordController.text.isNotEmpty &&
        _isEmailValid &&
        _isPasswordValid;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email/Username Field
          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isEmailValid
                    ? AppTheme.lightTheme.colorScheme.outline
                    : AppTheme.lightTheme.colorScheme.error,
                width: 1.5,
              ),
            ),
            child: TextFormField(
              controller: widget.emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              enabled: !widget.isLoading,
              style: AppTheme.lightTheme.textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: 'Email or Username',
                hintStyle: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'person',
                    color: _isEmailValid
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.error,
                    size: 6.w,
                  ),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 2.h,
                ),
              ),
            ),
          ),

          if (!_isEmailValid) ...[
            SizedBox(height: 1.h),
            Padding(
              padding: EdgeInsets.only(left: 4.w),
              child: Text(
                'Please enter a valid email address',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.error,
                ),
              ),
            ),
          ],

          SizedBox(height: 3.h),

          // Password Field
          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isPasswordValid
                    ? AppTheme.lightTheme.colorScheme.outline
                    : AppTheme.lightTheme.colorScheme.error,
                width: 1.5,
              ),
            ),
            child: TextFormField(
              controller: widget.passwordController,
              obscureText: !_isPasswordVisible,
              textInputAction: TextInputAction.done,
              enabled: !widget.isLoading,
              style: AppTheme.lightTheme.textTheme.bodyLarge,
              onFieldSubmitted: (_) {
                if (_isFormValid) {
                  widget.onLogin();
                }
              },
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'lock',
                    color: _isPasswordValid
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.error,
                    size: 6.w,
                  ),
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName:
                          _isPasswordVisible ? 'visibility' : 'visibility_off',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 6.w,
                    ),
                  ),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 2.h,
                ),
              ),
            ),
          ),

          if (!_isPasswordValid) ...[
            SizedBox(height: 1.h),
            Padding(
              padding: EdgeInsets.only(left: 4.w),
              child: Text(
                'Password must be at least 6 characters',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.error,
                ),
              ),
            ),
          ],

          SizedBox(height: 2.h),

          // Forgot Password Link
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: widget.isLoading ? null : widget.onForgotPassword,
              child: Text(
                'Forgot Password?',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          SizedBox(height: 4.h),

          // Login Button
          SizedBox(
            height: 7.h,
            child: ElevatedButton(
              onPressed:
                  (_isFormValid && !widget.isLoading) ? widget.onLogin : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isFormValid
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: widget.isLoading
                  ? SizedBox(
                      width: 6.w,
                      height: 6.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.lightTheme.colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Text(
                      'Login',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),

          SizedBox(height: 4.h),

          // Register Link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'New Citizen? ',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              GestureDetector(
                onTap: widget.isLoading ? null : widget.onRegister,
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

  @override
  void dispose() {
    widget.emailController.removeListener(_validateEmail);
    widget.passwordController.removeListener(_validatePassword);
    super.dispose();
  }
}
