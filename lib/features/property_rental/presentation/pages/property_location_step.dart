import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../widgets/map_picker_widget.dart';

class PropertyLocationStep extends StatefulWidget {
  final Function(Map<String, dynamic>) onNext;
  final VoidCallback onPrevious;
  final Map<String, dynamic> initialData;

  const PropertyLocationStep({
    super.key,
    required this.onNext,
    required this.onPrevious,
    required this.initialData,
  });

  @override
  State<PropertyLocationStep> createState() => _PropertyLocationStepState();
}

class _PropertyLocationStepState extends State<PropertyLocationStep> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _addressController = TextEditingController();
  final _streetController = TextEditingController();
  final _landmarkController = TextEditingController();

  // Location coordinates (lat, lon)
  String _selectedLocation = '';
  double? _selectedLat;
  double? _selectedLng;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    if (widget.initialData.isNotEmpty) {
      _addressController.text = widget.initialData['displayAddress'] ?? '';
      _streetController.text =
          widget.initialData['streetAndBuildingNumber'] ?? '';
      _landmarkController.text = widget.initialData['landMark'] ?? '';
      _selectedLocation = widget.initialData['address'] ?? '';

      // Parse coordinates if available
      if (_selectedLocation.isNotEmpty && _selectedLocation.contains(',')) {
        final coords = _selectedLocation.split(',');
        if (coords.length == 2) {
          _selectedLat = double.tryParse(coords[0]);
          _selectedLng = double.tryParse(coords[1]);
        }
      }
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _streetController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (_formKey.currentState!.validate()) {
      final data = {
        'address': _selectedLocation, // This will be lat,lon format
        'streetAndBuildingNumber': _streetController.text,
        'landMark': _landmarkController.text,
        'displayAddress': _addressController.text, // For display purposes
      };

      widget.onNext(data);
    }
  }

  void _clearLocation() {
    setState(() {
      _selectedLocation = '';
      _selectedLat = null;
      _selectedLng = null;
      _addressController.clear();
    });
  }

  void _selectLocationOnMap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapPickerWidget(
          initialAddress: _addressController.text,
          onLocationSelected: (lat, lng, address) {
            setState(() {
              _selectedLat = lat;
              _selectedLng = lng;
              _selectedLocation = '$lat,$lng';
              _addressController.text = address;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Location selected successfully'),
                backgroundColor: Colors.green,
              ),
            );
          },
        ),
      ),
    );
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
                    // Location header with clear button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Property Location',
                          style: AppTextStyles.h5.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton(
                          onPressed: _clearLocation,
                          child: Text(
                            'Clear',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h),

                    // Map placeholder
                    GestureDetector(
                      onTap: _selectLocationOnMap,
                      child: Container(
                        width: double.infinity,
                        height: 200.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Stack(
                          children: [
                            // Map placeholder image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: Colors.grey[200],
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.map_outlined,
                                      size: 48.sp,
                                      color: Colors.grey[400],
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      'Tap to select location',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Location marker if selected
                            if (_selectedLat != null && _selectedLng != null)
                              Positioned(
                                top: 80.h,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: AppColors.primary,
                                        size: 32.sp,
                                      ),
                                      SizedBox(height: 4.h),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 4.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius: BorderRadius.circular(
                                            4.r,
                                          ),
                                        ),
                                        child: Text(
                                          'Selected',
                                          style: AppTextStyles.bodySmall
                                              .copyWith(
                                                color: Colors.white,
                                                fontSize: 10.sp,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Address field
                    _buildSectionTitle('Address'),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      controller: _addressController,
                      hintText: 'Select location from map above',
                      validator: (value) => value?.isEmpty == true
                          ? 'Please select location from map'
                          : null,
                      suffixIcon: Icon(
                        Icons.location_on,
                        color: AppColors.primary,
                        size: 20.sp,
                      ),
                      readOnly: true,
                    ),

                    SizedBox(height: 16.h),

                    // Street and building number
                    _buildSectionTitle('Street, Building Number'),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      controller: _streetController,
                      hintText: 'e.g., 123 Main Street, Building A',
                      validator: (value) =>
                          value?.isEmpty == true ? 'Street is required' : null,
                    ),

                    SizedBox(height: 16.h),

                    // Landmark
                    _buildSectionTitle('Land Mark'),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      controller: _landmarkController,
                      hintText:
                          'e.g., Near Central Mall, 5 minutes from Metro Station',
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
      style: AppTextStyles.bodyMedium.copyWith(
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    String? Function(String?)? validator,
    Widget? suffixIcon,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      readOnly: readOnly,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[400]),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: readOnly ? Colors.grey[100] : Colors.grey[50],
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
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      ),
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
