import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';

import '../../domain/entities/home_entities.dart';

class HotelsOfWeekWidget extends StatelessWidget {
  final List<HotelOfTheWeek>? hotels;
  const HotelsOfWeekWidget({super.key, this.hotels});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Icon(Icons.star_border_rounded, color: Colors.orange, size: 18.sp),
                SizedBox(width: 8.w),
                Text(
                  'Hotels Of The Week',
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

          if (hotels != null && hotels!.isNotEmpty)
            SizedBox(
              height: 75.h,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final h = hotels![index];
                  return _buildHostCard(h.averageRating, h.name, h.profilePhotoUrl);
                },
                separatorBuilder: (_, __) => SizedBox(width: 12.w),
                itemCount: hotels!.length,
              ),
            )
          else
            // Show empty state or loading
            SizedBox(
              height: 75.h,
              child: Center(
                child: Text(
                  'No hotels available',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHostCard(double? rating, String name, String? avatarUrl) {
    return Container(
      width: 175.w,
      height: 75.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            // Profile Avatar
            CircleAvatar(
              radius: 25.r,
              backgroundColor: AppColors.primary.withOpacity(0.15),
              backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty 
                  ? NetworkImage(avatarUrl) 
                  : null,
              child: avatarUrl == null || avatarUrl.isEmpty
                  ? Icon(
                      Icons.person, 
                      color: AppColors.primary, 
                      size: 20.sp,
                    )
                  : null,
            ),
            
            SizedBox(width: 12.w),
            
            // Name and Rating Column
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating with star
                  if (rating != null)
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 14.sp,
                          color: Colors.amber,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          rating.toStringAsFixed(1),
                          style: AppTextStyles.bodySmall.copyWith(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.amber.shade600,
                          ),
                        ),
                      ],
                    ),
                  
                  SizedBox(height: 4.h),
                  
                  // Host Name
                  Text(
                    name,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

