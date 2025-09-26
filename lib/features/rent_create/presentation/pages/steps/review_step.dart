import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../theming/colors.dart';
import '../../../../../theming/text_styles.dart';
import '../../bloc/rent_create_bloc.dart';
import '../../bloc/rent_create_state.dart';

class ReviewStep extends StatefulWidget {
  const ReviewStep({super.key});

  @override
  State<ReviewStep> createState() => _ReviewStepState();
}

class _ReviewStepState extends State<ReviewStep> {
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RentCreateBloc, RentCreateState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSlider(state),
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    _buildPropertyTitle(state),
                    SizedBox(height: 20.h),
                    _buildMainDetailsSection(state),
                    SizedBox(height: 20.h),
                    _buildRoomDetailsSection(state),
                    SizedBox(height: 20.h),
                    _buildDetailsSection(state),
                    SizedBox(height: 20.h),
                    _buildPropertyFeaturesSection(state),
                    SizedBox(height: 20.h),
                    _buildLocationSection(state),
                    SizedBox(height: 20.h),
                    _buildHouseRulesSection(state),
                    SizedBox(height: 20.h),
                    _buildCancellationPolicySection(),
                    SizedBox(height: 20.h),
                    _buildImportantToReadSection(state),
                    SizedBox(height: 120.h), // Space for floating buttons
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _buildImageSlider(RentCreateState state) {
    final images = state.formData.selectedImages;
    
    return Container(
      height: 300.h,
      width: double.infinity,
      child: Stack(
        children: [
          // Image PageView
          if (images.isNotEmpty)
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Image.file(
                  images[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                );
              },
            )
          else
            Container(
              color: Colors.grey[200],
              child: Center(
                child: Icon(
                  Icons.image,
                  size: 60.sp,
                  color: Colors.grey[400],
                ),
              ),
            ),
          
          // Dots indicator
          if (images.length > 1)
            Positioned(
              bottom: 16.h,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                  (index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 2.w),
                    width: 6.w,
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: index == _currentImageIndex ? Colors.white : Colors.white.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          
          // Image counter
          if (images.length > 1)
            Positioned(
              bottom: 16.h,
              right: 16.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'View ${_currentImageIndex + 1} Image',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPropertyTitle(RentCreateState state) {
    return Text(
      state.formData.propertyTitle ?? 'Property Title Not Set',
      style: AppTextStyles.h4.copyWith(
        color: AppColors.textPrimary,
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
    );
  }

  Widget _buildMainDetailsSection(RentCreateState state) {
    return _buildWhiteSection(
      title: 'Main Details',
      child: Column(
        children: [
          _buildDetailRow('Price', '${state.formData.pricePerNight ?? 0} \$ - Night'),
          _buildDetailRow('Property Type', state.formData.propertyTypeName ?? 'Not Set'),
          _buildDetailRow('Maximum Guests', '${state.formData.maximumNumberOfGuests} Guests'),
        ],
      ),
    );
  }

  Widget _buildRoomDetailsSection(RentCreateState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Bedrooms', '${state.formData.bedrooms} Bedrooms'),
        _buildDetailRow('Bathrooms', '${state.formData.bathrooms} Bathrooms'),
        _buildDetailRow('Number Of Beds', '${state.formData.numberOfBeds} Beds'),
        _buildDetailRow('Floor', '${state.formData.floor}${_getFloorSuffix(state.formData.floor)} Floor'),
        SizedBox(height: 8.h),
        _buildDetailRow('Living Rooms', '${state.formData.livingRooms} Rooms'),
      ],
    );
  }

  Widget _buildDetailsSection(RentCreateState state) {
    return _buildWhiteSection(
      title: 'Details',
      child: Text(
        state.formData.propertyDescription?.isNotEmpty == true 
            ? state.formData.propertyDescription!
            : 'No description provided',
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
          fontSize: 14.sp,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildPropertyFeaturesSection(RentCreateState state) {
    // Get actual user-selected features or show defaults
    final userFeatures = state.formData.selectedFeatures;
    final features = userFeatures.isNotEmpty 
        ? userFeatures.take(4).toList()
        : ['AC', 'Parking', 'Gym', 'Solar Panel'];

    return _buildWhiteSection(
      title: 'Property Features',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: features.map((feature) {
          return Column(
            children: [
              Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  _getFeatureIcon(feature),
                  color: AppColors.primary,
                  size: 28.sp,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                feature,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLocationSection(RentCreateState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.location_on,
              color: AppColors.primary,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'Property Location',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(),
            TextButton(
              onPressed: () {
                // Handle show map with actual coordinates
                print('Show map at: ${state.formData.latitude}, ${state.formData.longitude}');
              },
              child: Text(
                'Show',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          height: 150.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.map,
                  size: 40.sp,
                  color: Colors.grey[600],
                ),
                SizedBox(height: 8.h),
                Text(
                  'Map Preview',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.grey[600],
                    fontSize: 14.sp,
                  ),
                ),
                if (state.formData.address?.isNotEmpty == true)
                  Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Text(
                      state.formData.address!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.grey[500],
                        fontSize: 12.sp,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHouseRulesSection(RentCreateState state) {
    return _buildWhiteSection(
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
          SizedBox(height: 8.h),
          Text(
            'Check Out Before 12:00 AM',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Minimum Age To Rent : 18',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'No Pets Allowed',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Smoking Is Not Permitted',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontSize: 14.sp,
            ),
          ),
          // Add user's custom house rules if provided
          if (state.formData.houseRules?.isNotEmpty == true) ...[
            SizedBox(height: 12.h),
            Text(
              'Additional Rules:',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              state.formData.houseRules!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontSize: 14.sp,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCancellationPolicySection() {
    return _buildWhiteSection(
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
          SizedBox(height: 8.h),
          Text(
            'A Policy Of No Refund And Cancel Your Booking You Will Not Get A Refund Or Credit For Future Stay.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontSize: 14.sp,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportantToReadSection(RentCreateState state) {
    return _buildWhiteSection(
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
          SizedBox(height: 8.h),
          Text(
            state.formData.importantInformation?.isNotEmpty == true
                ? state.formData.importantInformation!
                : 'No additional information provided.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontSize: 14.sp,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhiteSection({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
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
      padding: EdgeInsets.only(bottom: 8.h),
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
              fontWeight: FontWeight.w600,
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
      case 'solar panel':
      case 'solar':
        return Icons.solar_power;
      default:
        return Icons.check_circle;
    }
  }
}
