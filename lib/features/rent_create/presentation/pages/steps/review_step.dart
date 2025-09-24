import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../theming/colors.dart';
import '../../../../../theming/text_styles.dart';
import '../../bloc/rent_create_bloc.dart';
import '../../bloc/rent_create_state.dart';

class ReviewStep extends StatelessWidget {
  const ReviewStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RentCreateBloc, RentCreateState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 24.h),
              _buildPropertyPreview(state),
              SizedBox(height: 24.h),
              _buildMainDetails(state),
              SizedBox(height: 16.h),
              _buildPropertyFeatures(state),
              SizedBox(height: 16.h),
              _buildLocationInfo(state),
              SizedBox(height: 16.h),
              _buildHouseRules(state),
              SizedBox(height: 16.h),
              _buildCancellationPolicy(),
              SizedBox(height: 16.h),
              _buildImportantInfo(state),
              SizedBox(height: 100.h), // Space for bottom navigation
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Text(
      'Review',
      style: AppTextStyles.h3.copyWith(
        color: AppColors.primary,
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildPropertyPreview(RentCreateState state) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          children: [
            // Main Image
            Container(
              height: 200.h,
              width: double.infinity,
              color: Colors.grey[200],
              child: state.formData.selectedImages.isNotEmpty
                  ? Image.file(
                      state.formData.selectedImages[0],
                      fit: BoxFit.cover,
                    )
                  : Icon(
                      Icons.image,
                      size: 60.sp,
                      color: Colors.grey[400],
                    ),
            ),
            // Property Info
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.formData.propertyTitle ?? 'Property Title',
                    style: AppTextStyles.h4.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  _buildQuickInfo(state),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickInfo(RentCreateState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Price',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              '\$${state.formData.pricePerNight?.toString() ?? '0'} - Night',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          'Property Type: ${state.formData.propertyTypeName ?? 'Not selected'}',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Maximum Guests: ${state.formData.maximumNumberOfGuests} Guests',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildMainDetails(RentCreateState state) {
    return _buildSection(
      title: 'Main Details',
      child: Column(
        children: [
          _buildDetailRow('Bedrooms', '${state.formData.bedrooms} Bedrooms'),
          _buildDetailRow('Bathrooms', '${state.formData.bathrooms} Bathrooms'),
          _buildDetailRow('Number Of Beds', '${state.formData.numberOfBeds} Beds'),
          _buildDetailRow('Floor', '${state.formData.floor}${_getFloorSuffix(state.formData.floor)} Floor'),
          _buildDetailRow('Living Rooms', '${state.formData.livingRooms} Rooms'),
        ],
      ),
    );
  }

  Widget _buildPropertyFeatures(RentCreateState state) {
    return _buildSection(
      title: 'Property Features',
      child: state.formData.selectedFeatures.isEmpty
          ? Text(
              'No features selected',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontSize: 14.sp,
              ),
            )
          : Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: state.formData.selectedFeatures.map((feature) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getFeatureIcon(feature),
                        color: Colors.white,
                        size: 16.sp,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        feature,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget _buildLocationInfo(RentCreateState state) {
    return _buildSection(
      title: 'Property Location',
      child: Column(
        children: [
          Container(
            height: 120.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Center(
              child: Text(
                'Show Map',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.grey[600],
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            state.formData.address ?? 'No address provided',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHouseRules(RentCreateState state) {
    return _buildSection(
      title: 'House Rules',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Check In After 3:00 PM',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Check Out Before 12:00 AM',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Minimum Age To Rent : 18',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'No Pets Allowed',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Smoking Is Not Permitted',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancellationPolicy() {
    return _buildSection(
      title: 'Cancellation Policy',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No Refund',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'A Policy Of No Refund And Cancel Your Booking You Will Not Get A Refund Or Credit For Future Stay.',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportantInfo(RentCreateState state) {
    return _buildSection(
      title: 'Important To Read',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You Need To Know',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            state.formData.importantInformation ?? 
            'If You Damage Or Correct Your Booking You Will Not Get A Refund Or Credit For Future Stay. We Offer A Premium Service Where We Offer This Area And As Luxury.',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontSize: 14.sp,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getFloorSuffix(int floor) {
    if (floor == 1) return 'st';
    if (floor == 2) return 'nd';
    if (floor == 3) return 'rd';
    return 'th';
  }

  IconData _getFeatureIcon(String feature) {
    switch (feature.toLowerCase()) {
      case 'wifi':
        return Icons.wifi;
      case 'parking':
        return Icons.local_parking;
      case 'kitchen':
        return Icons.kitchen;
      case 'gym':
        return Icons.fitness_center;
      case 'pool':
        return Icons.pool;
      case 'garden':
        return Icons.local_florist;
      case 'balcony':
        return Icons.balcony;
      case 'ac':
      case 'air conditioning':
        return Icons.ac_unit;
      default:
        return Icons.check_circle;
    }
  }
}
