import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LocationSelectorWidget extends StatefulWidget {
  final LatLng? selectedLocation;
  final String locationDetails;
  final Function(LatLng?) onLocationChanged;
  final Function(String) onLocationDetailsChanged;

  const LocationSelectorWidget({
    Key? key,
    required this.selectedLocation,
    required this.locationDetails,
    required this.onLocationChanged,
    required this.onLocationDetailsChanged,
  }) : super(key: key);

  @override
  State<LocationSelectorWidget> createState() => _LocationSelectorWidgetState();
}

class _LocationSelectorWidgetState extends State<LocationSelectorWidget> {
  GoogleMapController? _mapController;
  bool _isLoadingLocation = false;
  final TextEditingController _locationDetailsController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _locationDetailsController.text = widget.locationDetails;
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _locationDetailsController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Location services are disabled')),
          );
        }
        setState(() {
          _isLoadingLocation = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Location permissions are denied')),
            );
          }
          setState(() {
            _isLoadingLocation = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Location permissions are permanently denied')),
          );
        }
        setState(() {
          _isLoadingLocation = false;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final location = LatLng(position.latitude, position.longitude);
      widget.onLocationChanged(location);

      if (_mapController != null) {
        await _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(location, 16.0),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to get current location')),
        );
      }
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  void _onMapTap(LatLng location) {
    widget.onLocationChanged(location);
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Issue Location',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton.icon(
                onPressed: _isLoadingLocation ? null : _getCurrentLocation,
                icon: _isLoadingLocation
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppTheme.lightTheme.primaryColor,
                        ),
                      )
                    : CustomIconWidget(
                        iconName: 'my_location',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 16,
                      ),
                label: Text('Current Location'),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Map Preview
          Container(
            width: double.infinity,
            height: 25.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: widget.selectedLocation != null
                  ? GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: widget.selectedLocation!,
                        zoom: 16.0,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _mapController = controller;
                      },
                      onTap: _onMapTap,
                      markers: {
                        Marker(
                          markerId: MarkerId('selected_location'),
                          position: widget.selectedLocation!,
                          draggable: true,
                          onDragEnd: (LatLng newPosition) {
                            widget.onLocationChanged(newPosition);
                          },
                          infoWindow: InfoWindow(
                            title: 'Issue Location',
                            snippet: 'Drag to adjust position',
                          ),
                        ),
                      },
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      mapToolbarEnabled: false,
                    )
                  : Container(
                      color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'location_on',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 48,
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Tap "Current Location" to set location',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),

          SizedBox(height: 2.h),

          // Location Details Input
          TextField(
            controller: _locationDetailsController,
            decoration: InputDecoration(
              labelText: 'Add Location Details (Optional)',
              hintText: 'e.g., Near City Mall, Opposite Bank',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'place',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
            maxLines: 2,
            onChanged: widget.onLocationDetailsChanged,
          ),

          // Location Coordinates Display
          if (widget.selectedLocation != null) ...[
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
                    'GPS Coordinates:',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'Lat: ${widget.selectedLocation!.latitude.toStringAsFixed(6)}',
                    style: AppTheme.getDataTextStyle(
                      isLight: true,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'Lng: ${widget.selectedLocation!.longitude.toStringAsFixed(6)}',
                    style: AppTheme.getDataTextStyle(
                      isLight: true,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
