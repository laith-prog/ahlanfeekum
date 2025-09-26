import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/home_entities.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';

class AdvertisementBannerWidget extends StatefulWidget {
  final List<SpecialAdvertisement> ads;

  const AdvertisementBannerWidget({
    super.key,
    required this.ads,
  });

  @override
  State<AdvertisementBannerWidget> createState() => _AdvertisementBannerWidgetState();
}

class _AdvertisementBannerWidgetState extends State<AdvertisementBannerWidget> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.ads.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 160.h, // Slightly reduced height to match screenshot
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: Stack(
        children: [
          PageView.builder(
        onPageChanged: (i) => setState(() => _currentPage = i),
        itemCount: widget.ads.length,
        itemBuilder: (context, index) {
          final ad = widget.ads[index];
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Stack(
                children: [
                  // Background Image
                  CachedNetworkImage(
                    imageUrl: ad.imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.primary.withOpacity(0.1),
                      child: Center(
                        child: Icon(
                          Icons.image_outlined,
                          color: AppColors.primary,
                          size: 50.sp,
                        ),
                      ),
                    ),
                  ),
                  
                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  
                  // Content
                  Positioned(
                    bottom: 20.h,
                    left: 20.w,
                    right: 20.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          ad.propertyTitle.isNotEmpty ? ad.propertyTitle : 'Special\nAdvertisement Goes\nHere',
                          style: AppTextStyles.h4.copyWith(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
          Positioned(
            bottom: 8.h,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.ads.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  width: _currentPage == i ? 18.w : 6.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: _currentPage == i ? Colors.white : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
