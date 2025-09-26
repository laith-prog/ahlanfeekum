import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../theming/colors.dart';
import '../../../../../theming/text_styles.dart';
import '../../bloc/rent_create_bloc.dart';
import '../../bloc/rent_create_event.dart';
import '../../bloc/rent_create_state.dart';
import '../map_picker_page.dart';

class LocationStep extends StatefulWidget {
  const LocationStep({super.key});

  @override
  State<LocationStep> createState() => _LocationStepState();
}

class _LocationStepState extends State<LocationStep> {
  final _addressController = TextEditingController();
  final _streetController = TextEditingController();
  final _landMarkController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    _streetController.dispose();
    _landMarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RentCreateBloc, RentCreateState>(
      builder: (context, state) {
        // Update controllers when form data changes
        if (_addressController.text != (state.formData.address ?? '')) {
          _addressController.text = state.formData.address ?? '';
        }
        if (_streetController.text !=
            (state.formData.streetAndBuildingNumber ?? '')) {
          _streetController.text = state.formData.streetAndBuildingNumber ?? '';
        }
        if (_landMarkController.text != (state.formData.landMark ?? '')) {
          _landMarkController.text = state.formData.landMark ?? '';
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 20.h),
              _buildMapSection(context, state),
              SizedBox(height: 24.h),
              _buildLocationForm(context),
              SizedBox(height: 80.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.location_on, color: AppColors.primary, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              'Location',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Text(
          'Property Location',
          style: AppTextStyles.h3.copyWith(
            color: AppColors.textPrimary,
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildMapSection(BuildContext context, RentCreateState state) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.divider),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 32.w,
                    width: 32.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.2),
                      ),
                      color: AppColors.primary.withValues(alpha: 0.08),
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: AppColors.primary,
                      size: 18.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Property Location',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  context.read<RentCreateBloc>().add(
                    const ClearLocationEvent(),
                  );
                  _addressController.clear();
                  _streetController.clear();
                  _landMarkController.clear();
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.error,
                  textStyle: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const Text('Clear'),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          GestureDetector(
            onTap: () async {
              final formState = context.read<RentCreateBloc>().state;
              final initLat = formState.formData.latitude ?? 33.5138;
              final initLng = formState.formData.longitude ?? 36.2765;
              final result = await Navigator.push<Map<String, dynamic>>(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      MapPickerPage(initialLat: initLat, initialLng: initLng),
                ),
              );
              if (result != null) {
                context.read<RentCreateBloc>().add(
                  UpdateLocationEvent(result['lat']!, result['lng']!),
                );

                final address = result['address'] as String?;
                if (address != null && address.isNotEmpty) {
                  _addressController.text = address;
                  context.read<RentCreateBloc>().add(
                    UpdateAddressEvent(address),
                  );
                }

                final street = result['street'] as String?;
                if (street != null && street.isNotEmpty) {
                  _streetController.text = street;
                  context.read<RentCreateBloc>().add(UpdateStreetEvent(street));
                }

                final landMark = result['landmark'] as String?;
                if (landMark != null && landMark.isNotEmpty) {
                  _landMarkController.text = landMark;
                  context.read<RentCreateBloc>().add(
                    UpdateLandMarkEvent(landMark),
                  );
                }
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Stack(
                children: [
                  SizedBox(
                    height: 160.h,
                    width: double.infinity,
                    child: _buildMiniMapPreview(state),
                  ),
                  Positioned(
                    top: 16.h,
                    right: 16.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_location_alt,
                            color: AppColors.primary,
                            size: 16.sp,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'Edit',
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.divider.withValues(alpha: 0.4),
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          BlocBuilder<RentCreateBloc, RentCreateState>(
            builder: (context, blocState) {
              final address = blocState.formData.address;
              final street = blocState.formData.streetAndBuildingNumber;
              final landMark = blocState.formData.landMark;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (address != null && address.isNotEmpty)
                    Text(
                      address,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  SizedBox(height: 4.h),
                  Text(
                    [street, landMark]
                        .where((value) => value != null && value!.isNotEmpty)
                        .join(' • '),
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMiniMapPreview(RentCreateState state) {
    final latitude = state.formData.latitude;
    final longitude = state.formData.longitude;

    if (latitude == null || longitude == null) {
      return Image.asset('assets/images/Background1.png', fit: BoxFit.cover);
    }

    return IgnorePointer(
      child: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(latitude, longitude),
          initialZoom: 15,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.none,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.ahlanfeekum.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(latitude, longitude),
                width: 48.w,
                height: 48.h,
                child: Icon(
                  Icons.location_on,
                  size: 36.sp,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          controller: _addressController,
          label: 'Address',
          hintText: 'Damascus, Al Qusor',
          onChanged: (value) {
            context.read<RentCreateBloc>().add(UpdateAddressEvent(value));
          },
        ),
        SizedBox(height: 16.h),
        _buildTextField(
          controller: _streetController,
          label: 'Street, Building Number',
          hintText: 'Street 123',
          onChanged: (value) {
            context.read<RentCreateBloc>().add(UpdateStreetEvent(value));
          },
        ),
        SizedBox(height: 16.h),
        _buildTextField(
          controller: _landMarkController,
          label: 'Land Mark',
          hintText: 'Away From \'place\' 2 Km',
          onChanged: (value) {
            context.read<RentCreateBloc>().add(UpdateLandMarkEvent(value));
          },
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: Colors.grey[400],
              fontSize: 14.sp,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMapPicker(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final state = context.read<RentCreateBloc>().state;
        final initLat = state.formData.latitude ?? 33.5138;
        final initLng = state.formData.longitude ?? 36.2765;
        final result = await Navigator.push<Map<String, dynamic>>(
          context,
          MaterialPageRoute(
            builder: (_) =>
                MapPickerPage(initialLat: initLat, initialLng: initLng),
          ),
        );
        if (result != null) {
          // Update coordinates
          context.read<RentCreateBloc>().add(
            UpdateLocationEvent(result['lat']!, result['lng']!),
          );

          // Update address if available
          final address = result['address'] as String?;
          if (address != null && address.isNotEmpty) {
            // Only show user feedback for actual address names, not coordinates
            final isRealAddress =
                !address.startsWith('Lat:') &&
                !address.contains('Getting address');

            context.read<RentCreateBloc>().add(UpdateAddressEvent(address));

            if (isRealAddress) {
              // Show feedback to user that address was updated
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Address updated from selected location'),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          }
        }
      },
      child: Container(
        height: 200.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: BlocBuilder<RentCreateBloc, RentCreateState>(
          builder: (context, state) {
            final lat = state.formData.latitude;
            final lng = state.formData.longitude;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_on,
                    color: AppColors.primary,
                    size: 28.sp,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    (lat != null && lng != null)
                        ? 'Lat: ${lat.toStringAsFixed(5)}, Lng: ${lng.toStringAsFixed(5)}'
                        : 'Tap to pick coordinates',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
