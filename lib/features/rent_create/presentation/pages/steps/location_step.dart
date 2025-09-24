import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../theming/colors.dart';
import '../../../../../theming/text_styles.dart';
import '../../bloc/rent_create_bloc.dart';
import '../../bloc/rent_create_event.dart';
import '../../bloc/rent_create_state.dart';

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
        if (_streetController.text != (state.formData.streetAndBuildingNumber ?? '')) {
          _streetController.text = state.formData.streetAndBuildingNumber ?? '';
        }
        if (_landMarkController.text != (state.formData.landMark ?? '')) {
          _landMarkController.text = state.formData.landMark ?? '';
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 24.h),
              _buildLocationForm(context),
              SizedBox(height: 24.h),
              _buildMapPlaceholder(),
              SizedBox(height: 100.h), // Space for bottom navigation
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
        Text(
          'Location',
          style: AppTextStyles.h3.copyWith(
            color: AppColors.primary,
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Property Location',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            fontSize: 16.sp,
          ),
        ),
      ],
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

  Widget _buildMapPlaceholder() {
    return Container(
      height: 200.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.map_outlined,
            color: Colors.grey[400],
            size: 48.sp,
          ),
          SizedBox(height: 16.h),
          Text(
            'Map Integration',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.grey[600],
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Coming Soon',
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.grey[500],
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
