import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PhotoCaptureWidget extends StatefulWidget {
  final List<XFile> capturedImages;
  final Function(List<XFile>) onImagesChanged;

  const PhotoCaptureWidget({
    Key? key,
    required this.capturedImages,
    required this.onImagesChanged,
  }) : super(key: key);

  @override
  State<PhotoCaptureWidget> createState() => _PhotoCaptureWidgetState();
}

class _PhotoCaptureWidgetState extends State<PhotoCaptureWidget> {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isInitializing = false;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    return (await Permission.camera.request()).isGranted;
  }

  Future<void> _initializeCamera() async {
    if (_isInitializing) return;

    setState(() {
      _isInitializing = true;
    });

    try {
      if (!await _requestCameraPermission()) {
        setState(() {
          _isInitializing = false;
        });
        return;
      }

      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() {
          _isInitializing = false;
        });
        return;
      }

      final camera = kIsWeb
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first)
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras.first);

      _cameraController = CameraController(
          camera, kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high);

      await _cameraController!.initialize();
      await _applySettings();

      setState(() {
        _isCameraInitialized = true;
        _isInitializing = false;
      });
    } catch (e) {
      setState(() {
        _isInitializing = false;
      });
    }
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
    } catch (e) {}

    if (!kIsWeb) {
      try {
        await _cameraController!.setFlashMode(FlashMode.auto);
      } catch (e) {}
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final XFile photo = await _cameraController!.takePicture();
      final updatedImages = List<XFile>.from(widget.capturedImages)..add(photo);
      widget.onImagesChanged(updatedImages);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to capture photo')),
        );
      }
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage();
      if (images.isNotEmpty) {
        final updatedImages = List<XFile>.from(widget.capturedImages)
          ..addAll(images);
        widget.onImagesChanged(updatedImages);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick images from gallery')),
        );
      }
    }
  }

  void _removeImage(int index) {
    final updatedImages = List<XFile>.from(widget.capturedImages)
      ..removeAt(index);
    widget.onImagesChanged(updatedImages);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Photos',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),

          // Camera Preview
          if (_isCameraInitialized && _cameraController != null)
            Container(
              width: double.infinity,
              height: 25.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CameraPreview(_cameraController!),
              ),
            )
          else if (_isInitializing)
            Container(
              width: double.infinity,
              height: 25.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
              ),
              child: Center(
                child: CircularProgressIndicator(
                  color: AppTheme.lightTheme.primaryColor,
                ),
              ),
            )
          else
            Container(
              width: double.infinity,
              height: 25.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'camera_alt',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 48,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Camera not available',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          SizedBox(height: 2.h),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isCameraInitialized ? _capturePhoto : null,
                  icon: CustomIconWidget(
                    iconName: 'camera_alt',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 20,
                  ),
                  label: Text('Take Photo'),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickFromGallery,
                  icon: CustomIconWidget(
                    iconName: 'photo_library',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 20,
                  ),
                  label: Text('Gallery'),
                ),
              ),
            ],
          ),

          // Captured Images Thumbnails
          if (widget.capturedImages.isNotEmpty) ...[
            SizedBox(height: 2.h),
            Text(
              'Captured Photos (${widget.capturedImages.length})',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            SizedBox(
              height: 12.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.capturedImages.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(right: 2.w),
                    child: Stack(
                      children: [
                        Container(
                          width: 20.w,
                          height: 12.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.outline,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: kIsWeb
                                ? Image.network(
                                    widget.capturedImages[index].path,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    File(widget.capturedImages[index].path),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        Positioned(
                          top: 0.5.h,
                          right: 1.w,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                              padding: EdgeInsets.all(0.5.w),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.error,
                                shape: BoxShape.circle,
                              ),
                              child: CustomIconWidget(
                                iconName: 'close',
                                color: AppTheme.lightTheme.colorScheme.onError,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
