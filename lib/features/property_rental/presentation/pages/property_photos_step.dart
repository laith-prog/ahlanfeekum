import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';

class PropertyPhotosStep extends StatefulWidget {
  final Function(Map<String, dynamic>) onNext;
  final VoidCallback onPrevious;
  final Map<String, dynamic> initialData;

  const PropertyPhotosStep({
    super.key,
    required this.onNext,
    required this.onPrevious,
    required this.initialData,
  });

  @override
  State<PropertyPhotosStep> createState() => _PropertyPhotosStepState();
}

class _PropertyPhotosStepState extends State<PropertyPhotosStep> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedImages = [];
  int? _primaryImageIndex = 0;
  final int _maxImages = 8;
  final int _minImages = 1; // Changed from 20 to 1 for demo purposes

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    if (widget.initialData['selectedImages'] != null) {
      _selectedImages = List<XFile>.from(widget.initialData['selectedImages']);
      _primaryImageIndex = widget.initialData['primaryImageIndex'] ?? 0;
    }
  }

  Future<void> _pickSingleImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null && _selectedImages.length < _maxImages) {
        setState(() {
          _selectedImages.add(image);

          // Set as primary if it's the first image
          if (_primaryImageIndex == null) {
            _primaryImageIndex = _selectedImages.length - 1;
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error picking image'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);

      // Adjust primary image index
      if (_primaryImageIndex == index) {
        _primaryImageIndex = _selectedImages.isNotEmpty ? 0 : null;
      } else if (_primaryImageIndex != null && _primaryImageIndex! > index) {
        _primaryImageIndex = _primaryImageIndex! - 1;
      }
    });
  }

  void _setPrimaryImage(int index) {
    setState(() {
      _primaryImageIndex = index;
    });
  }

  void _handleNext() {
    if (_selectedImages.length < _minImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'You Need To Add At least $_minImages Photos Of Your Property To Increase The Trust To Your Advertisement',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Prepare images data for API
    List<Map<String, dynamic>> imagesData = _selectedImages.asMap().entries.map(
      (entry) {
        return {
          'image': entry
              .value
              .path, // In real app, this would be uploaded to server first
          'order': entry.key,
          'isActive': true,
          'isPrimary': entry.key == _primaryImageIndex,
        };
      },
    ).toList();

    final data = {
      'imagesData': imagesData,
      'selectedImages': _selectedImages,
      'primaryImageIndex': _primaryImageIndex,
    };

    widget.onNext(data);
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
                  // Warning message
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.red,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            'You Need To Add At least $_minImages Photos Of Your Property To Increase The Trust To Your Advertisement',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.red.shade700,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Property Images title
                  Text(
                    'Property Images',
                    style: AppTextStyles.h5.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Primary image section
                  if (_selectedImages.isNotEmpty && _primaryImageIndex != null)
                    _buildPrimaryImageSection(),

                  if (_selectedImages.isNotEmpty && _primaryImageIndex != null)
                    SizedBox(height: 16.h),

                  // Images grid
                  _buildImagesGrid(),

                  SizedBox(height: 100.h), // Space for floating button
                ],
              ),
            ),
          ),

          // Next button
          _buildNextButton(),
        ],
      ),
    );
  }

  Widget _buildPrimaryImageSection() {
    if (_primaryImageIndex == null ||
        _primaryImageIndex! >= _selectedImages.length) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Primary',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                'Main Photo',
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.white,
                  fontSize: 10.sp,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          height: 200.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Image.file(
              File(_selectedImages[_primaryImageIndex!].path),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
        childAspectRatio: 1,
      ),
      itemCount: _maxImages,
      itemBuilder: (context, index) {
        if (index < _selectedImages.length) {
          // Show selected image
          return _buildImageTile(index);
        } else {
          // Show empty slot
          return _buildEmptyImageTile();
        }
      },
    );
  }

  Widget _buildImageTile(int index) {
    final isPrimary = index == _primaryImageIndex;

    return GestureDetector(
      onTap: () => _setPrimaryImage(index),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: isPrimary
              ? Border.all(color: AppColors.primary, width: 2)
              : Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6.r),
              child: Image.file(
                File(_selectedImages[index].path),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),

            // Remove button
            Positioned(
              top: 4.w,
              right: 4.w,
              child: GestureDetector(
                onTap: () => _removeImage(index),
                child: Container(
                  width: 24.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, color: Colors.white, size: 16.sp),
                ),
              ),
            ),

            // Primary indicator
            if (isPrimary)
              Positioned(
                bottom: 4.w,
                left: 4.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    'Primary',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white,
                      fontSize: 8.sp,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyImageTile() {
    return GestureDetector(
      onTap: _pickSingleImage,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: Colors.grey[300]!,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              color: Colors.grey[400],
              size: 24.sp,
            ),
          ],
        ),
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
