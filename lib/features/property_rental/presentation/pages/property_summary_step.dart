import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../../domain/entities/property.dart';
import '../../domain/entities/property_availability.dart';
import '../../domain/entities/property_image.dart';
import '../bloc/property_rental_bloc.dart';
import '../bloc/property_rental_event.dart';
import '../bloc/property_rental_state.dart';

class PropertySummaryStep extends StatefulWidget {
  final VoidCallback onPrevious;
  final Map<String, dynamic> propertyData;

  const PropertySummaryStep({
    super.key,
    required this.onPrevious,
    required this.propertyData,
  });

  @override
  State<PropertySummaryStep> createState() => _PropertySummaryStepState();
}

class _PropertySummaryStepState extends State<PropertySummaryStep> {
  Future<void> _submitProperty() async {
    final bloc = context.read<PropertyRentalBloc>();

    // Convert widget.propertyData to domain entities
    final property = _mapToPropertyEntity(widget.propertyData);
    final availabilities = _mapToAvailabilityEntities(widget.propertyData);
    final images = _mapToImageEntities(widget.propertyData);

    // Trigger the complete property creation event
    bloc.add(
      CompletePropertyCreationEvent(
        property: property,
        availabilities: availabilities,
        images: images,
      ),
    );
  }

  Property _mapToPropertyEntity(Map<String, dynamic> data) {
    return Property(
      propertyTitle: data['propertyTitle'] ?? '',
      hotelName: data['hotelName'] ?? data['propertyTitle'] ?? '',
      bedrooms: data['bedrooms'] ?? 1,
      bathrooms: data['bathrooms'] ?? 1,
      numberOfBed: data['numberOfBed'] ?? 1,
      floor: data['floor'] ?? 1,
      maximumNumberOfGuest: data['maximumNumberOfGuest'] ?? 2,
      livingrooms: data['livingrooms'] ?? 1,
      propertyDescription: data['propertyDescription'] ?? '',
      houseRules: data['hourseRules'] ?? '',
      importantInformation: data['importantInformation'] ?? '',
      address: data['address'] ?? '',
      streetAndBuildingNumber: data['streetAndBuildingNumber'] ?? '',
      landMark: data['landMark'] ?? '',
      pricePerNight: (data['pricePerNight'] ?? 0.0).toDouble(),
      isActive: data['isActive'] ?? true,
      propertyTypeId: data['propertyTypeId'] ?? '',
      governorateId:
          data['governorateId'] ?? 'b302846a-a78c-3ab8-c22e-3a1c43b80365',
      propertyFeatureIds: List<String>.from(data['propertyFeatureIds'] ?? []),
    );
  }

  List<PropertyAvailability> _mapToAvailabilityEntities(
    Map<String, dynamic> data,
  ) {
    final availabilityList =
        data['availabilityList'] as List<Map<String, dynamic>>? ?? [];
    return availabilityList.map((availability) {
      return PropertyAvailability(
        propertyId: '', // Will be set by BLoC
        date: availability['date'] ?? '',
        isAvailable: availability['isAvailable'] ?? true,
        price: (availability['price'] ?? 0.0).toDouble(),
        note: availability['note'] ?? '',
      );
    }).toList();
  }

  List<PropertyImage> _mapToImageEntities(Map<String, dynamic> data) {
    final imagesData = data['imagesData'] as List<Map<String, dynamic>>? ?? [];
    return imagesData.map((imageData) {
      return PropertyImage(
        propertyId: '', // Will be set by BLoC
        imagePath: imageData['image'] ?? '',
        order: imageData['order'] ?? 0,
        isActive: imageData['isActive'] ?? true,
        isPrimary: imageData['isPrimary'] ?? false,
      );
    }).toList();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 64.sp),
            SizedBox(height: 16.h),
            Text(
              'Property Added Successfully!',
              style: AppTextStyles.h4.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              'Your property has been submitted and is now available for booking.',
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Done',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getPropertyTypeName(String? typeId) {
    const typeMap = {
      '4107a890-5b67-d4a0-a65d-3a1c14c71df3': 'Apartment',
      '4107a890-5b67-d4a0-a65d-3a1c14c71df4': 'House',
      '4107a890-5b67-d4a0-a65d-3a1c14c71df5': 'Hotel',
      '4107a890-5b67-d4a0-a65d-3a1c14c71df6': 'Motel',
      '4107a890-5b67-d4a0-a65d-3a1c14c71df7': 'Villa',
    };
    return typeMap[typeId] ?? 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main property image
                  if (widget.propertyData['imagesData'] != null &&
                      (widget.propertyData['imagesData']
                              as List<Map<String, dynamic>>)
                          .isNotEmpty)
                    _buildMainImage(),

                  SizedBox(height: 16.h),

                  // Property title and type
                  Text(
                    widget.propertyData['propertyTitle'] ?? 'Property Title',
                    style: AppTextStyles.h4.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  // Main details section
                  _buildMainDetailsSection(),

                  SizedBox(height: 24.h),

                  // Property features
                  _buildPropertyFeaturesSection(),

                  SizedBox(height: 24.h),

                  // Location section
                  _buildLocationSection(),

                  SizedBox(height: 24.h),

                  // House rules section
                  _buildHouseRulesSection(),

                  SizedBox(height: 100.h), // Space for floating button
                ],
              ),
            ),
          ),

          // Submit button
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildMainImage() {
    final imagesData =
        widget.propertyData['imagesData'] as List<Map<String, dynamic>>;
    final primaryImage = imagesData.firstWhere(
      (img) => img['isPrimary'] == true,
      orElse: () => imagesData.first,
    );

    return Container(
      width: double.infinity,
      height: 200.h,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Image.file(File(primaryImage['image']), fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildMainDetailsSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Main Details',
            style: AppTextStyles.h5.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12.h),

          Row(
            children: [
              Text('Price: ', style: AppTextStyles.bodyMedium),
              Text(
                '${widget.propertyData['pricePerNight'] ?? 0} \$ • Night',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),

          Row(
            children: [
              Text('Property Type: ', style: AppTextStyles.bodyMedium),
              Text(
                _getPropertyTypeName(widget.propertyData['propertyTypeId']),
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),

          Row(
            children: [
              Text('Maximum Guests: ', style: AppTextStyles.bodyMedium),
              Text(
                '${widget.propertyData['maximumNumberOfGuest'] ?? 0} Guests',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // Room details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDetailItem(
                'Bedrooms',
                '${widget.propertyData['bedrooms'] ?? 0} Bedrooms',
              ),
              _buildDetailItem(
                'Bathrooms',
                '${widget.propertyData['bathrooms'] ?? 0} Bathrooms',
              ),
            ],
          ),
          SizedBox(height: 8.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDetailItem(
                'Number Of Beds',
                '${widget.propertyData['numberOfBed'] ?? 0} Beds',
              ),
              _buildDetailItem(
                'Floor',
                '${widget.propertyData['floor'] ?? 0} Floor',
              ),
            ],
          ),
          SizedBox(height: 8.h),

          _buildDetailItem(
            'Living Rooms',
            '${widget.propertyData['livingrooms'] ?? 0} Rooms',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.grey[600],
            fontSize: 12.sp,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildPropertyFeaturesSection() {
    final features = widget.propertyData['propertyFeatureIds'] as List?;
    if (features == null || features.isEmpty) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Property Features',
          style: AppTextStyles.h5.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),

        Row(
          children: [
            _buildFeatureIcon(Icons.ac_unit, 'AC'),
            SizedBox(width: 16.w),
            _buildFeatureIcon(Icons.local_parking, 'Parking'),
            SizedBox(width: 16.w),
            _buildFeatureIcon(Icons.fitness_center, 'Gym'),
            SizedBox(width: 16.w),
            _buildFeatureIcon(Icons.wb_sunny, 'Solar Panel'),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 48.w,
          height: 48.h,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: AppColors.primary, size: 24.sp),
        ),
        SizedBox(height: 4.h),
        Text(label, style: AppTextStyles.bodySmall.copyWith(fontSize: 10.sp)),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.location_on, color: AppColors.primary, size: 20.sp),
            SizedBox(width: 4.w),
            Text(
              'Property Location',
              style: AppTextStyles.h5.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(),
            TextButton(
              onPressed: () {},
              child: Text(
                'Show',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),

        // Map placeholder
        Container(
          width: double.infinity,
          height: 120.h,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map, size: 32.sp, color: Colors.grey[400]),
                SizedBox(height: 4.h),
                Text(
                  widget.propertyData['displayAddress'] ?? 'Damascus, Al Qusor',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHouseRulesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'House Rules',
          style: AppTextStyles.h5.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),

        _buildRuleItem('Check In After 3:00 PM'),
        _buildRuleItem('Check Out Before 12:00 AM'),
        _buildRuleItem('Minimum Age To Rent : 18'),
        _buildRuleItem('No Pets Allowed'),
        _buildRuleItem('Smoking Is Not Permitted'),

        SizedBox(height: 16.h),

        Text(
          'Cancellation Policy',
          style: AppTextStyles.h5.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),

        Text(
          'No Refund',
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 4.h),

        Text(
          'If You Change Or Cancel Your Booking, You Will Not Get A Refund Or Credit For Future Stays.',
          style: AppTextStyles.bodySmall.copyWith(color: Colors.grey[600]),
        ),

        SizedBox(height: 16.h),

        Text(
          'Important To Read',
          style: AppTextStyles.h5.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),

        Text(
          'You Need To Know',
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 4.h),

        Text(
          widget.propertyData['importantInformation'] ??
              'If You Change Or Cancel Your Booking, You Will Not Get A Refund Or Credit For Future Stays. For Safety Reasons, Smoking Is Not Allowed Inside And On Levels.',
          style: AppTextStyles.bodySmall.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildRuleItem(String rule) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 16.sp),
          SizedBox(width: 8.w),
          Text(rule, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<PropertyRentalBloc, PropertyRentalState>(
      builder: (context, state) {
        final isLoading = state is PropertyRentalLoading;

        return SizedBox(
          width: double.infinity,
          height: 56.h,
          child: ElevatedButton(
            onPressed: isLoading ? null : _submitProperty,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28.r),
              ),
            ),
            child: isLoading
                ? SizedBox(
                    width: 24.w,
                    height: 24.h,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'Post Now',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
