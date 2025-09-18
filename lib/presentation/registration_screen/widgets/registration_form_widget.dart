import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RegistrationFormWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isTermsAccepted;
  final bool isPrivacyAccepted;
  final Function(bool) onTermsChanged;
  final Function(bool) onPrivacyChanged;
  final VoidCallback onRegister;
  final bool isLoading;

  const RegistrationFormWidget({
    super.key,
    required this.formKey,
    required this.fullNameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isTermsAccepted,
    required this.isPrivacyAccepted,
    required this.onTermsChanged,
    required this.onPrivacyChanged,
    required this.onRegister,
    required this.isLoading,
  });

  @override
  State<RegistrationFormWidget> createState() => _RegistrationFormWidgetState();
}

class _RegistrationFormWidgetState extends State<RegistrationFormWidget> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String _passwordStrength = '';
  Color _passwordStrengthColor = Colors.grey;

  void _checkPasswordStrength(String password) {
    if (password.isEmpty) {
      setState(() {
        _passwordStrength = '';
        _passwordStrengthColor = Colors.grey;
      });
      return;
    }

    int score = 0;
    if (password.length >= 8) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    setState(() {
      switch (score) {
        case 0:
        case 1:
          _passwordStrength = 'Weak';
          _passwordStrengthColor = AppTheme.lightTheme.colorScheme.error;
          break;
        case 2:
        case 3:
          _passwordStrength = 'Medium';
          _passwordStrengthColor = AppTheme.lightTheme.colorScheme.tertiary;
          break;
        case 4:
        case 5:
          _passwordStrength = 'Strong';
          _passwordStrengthColor = AppTheme.lightTheme.colorScheme.secondary;
          break;
      }
    });
  }

  String? _validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    if (value.trim().length < 2) {
      return 'Full name must be at least 2 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      return 'Full name can only contain letters and spaces';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required';
    }
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    String cleanPhone = value.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanPhone.length != 10) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != widget.passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Full Name Field
          TextFormField(
            controller: widget.fullNameController,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.name,
            validator: _validateFullName,
            decoration: InputDecoration(
              labelText: 'Full Name',
              hintText: 'Enter your full name',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'person',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 6.w,
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),

          // Email Field
          TextFormField(
            controller: widget.emailController,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
            decoration: InputDecoration(
              labelText: 'Email Address',
              hintText: 'Enter your email address',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'email',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 6.w,
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),

          // Phone Number Field
          TextFormField(
            controller: widget.phoneController,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.phone,
            validator: _validatePhone,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              hintText: 'Enter your phone number',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'phone',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 6.w,
                ),
              ),
              prefixText: '+91 ',
            ),
          ),
          SizedBox(height: 2.h),

          // Password Field
          TextFormField(
            controller: widget.passwordController,
            textInputAction: TextInputAction.next,
            obscureText: !_isPasswordVisible,
            validator: _validatePassword,
            onChanged: _checkPasswordStrength,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'lock',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 6.w,
                ),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
                icon: CustomIconWidget(
                  iconName:
                      _isPasswordVisible ? 'visibility_off' : 'visibility',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 6.w,
                ),
              ),
            ),
          ),

          // Password Strength Indicator
          if (_passwordStrength.isNotEmpty) ...[
            SizedBox(height: 1.h),
            Row(
              children: [
                Text(
                  'Password Strength: ',
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
                Text(
                  _passwordStrength,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: _passwordStrengthColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: 2.h),

          // Confirm Password Field
          TextFormField(
            controller: widget.confirmPasswordController,
            textInputAction: TextInputAction.done,
            obscureText: !_isConfirmPasswordVisible,
            validator: _validateConfirmPassword,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              hintText: 'Re-enter your password',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'lock_outline',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 6.w,
                ),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
                icon: CustomIconWidget(
                  iconName: _isConfirmPasswordVisible
                      ? 'visibility_off'
                      : 'visibility',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 6.w,
                ),
              ),
            ),
          ),
          SizedBox(height: 3.h),

          // Terms and Privacy Checkboxes
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: widget.isTermsAccepted,
                    onChanged: (value) => widget.onTermsChanged(value ?? false),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          widget.onTermsChanged(!widget.isTermsAccepted),
                      child: Padding(
                        padding: EdgeInsets.only(top: 3.w),
                        child: RichText(
                          text: TextSpan(
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                            children: [
                              const TextSpan(text: 'I agree to the '),
                              TextSpan(
                                text: 'Terms of Service',
                                style: TextStyle(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: widget.isPrivacyAccepted,
                    onChanged: (value) =>
                        widget.onPrivacyChanged(value ?? false),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          widget.onPrivacyChanged(!widget.isPrivacyAccepted),
                      child: Padding(
                        padding: EdgeInsets.only(top: 3.w),
                        child: RichText(
                          text: TextSpan(
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                            children: [
                              const TextSpan(text: 'I agree to the '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 4.h),

          // Register Button
          SizedBox(
            height: 7.h,
            child: ElevatedButton(
              onPressed: widget.isLoading ||
                      !widget.isTermsAccepted ||
                      !widget.isPrivacyAccepted
                  ? null
                  : widget.onRegister,
              child: widget.isLoading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 5.w,
                          height: 5.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.lightTheme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          'Creating Account...',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      'Register',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
