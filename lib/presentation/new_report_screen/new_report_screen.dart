import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/category_selector_widget.dart';
import './widgets/location_selector_widget.dart';
import './widgets/photo_capture_widget.dart';
import './widgets/priority_selector_widget.dart';
import './widgets/voice_recording_widget.dart';

class NewReportScreen extends StatefulWidget {
  const NewReportScreen({Key? key}) : super(key: key);

  @override
  State<NewReportScreen> createState() => _NewReportScreenState();
}

class _NewReportScreenState extends State<NewReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  // Form data
  String _selectedCategory = '';
  String _selectedPriority = 'Normal';
  List<XFile> _capturedImages = [];
  String? _recordingPath;
  LatLng? _selectedLocation;
  String _locationDetails = '';
  bool _isSubmitting = false;

  // Mock data for demonstration
  final List<Map<String, dynamic>> mockReports = [
    {
      "id": "RPT001",
      "category": "Roads",
      "priority": "Urgent",
      "description":
          "Large pothole causing traffic issues on Main Street near the government office.",
      "status": "Submitted",
      "submittedAt": "2025-01-11 15:30:00",
      "estimatedResponse": "2-3 business days",
    }
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    if (_selectedCategory.isEmpty) {
      _showErrorMessage('Please select an issue category');
      return false;
    }

    if (_descriptionController.text.trim().isEmpty) {
      _showErrorMessage('Please provide a description of the issue');
      return false;
    }

    if (_selectedLocation == null) {
      _showErrorMessage('Please set the issue location');
      return false;
    }

    return true;
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
      ),
    );
  }

  void _showSuccessDialog(String reportId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.getSuccessColor(true),
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text('Report Submitted'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your civic issue report has been successfully submitted.',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Report ID: $reportId',
                      style: AppTheme.getDataTextStyle(
                        isLight: true,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Estimated Response Time: 2-3 business days',
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'You will receive push notifications about the status updates of your report.',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Return to dashboard
              },
              child: Text('View Dashboard'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/report-details-screen');
              },
              child: Text('View Report'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitReport() async {
    if (!_validateForm()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      // Generate mock report ID
      final reportId =
          'RPT${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';

      // Show success dialog
      _showSuccessDialog(reportId);
    } catch (e) {
      _showErrorMessage('Failed to submit report. Please try again.');
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('New Report'),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: CustomIconWidget(
            iconName: 'close',
            color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
            size: 24,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isSubmitting ? null : _submitReport,
            child: _isSubmitting
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.lightTheme.appBarTheme.foregroundColor,
                    ),
                  )
                : Text(
                    'Submit',
                    style: TextStyle(
                      color: AppTheme.lightTheme.appBarTheme.foregroundColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'report_problem',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 24,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Report Civic Issue',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.lightTheme.primaryColor,
                              ),
                            ),
                            Text(
                              'Help improve your community by reporting issues',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 3.h),

                // Category Selection
                Text(
                  'Issue Category *',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                CategorySelectorWidget(
                  selectedCategory: _selectedCategory,
                  onCategoryChanged: (category) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                ),

                SizedBox(height: 3.h),

                // Priority Selection
                Text(
                  'Priority Level',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                PrioritySelectorWidget(
                  selectedPriority: _selectedPriority,
                  onPriorityChanged: (priority) {
                    setState(() {
                      _selectedPriority = priority;
                    });
                  },
                ),

                SizedBox(height: 3.h),

                // Photo Capture
                PhotoCaptureWidget(
                  capturedImages: _capturedImages,
                  onImagesChanged: (images) {
                    setState(() {
                      _capturedImages = images;
                    });
                  },
                ),

                SizedBox(height: 3.h),

                // Voice Recording
                VoiceRecordingWidget(
                  recordingPath: _recordingPath,
                  onRecordingChanged: (path) {
                    setState(() {
                      _recordingPath = path;
                    });
                  },
                ),

                SizedBox(height: 3.h),

                // Description
                Text(
                  'Issue Description *',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Describe the issue in detail...',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'description',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                    counterText: '${_descriptionController.text.length}/500',
                  ),
                  maxLines: 4,
                  maxLength: 500,
                  onChanged: (value) {
                    setState(() {}); // Trigger rebuild for counter
                  },
                ),

                SizedBox(height: 3.h),

                // Location Selection
                LocationSelectorWidget(
                  selectedLocation: _selectedLocation,
                  locationDetails: _locationDetails,
                  onLocationChanged: (location) {
                    setState(() {
                      _selectedLocation = location;
                    });
                  },
                  onLocationDetailsChanged: (details) {
                    setState(() {
                      _locationDetails = details;
                    });
                  },
                ),

                SizedBox(height: 4.h),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitReport,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isSubmitting
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Text('Submitting Report...'),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'send',
                                color:
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                size: 20,
                              ),
                              SizedBox(width: 2.w),
                              Text('Submit Report'),
                            ],
                          ),
                  ),
                ),

                SizedBox(height: 2.h),

                // Help Text
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomIconWidget(
                        iconName: 'info',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          'Your report will be reviewed by the relevant government department. You will receive updates via push notifications.',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
