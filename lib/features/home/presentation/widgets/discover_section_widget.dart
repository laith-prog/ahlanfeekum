import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/home_entities.dart';
import '../../../search/data/models/search_filter.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';

class DiscoverSectionWidget extends StatelessWidget {
  final List<Governorate> governorates;

  const DiscoverSectionWidget({
    super.key,
    required this.governorates,
  });

  @override
  Widget build(BuildContext context) {
    if (governorates.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Icon(Icons.sports_baseball_outlined, color: Colors.redAccent, size: 18.sp),
                SizedBox(width: 8.w),
                Text(
                  'Discover Your Ideal Stay',
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

          SizedBox(
            height: 145.h,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              scrollDirection: Axis.horizontal,
              itemCount: governorates.length.clamp(0, 8),
              separatorBuilder: (_, __) => SizedBox(width: 10.w),
              itemBuilder: (context, index) {
                final governorate = governorates[index];
                return GestureDetector(
                  onTap: () => _onGovernorateSelected(context, governorate),
                  child: Container(
                    width: 110.w,
                    height: 145.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 0,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Full image background
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: governorate.iconUrl != null
                              ? Image.network(
                                  governorate.iconUrl!,
                                  width: 110.w,
                                  height: 145.h,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 110.w,
                                      height: 145.h,
                                      color: AppColors.primary.withOpacity(0.1),
                                      child: Icon(
                                        Icons.location_city,
                                        color: AppColors.primary,
                                        size: 40.sp,
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  width: 110.w,
                                  height: 145.h,
                                  color: AppColors.primary.withOpacity(0.1),
                                  child: Icon(
                                    Icons.location_city,
                                    color: AppColors.primary,
                                    size: 40.sp,
                                  ),
                                ),
                        ),
                        // Gradient overlay
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Container(
                            width: 110.w,
                            height: 145.h,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.6),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Title at bottom
                        Positioned(
                          bottom: 12.h,
                          left: 8.w,
                          right: 8.w,
                          child: Text(
                            governorate.title,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onGovernorateSelected(BuildContext context, Governorate governorate) async {
    print('🏠 ===== GOVERNORATE SELECTION =====');
    print('🏠 Governorate selected: ${governorate.title}');
    print('🏠 Governorate ID: ${governorate.id}');
    
    try {
      // Create a search filter with ONLY the governorate ID for focused filtering
      final searchFilter = SearchFilter(
        governorateId: governorate.id,
        // Remove filterText to avoid potential conflicts
        skipCount: 0,
        maxResultCount: 20,
      );

      print('🏠 Created search filter:');
      print('🏠 - GovernorateId: ${searchFilter.governorateId}');
      print('🏠 - FilterText: ${searchFilter.filterText}');
      print('🏠 - SkipCount: ${searchFilter.skipCount}');
      print('🏠 - MaxResultCount: ${searchFilter.maxResultCount}');
      print('🏠 Full filter JSON: ${searchFilter.toJson()}');

      print('🏠 Navigating to search results...');

      // Navigate to search results screen
      await Navigator.of(context).pushNamed(
        '/search-results',
        arguments: {'filter': searchFilter},
      );
      
      print('🏠 Navigation completed');
    } catch (e) {
      print('🚨 Error navigating from governorate selection: $e');
      print('🚨 Stack trace: ${StackTrace.current}');
      
      // Fallback navigation with minimal filter
      try {
        await Navigator.of(context).pushNamed(
          '/search-results',
          arguments: {
            'filter': SearchFilter(
              governorateId: governorate.id,
              skipCount: 0,
              maxResultCount: 20,
            )
          },
        );
        print('🏠 Fallback navigation completed');
      } catch (fallbackError) {
        print('🚨 Fallback navigation also failed: $fallbackError');
      }
    }
  }
}
