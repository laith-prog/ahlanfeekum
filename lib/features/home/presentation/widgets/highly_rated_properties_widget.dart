import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/home_entities.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';

class HighlyRatedPropertiesWidget extends StatelessWidget {
  final List<Property> properties;

  const HighlyRatedPropertiesWidget({super.key, required this.properties});

  @override
  Widget build(BuildContext context) {
    if (properties.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.only(top: 16.h, bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                Icon(Icons.star_border_outlined, color: AppColors.primary, size: 24.sp),
                SizedBox(width: 8.w),
                Text(
                  'Highly Rated Properties',
                  style: AppTextStyles.h4.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Icon(Icons.chevron_right, color: Colors.grey[500], size: 20.sp),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          SizedBox(
            height: 200.h,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              scrollDirection: Axis.horizontal,
              itemCount: properties.length,
              separatorBuilder: (_, __) => SizedBox(width: 12.w),
              itemBuilder: (context, index) {
                final property = properties[index];
                return Container(
                  width: 160.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(14.r)),
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl: property.mainImageUrl ?? 'https://via.placeholder.com/300x200',
                              width: double.infinity,
                              height: 110.h,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[200],
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: AppColors.primary.withOpacity(0.1),
                                child: Icon(Icons.home_outlined, color: AppColors.primary, size: 28.sp),
                              ),
                            ),
                            if (property.averageRating != null && property.averageRating! > 0)
                              Positioned(
                                top: 8.h,
                                left: 8.w,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.star, size: 12.sp, color: Colors.white),
                                      SizedBox(width: 3.w),
                                      Text(
                                        property.averageRating!.toStringAsFixed(1),
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: Colors.white, 
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            // Heart icon (favorite) in top right
                            Positioned(
                              top: 8.h,
                              right: 8.w,
                              child: Container(
                                padding: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.favorite_border,
                                  color: Colors.grey[600],
                                  size: 16.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  property.title,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textPrimary,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              // Property type and distance row
                              Row(
                                children: [
                                  // Property type icon
                                  Icon(
                                    property.hotelName != null 
                                        ? Icons.hotel 
                                        : Icons.apartment,
                                    size: 12.sp, 
                                    color: Colors.grey[600],
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    property.hotelName != null ? 'Hotel' : 'Apartment',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: Colors.grey[600], 
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  // Distance/Area
                                  SizedBox(width: 2.w),
                                   Text(
                                     (property.area != null && property.area! > 0)
                                         ? '${property.area!.toInt()} M²'
                                         : '?? M', // Default distance when area is null or 0
                                     style: AppTextStyles.bodySmall.copyWith(
                                       color: AppColors.primary,
                                       fontSize: 10.sp,
                                     ),
                                   ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


