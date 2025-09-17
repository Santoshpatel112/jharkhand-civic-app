import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/app_export.dart';
import './widgets/registration_form_widget.dart';
import './widgets/registration_header_widget.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isTermsAccepted = false;
  bool _isPrivacyAccepted = false;
  bool _isLoading = false;

  // Mock user data for demonstration
  final List<Map<String, dynamic>> _existingUsers = [
    {
      "email": "john.doe@example.com",
      "phone": "9876543210",
    },
    {
      "email": "admin@jharkhand.gov.in",
      "phone": "9123456789",
    },
  ];

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showTermsOfService() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildWebViewBottomSheet(
        title: 'Terms of Service',
        url: 'https://jharkhand.gov.in/terms-of-service',
        content: '''
        <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <style>
            body { font-family: Arial, sans-serif; padding: 20px; line-height: 1.6; }
            h1 { color: #1565C0; }
            h2 { color: #333; margin-top: 20px; }
            p { margin-bottom: 15px; }
          </style>
        </head>
        <body>
          <h1>Terms of Service</h1>
          <h2>1. Acceptance of Terms</h2>
          <p>By using the Jharkhand Civic Reporter application, you agree to be bound by these Terms of Service and all applicable laws and regulations.</p>
          
          <h2>2. Use of Service</h2>
          <p>This service is provided by the Government of Jharkhand for citizens to report civic issues. You agree to use this service responsibly and only for legitimate civic reporting purposes.</p>
          
          <h2>3. User Responsibilities</h2>
          <p>Users must provide accurate information when reporting issues and must not submit false, misleading, or malicious reports.</p>
          
          <h2>4. Privacy and Data Protection</h2>
          <p>Your personal information will be handled in accordance with our Privacy Policy and applicable data protection laws.</p>
          
          <h2>5. Government Authority</h2>
          <p>The Government of Jharkhand reserves the right to investigate and take appropriate action on all reports submitted through this platform.</p>
          
          <h2>6. Limitation of Liability</h2>
          <p>The Government of Jharkhand shall not be liable for any indirect, incidental, or consequential damages arising from the use of this service.</p>
          
          <h2>7. Changes to Terms</h2>
          <p>These terms may be updated from time to time. Continued use of the service constitutes acceptance of any changes.</p>
          
          <p><strong>Last updated:</strong> September 11, 2025</p>
        </body>
        </html>
        ''',
      ),
    );
  }

  void _showPrivacyPolicy() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildWebViewBottomSheet(
        title: 'Privacy Policy',
        url: 'https://jharkhand.gov.in/privacy-policy',
        content: '''
        <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <style>
            body { font-family: Arial, sans-serif; padding: 20px; line-height: 1.6; }
            h1 { color: #1565C0; }
            h2 { color: #333; margin-top: 20px; }
            p { margin-bottom: 15px; }
            ul { margin-bottom: 15px; }
            li { margin-bottom: 5px; }
          </style>
        </head>
        <body>
          <h1>Privacy Policy</h1>
          <h2>1. Information We Collect</h2>
          <p>We collect the following information when you use our service:</p>
          <ul>
            <li>Personal information (name, email, phone number)</li>
            <li>Location data for issue reporting</li>
            <li>Photos and audio recordings of civic issues</li>
            <li>Device information for technical support</li>
          </ul>
          
          <h2>2. How We Use Your Information</h2>
          <p>Your information is used to:</p>
          <ul>
            <li>Process and track your civic issue reports</li>
            <li>Communicate updates about your reports</li>
            <li>Improve our services</li>
            <li>Ensure compliance with government regulations</li>
          </ul>
          
          <h2>3. Data Security</h2>
          <p>We implement appropriate security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.</p>
          
          <h2>4. Data Sharing</h2>
          <p>Your information may be shared with relevant government departments and agencies for the purpose of addressing civic issues. We do not sell or rent your personal information to third parties.</p>
          
          <h2>5. Your Rights</h2>
          <p>You have the right to access, update, or delete your personal information. Contact us through the app for any privacy-related requests.</p>
          
          <h2>6. Contact Information</h2>
          <p>For privacy concerns, contact us at privacy@jharkhand.gov.in</p>
          
          <p><strong>Last updated:</strong> September 11, 2025</p>
        </body>
        </html>
        ''',
      ),
    );
  }

  Widget _buildWebViewBottomSheet({
    required String title,
    required String url,
    required String content,
  }) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5.w),
          topRight: Radius.circular(5.w),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 1.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              borderRadius: BorderRadius.circular(2.w),
            ),
          ),

          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 6.w,
                  ),
                ),
              ],
            ),
          ),

          // WebView Content
          Expanded(
            child: WebViewWidget(
              controller: WebViewController()
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..loadHtmlString(content),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRegistration() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_isTermsAccepted || !_isPrivacyAccepted) {
      _showErrorDialog(
          'Please accept both Terms of Service and Privacy Policy to continue.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Check for duplicate email
      bool emailExists = _existingUsers.any(
        (user) =>
            (user["email"] as String).toLowerCase() ==
            _emailController.text.trim().toLowerCase(),
      );

      if (emailExists) {
        _showErrorDialog(
            'An account with this email address already exists. Please use a different email or try logging in.');
        return;
      }

      // Check for duplicate phone
      String cleanPhone =
          _phoneController.text.replaceAll(RegExp(r'[^\d]'), '');
      bool phoneExists = _existingUsers.any(
        (user) => user["phone"] == cleanPhone,
      );

      if (phoneExists) {
        _showErrorDialog(
            'An account with this phone number already exists. Please use a different phone number or try logging in.');
        return;
      }

      // Simulate successful registration
      _showSuccessDialog();
    } catch (e) {
      _showErrorDialog(
          'Registration failed. Please check your internet connection and try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.w),
        ),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'error_outline',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 6.w,
            ),
            SizedBox(width: 3.w),
            Text(
              'Registration Error',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.w),
        ),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle_outline',
              color: AppTheme.lightTheme.colorScheme.secondary,
              size: 6.w,
            ),
            SizedBox(width: 3.w),
            Text(
              'Welcome!',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.secondary,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your account has been created successfully!',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Text(
              'Welcome to Jharkhand Civic Reporter, ${_fullNameController.text.trim()}. You can now start reporting civic issues and help make Jharkhand better.',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/dashboard');
            },
            child: Text(
              'Get Started',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Header Section
          const RegistrationHeaderWidget(),

          // Form Section
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
              child: Column(
                children: [
                  // Back to Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacementNamed(
                            context, '/login-screen'),
                        child: Text(
                          'Sign In',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),

                  // Registration Form
                  RegistrationFormWidget(
                    formKey: _formKey,
                    fullNameController: _fullNameController,
                    emailController: _emailController,
                    phoneController: _phoneController,
                    passwordController: _passwordController,
                    confirmPasswordController: _confirmPasswordController,
                    isTermsAccepted: _isTermsAccepted,
                    isPrivacyAccepted: _isPrivacyAccepted,
                    onTermsChanged: (value) {
                      if (value && !_isTermsAccepted) {
                        _showTermsOfService();
                      }
                      setState(() {
                        _isTermsAccepted = value;
                      });
                    },
                    onPrivacyChanged: (value) {
                      if (value && !_isPrivacyAccepted) {
                        _showPrivacyPolicy();
                      }
                      setState(() {
                        _isPrivacyAccepted = value;
                      });
                    },
                    onRegister: _handleRegistration,
                    isLoading: _isLoading,
                  ),

                  SizedBox(height: 4.h),

                  // Government Disclaimer
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(3.w),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomIconWidget(
                          iconName: 'info_outline',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 5.w,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Government Service',
                                style: AppTheme.lightTheme.textTheme.titleSmall
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                'This is an official Government of Jharkhand service. Your information is secure and will only be used for civic issue reporting and resolution.',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
