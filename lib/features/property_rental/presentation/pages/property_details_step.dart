import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';

class PropertyDetailsStep extends StatefulWidget {
  final Function(Map<String, dynamic>) onNext;
  final Map<String, dynamic> initialData;

  const PropertyDetailsStep({
    super.key,
    required this.onNext,
    required this.initialData,
  });

  @override
  State<PropertyDetailsStep> createState() => _PropertyDetailsStepState();
}

class _PropertyDetailsStepState extends State<PropertyDetailsStep> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _propertyTitleController = TextEditingController();
  final _propertyDescriptionController = TextEditingController();
  final _houseRulesController = TextEditingController();
  final _importantInfoController = TextEditingController();

  // Property type selection
  String? _selectedPropertyType;
  final List<Map<String, String>> _propertyTypes = [
    {'id': '4107a890-5b67-d4a0-a65d-3a1c14c71df3', 'name': 'Apartment'},
    {'id': '4107a890-5b67-d4a0-a65d-3a1c14c71df4', 'name': 'House'},
    {'id': '4107a890-5b67-d4a0-a65d-3a1c14c71df5', 'name': 'Hotel'},
    {'id': '4107a890-5b67-d4a0-a65d-3a1c14c71df6', 'name': 'Motel'},
    {'id': '4107a890-5b67-d4a0-a65d-3a1c14c71df7', 'name': 'Villa'},
  ];

  // Counters
  int _bedrooms = 1;
  int _bathrooms = 1;
  int _numberOfBeds = 1;
  int _floor = 2;
  int _maxGuests = 2;
  int _livingRooms = 1;

  // Property features
  final List<Map<String, dynamic>> _features = [
    {
      'id': '27fcfcdd-6df6-1bcc-30fc-3a1c14c84012',
      'name': 'Solar Energy',
      'selected': false,
    },
    {
      'id': '27fcfcdd-6df6-1bcc-30fc-3a1c14c84013',
      'name': 'WiFi',
      'selected': false,
    },
    {
      'id': '27fcfcdd-6df6-1bcc-30fc-3a1c14c84014',
      'name': 'Kitchen',
      'selected': false,
    },
    {
      'id': '27fcfcdd-6df6-1bcc-30fc-3a1c14c84015',
      'name': 'Amber',
      'selected': false,
    },
    {
      'id': '27fcfcdd-6df6-1bcc-30fc-3a1c14c84016',
      'name': 'Hot Water',
      'selected': false,
    },
    {
      'id': '27fcfcdd-6df6-1bcc-30fc-3a1c14c84017',
      'name': 'Garden',
      'selected': false,
    },
    {
      'id': '27fcfcdd-6df6-1bcc-30fc-3a1c14c84018',
      'name': 'Balcony',
      'selected': false,
    },
    {
      'id': '27fcfcdd-6df6-1bcc-30fc-3a1c14c84019',
      'name': 'BBQ Grill',
      'selected': false,
    },
    {
      'id': '27fcfcdd-6df6-1bcc-30fc-3a1c14c84020',
      'name': 'Refrigerator',
      'selected': false,
    },
    {
      'id': '27fcfcdd-6df6-1bcc-30fc-3a1c14c84021',
      'name': 'Oven',
      'selected': false,
    },
    {
      'id': '27fcfcdd-6df6-1bcc-30fc-3a1c14c84022',
      'name': 'TV',
      'selected': false,
    },
    {
      'id': '27fcfcdd-6df6-1bcc-30fc-3a1c14c84023',
      'name': 'Washing Machine',
      'selected': false,
    },
    {
      'id': '27fcfcdd-6df6-1bcc-30fc-3a1c14c84024',
      'name': 'AC',
      'selected': false,
    },
    {
      'id': '27fcfcdd-6df6-1bcc-30fc-3a1c14c84025',
      'name': 'Parking',
      'selected': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    if (widget.initialData.isNotEmpty) {
      _propertyTitleController.text = widget.initialData['propertyTitle'] ?? '';
      _propertyDescriptionController.text =
          widget.initialData['propertyDescription'] ?? '';
      _houseRulesController.text = widget.initialData['hourseRules'] ?? '';
      _importantInfoController.text =
          widget.initialData['importantInformation'] ?? '';

      _selectedPropertyType = widget.initialData['propertyTypeId'];
      _bedrooms = widget.initialData['bedrooms'] ?? 1;
      _bathrooms = widget.initialData['bathrooms'] ?? 1;
      _numberOfBeds = widget.initialData['numberOfBed'] ?? 1;
      _floor = widget.initialData['floor'] ?? 2;
      _maxGuests = widget.initialData['maximumNumberOfGuest'] ?? 2;
      _livingRooms = widget.initialData['livingrooms'] ?? 1;

      // Update features selection
      if (widget.initialData['propertyFeatureIds'] != null) {
        List<String> selectedIds = List<String>.from(
          widget.initialData['propertyFeatureIds'],
        );
        for (var feature in _features) {
          feature['selected'] = selectedIds.contains(feature['id']);
        }
      }
    }
  }

  @override
  void dispose() {
    _propertyTitleController.dispose();
    _propertyDescriptionController.dispose();
    _houseRulesController.dispose();
    _importantInfoController.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (_formKey.currentState!.validate() && _selectedPropertyType != null) {
      final data = {
        'propertyTitle': _propertyTitleController.text,
        'hotelName':
            _propertyTitleController.text, // Using same as property title
        'bedrooms': _bedrooms,
        'bathrooms': _bathrooms,
        'numberOfBed': _numberOfBeds,
        'floor': _floor,
        'maximumNumberOfGuest': _maxGuests,
        'livingrooms': _livingRooms,
        'propertyDescription': _propertyDescriptionController.text,
        'hourseRules': _houseRulesController.text,
        'importantInformation': _importantInfoController.text,
        'propertyTypeId': _selectedPropertyType,
        'governorateId':
            'b302846a-a78c-3ab8-c22e-3a1c43b80365', // Default governorate
        'propertyFeatureIds': _features
            .where((feature) => feature['selected'] == true)
            .map((feature) => feature['id'])
            .toList(),
        'isActive': true,
      };

      widget.onNext(data);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill all required fields and select property type',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Property Type Selection
                    _buildSectionTitle('Property Type'),
                    SizedBox(height: 8.h),
                    _buildPropertyTypeSelector(),

                    SizedBox(height: 24.h),

                    // Property Title
                    _buildSectionTitle('Property Title'),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      controller: _propertyTitleController,
                      hintText: 'Luxury Apartment in Downtown',
                      validator: (value) => value?.isEmpty == true
                          ? 'Property title is required'
                          : null,
                    ),

                    SizedBox(height: 24.h),

                    // Room details
                    _buildRoomCounters(),

                    SizedBox(height: 24.h),

                    // Property Description
                    _buildSectionTitle('Property Description'),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      controller: _propertyDescriptionController,
                      hintText:
                          'Describe your property, its features, and what makes it special...',
                      maxLines: 4,
                    ),

                    SizedBox(height: 24.h),

                    // More Features
                    _buildSectionTitle('More Features'),
                    SizedBox(height: 12.h),
                    _buildFeaturesGrid(),

                    SizedBox(height: 24.h),

                    // Instructions
                    _buildSectionTitle('Instructions'),
                    SizedBox(height: 8.h),
                    _buildSubSectionTitle('House Rules'),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      controller: _houseRulesController,
                      hintText: 'No smoking, No pets, Check-in after 3 PM...',
                      maxLines: 3,
                    ),

                    SizedBox(height: 16.h),

                    _buildSubSectionTitle('Important Information'),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      controller: _importantInfoController,
                      hintText:
                          'Additional information guests should know before booking...',
                      maxLines: 3,
                    ),

                    SizedBox(height: 100.h), // Space for floating button
                  ],
                ),
              ),
            ),
          ),

          // Next button
          _buildNextButton(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.h5.copyWith(
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildSubSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.bodyMedium.copyWith(
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildPropertyTypeSelector() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: _propertyTypes.map((type) {
        final isSelected = _selectedPropertyType == type['id'];
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedPropertyType = type['id'];
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.transparent,
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.grey[300]!,
              ),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              type['name']!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.grey[50],
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
          borderSide: BorderSide(color: AppColors.primary),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: maxLines > 1 ? 16.h : 12.h,
        ),
      ),
    );
  }

  Widget _buildRoomCounters() {
    return Column(
      children: [
        _buildCounter(
          'Bedrooms',
          _bedrooms,
          (value) => setState(() => _bedrooms = value),
        ),
        SizedBox(height: 16.h),
        _buildCounter(
          'Bathrooms',
          _bathrooms,
          (value) => setState(() => _bathrooms = value),
        ),
        SizedBox(height: 16.h),
        _buildCounter(
          'Number Of Beds',
          _numberOfBeds,
          (value) => setState(() => _numberOfBeds = value),
        ),
        SizedBox(height: 16.h),
        _buildCounter(
          'Floor',
          _floor,
          (value) => setState(() => _floor = value),
        ),
        SizedBox(height: 16.h),
        _buildCounter(
          'Maximum Number Of Guests',
          _maxGuests,
          (value) => setState(() => _maxGuests = value),
        ),
        SizedBox(height: 16.h),
        _buildCounter(
          'Living Rooms',
          _livingRooms,
          (value) => setState(() => _livingRooms = value),
        ),
      ],
    );
  }

  Widget _buildCounter(String label, int value, Function(int) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: value > 1 ? () => onChanged(value - 1) : null,
              icon: Icon(
                Icons.remove,
                color: value > 1 ? AppColors.primary : Colors.grey[400],
                size: 20.sp,
              ),
            ),
            Container(
              width: 40.w,
              height: 32.h,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Center(
                child: Text(
                  value.toString(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () => onChanged(value + 1),
              icon: Icon(Icons.add, color: AppColors.primary, size: 20.sp),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeaturesGrid() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: _features.map((feature) {
        final isSelected = feature['selected'] == true;
        return GestureDetector(
          onTap: () {
            setState(() {
              feature['selected'] = !isSelected;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.transparent,
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.grey[300]!,
              ),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected)
                  Icon(Icons.check_circle, color: Colors.white, size: 16.sp),
                if (isSelected) SizedBox(width: 4.w),
                Text(
                  feature['name']!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isSelected ? Colors.white : Colors.grey[700],
                    fontWeight: isSelected
                        ? FontWeight.w500
                        : FontWeight.normal,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNextButton() {
    return Container(
      width: double.infinity,
      height: 56.h,
      child: FloatingActionButton.extended(
        onPressed: _handleNext,
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.r),
        ),
        label: Icon(Icons.arrow_forward, color: Colors.white, size: 24.sp),
      ),
    );
  }
}
