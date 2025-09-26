import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/home_entities.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';

class OnlyForYouWidget extends StatelessWidget {
  final OnlyForYouSection? onlyForYouSection;

  const OnlyForYouWidget({
    super.key,
    required this.onlyForYouSection,
  });

  @override
  Widget build(BuildContext context) {
    if (onlyForYouSection == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                SizedBox(width: 8.w),
                Text(
                  'Only  For You !',
                  style: AppTextStyles.h4.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Icon(Icons.chevron_right, color: Colors.grey[500], size: 22.sp),
              ],
            ),
          ),

          SizedBox(height: 12.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Expanded(child: _buildPhotoCard(onlyForYouSection!.firstPhotoUrl, height: 160.h)),
                SizedBox(width: 12.w),
                Expanded(child: _buildPhotoCard(onlyForYouSection!.secondPhotoUrl, height: 160.h)),
              ],
            ),
          ),

          SizedBox(height: 12.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: _buildPhotoCard(onlyForYouSection!.thirdPhotoUrl, height: 120.h),
          ),

          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildPhotoCard(String imageUrl, {double? height}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: double.infinity,
          height: height ?? double.infinity,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey[200],
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                strokeWidth: 2,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: AppColors.primary.withOpacity(0.1),
            child: Center(
              child: Icon(
                Icons.image_outlined,
                color: AppColors.primary,
                size: 40.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}