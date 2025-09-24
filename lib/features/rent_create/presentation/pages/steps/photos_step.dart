import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../theming/colors.dart';
import '../../../../../theming/text_styles.dart';
import '../../bloc/rent_create_bloc.dart';
import '../../bloc/rent_create_event.dart';
import '../../bloc/rent_create_state.dart';

class PhotosStep extends StatelessWidget {
  const PhotosStep({super.key});

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
              _buildRequirementNotice(),
              SizedBox(height: 24.h),
              _buildPhotoGrid(context, state),
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
          'Photos',
          style: AppTextStyles.h3.copyWith(
            color: AppColors.primary,
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Property Images',
          style: AppTextStyles.h4.copyWith(
            color: AppColors.textPrimary,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildRequirementNotice() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.red,
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'You Need To Add Atleast 20 Photos Of Your Property To Increase The Trust To Your Advertisment',
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.red[700],
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoGrid(BuildContext context, RentCreateState state) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.0,
      ),
      itemCount: _getGridItemCount(state.formData.selectedImages),
      itemBuilder: (context, index) {
        final images = state.formData.selectedImages;
        
        if (index == 0 && images.isNotEmpty) {
          // Primary image slot
          return _buildPrimaryImageSlot(context, images[0], state);
        } else if (index > 0 && index <= images.length) {
          // Regular image slots
          return _buildImageSlot(context, images[index - 1], index - 1, state);
        } else {
          // Empty slots
          return _buildEmptyImageSlot(context);
        }
      },
    );
  }

  int _getGridItemCount(List<File> images) {
    // Show at least 8 slots (including primary and 7 regular slots)
    return images.length < 7 ? 8 : images.length + 1;
  }

  Widget _buildPrimaryImageSlot(BuildContext context, File image, RentCreateState state) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: Image.file(
              image,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 8.w,
            right: 8.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                'Primary',
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 8.w,
            right: 8.w,
            child: GestureDetector(
              onTap: () {
                context.read<RentCreateBloc>().add(const RemovePhotoEvent(0));
              },
              child: Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSlot(BuildContext context, File image, int index, RentCreateState state) {
    final actualIndex = index + 1; // Adjust for primary image
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: Image.file(
              image,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 8.w,
            right: 8.w,
            child: Row(
              children: [
                if (actualIndex != (state.formData.primaryImageIndex ?? 0))
                  GestureDetector(
                    onTap: () {
                      context.read<RentCreateBloc>().add(SetPrimaryPhotoEvent(actualIndex));
                    },
                    child: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.8),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.star,
                        color: Colors.white,
                        size: 16.sp,
                      ),
                    ),
                  ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () {
                    context.read<RentCreateBloc>().add(RemovePhotoEvent(actualIndex));
                  },
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.8),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyImageSlot(BuildContext context) {
    return GestureDetector(
      onTap: () => _showImageSourceDialog(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: Colors.grey[300]!,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_photo_alternate_outlined,
                color: Colors.grey[400],
                size: 24.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Add Photo',
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.grey[500],
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context) {
    // Capture the parent context that has access to the RentCreateBloc
    final parentContext = context;
    
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (BuildContext bottomSheetContext) {
        return Container(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Image Source',
                style: AppTextStyles.h4.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: _buildImageSourceOption(
                      context: bottomSheetContext,
                      icon: Icons.camera_alt,
                      title: 'Camera',
                      onTap: () {
                        Navigator.pop(bottomSheetContext);
                        _pickImages(parentContext, ImageSource.camera); // Use parent context
                      },
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: _buildImageSourceOption(
                      context: bottomSheetContext,
                      icon: Icons.photo_library,
                      title: 'Gallery',
                      onTap: () {
                        Navigator.pop(bottomSheetContext);
                        _pickImages(parentContext, ImageSource.gallery); // Use parent context
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageSourceOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 32.sp,
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImages(BuildContext context, ImageSource source) async {
    try {
      // Store BLoC reference before async operation
      final bloc = context.read<RentCreateBloc>();
      final ImagePicker picker = ImagePicker();
      
      if (source == ImageSource.gallery) {
        // Pick multiple images from gallery
        print('📱 Opening gallery for multiple images...');
        final List<XFile> images = await picker.pickMultipleMedia();
        print('📱 Selected ${images.length} images');
        
        if (images.isNotEmpty) {
          final files = images.map((xfile) => File(xfile.path)).toList();
          print('📱 Adding ${files.length} files to BLoC');
          print('📱 File paths: ${files.map((f) => f.path).toList()}');
          bloc.add(AddPhotosEvent(files));
        } else {
          print('📱 No images selected from gallery');
        }
      } else {
        // Pick single image from camera
        print('📱 Opening camera...');
        final XFile? image = await picker.pickImage(source: source);
        print('📱 Camera image: ${image?.path ?? 'null'}');
        
        if (image != null) {
          final file = File(image.path);
          print('📱 Adding camera image to BLoC');
          print('📱 Camera file path: ${file.path}');
          bloc.add(AddPhotosEvent([file]));
        } else {
          print('📱 No image taken from camera');
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking images: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
