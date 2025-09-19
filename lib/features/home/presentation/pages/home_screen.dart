import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../../domain/entities/home_entities.dart';
import '../../../search/presentation/pages/search_screen.dart';
import '../../../search/presentation/bloc/search_bloc.dart';
import '../../../../core/di/injection.dart';

import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          final shouldExit = await _showExitDialog(context);
          if (shouldExit) {
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        appBar: null,
        body: BlocProvider(
          create: (context) => HomeBloc(homeRepository: getIt())
            ..add(const LoadHomeDataEvent()),
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is HomeError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64.sp, color: Colors.grey[400]),
                      SizedBox(height: 16.h),
                      Text(
                        'Something went wrong',
                        style: AppTextStyles.h4.copyWith(color: Colors.grey[600]),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        state.message,
                        style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[500]),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        onPressed: () => context.read<HomeBloc>().add(const LoadHomeDataEvent()),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (state is HomeLoaded) {
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<HomeBloc>().add(const RefreshHomeDataEvent());
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        // Header with profile and search
                        _buildHeader(),

                        // Special Advertisement Banner
                        _buildSpecialAdvertisementBanner(state.homeData.specialAdvertisements),

                        // Special Stays Section
                        _buildSpecialStaysSection(state.homeData.siteProperties),

                        // Highly Rated Properties
                        _buildHighlyRatedProperties(state.homeData.highlyRatedProperties),

                        // Discover Section
                        _buildDiscoverSection(state.homeData.governorates),

                        // Hotels of the Week
                        _buildHotelsOfTheWeek(),

                        // Only For You Section
                        _buildOnlyForYouSection(state.homeData.onlyForYouSection),
                      ],
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Are you sure you want to exit the app?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  // Exit the app
                  SystemNavigator.pop();
                },
                child: const Text('Exit'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Widget _buildHeader() {
    return Builder(
      builder: (context) {
        return Container(
          padding: EdgeInsets.fromLTRB(16.w, 50.h, 16.w, 16.h),
          child: Column(
            children: [
              // Top row with logo and profile
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // App Logo
                  Container(
                    width: 120.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.home, color: AppColors.primary, size: 20.sp),
                        SizedBox(width: 4.w),
                        Text(
                          'AhlanFeekum',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Profile Picture
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 2.w),
                    ),
                    child: CircleAvatar(
                      radius: 18.r,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: const NetworkImage(
                        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face',
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              // Search Bar
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (buildContext) => BlocProvider(
                        create: (context) => getIt<SearchBloc>(),
                        child: const SearchScreen(),
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25.r),
                    border: Border.all(color: Colors.grey[300]!, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey[500], size: 20.sp),
                      SizedBox(width: 12.w),
                      Text(
                        'Destination',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.grey[500],
                          fontSize: 14.sp,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _buildSpecialAdvertisementBanner(List<SpecialAdvertisement> ads) {
    if (ads.isEmpty) return const SizedBox.shrink();

    return _AdvertisementBannerWidget(ads: ads);
  }

  Widget _buildSpecialStaysSection(List<Property> properties) {
    if (properties.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    'Special',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 6.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    'Stays',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(Icons.arrow_forward_ios, color: Colors.grey[600], size: 16.sp),
              ],
            ),
          ),
          SizedBox(height: 4.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              'In AhlanFeekum',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontSize: 14.sp,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          // Two cards side by side
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // First property card
                if (properties.isNotEmpty)
                  _buildSpecialStayCard(properties[0]),
                if (properties.length > 1) ...[
                  SizedBox(width: 12.w),
                  // Second property card
                  _buildSpecialStayCard(properties[1]),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialStayCard(Property property) {
    return Container(
      height: 218.h,
      width: 162.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Stack(
        children: [
          // Main image
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: property.mainImageUrl != null
                ? Image.network(
                    property.mainImageUrl!,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.home,
                          color: Colors.grey[500],
                          size: 40.sp,
                        ),
                      );
                    },
                  )
                : Container(
                    color: Colors.grey[300],
                    width: double.infinity,
                    height: double.infinity,
                    child: Icon(
                      Icons.home,
                      color: Colors.grey[500],
                      size: 40.sp,
                    ),
                  ),
          ),
          // Heart icon
          Positioned(
            top: 12.h,
            right: 12.w,
            child: GestureDetector(
              onTap: () {
                // TODO: Toggle favorite
              },
              child: Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  property.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: property.isFavorite ? AppColors.primary : Colors.grey[600],
                  size: 16.sp,
                ),
              ),
            ),
          ),
          // Property details overlay at bottom
          Positioned(
            left: 12.w,
            right: 12.w,
            bottom: 12.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(
                        offset: const Offset(0, 1),
                        blurRadius: 3,
                        color: Colors.black.withValues(alpha: 0.7),
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                Text(
                  '${property.pricePerNight.toStringAsFixed(0)} \$ / Night',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: const Offset(0, 1),
                        blurRadius: 3,
                        color: Colors.black.withValues(alpha: 0.7),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Gradient overlay for text readability
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 80.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlyRatedProperties(List<Property> properties) {
    if (properties.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.orange, size: 20.sp),
                SizedBox(width: 8.w),
                Text(
                  'Highly Rated Properties',
                  style: AppTextStyles.h4.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 16.sp,
                  ),
                ),
                const Spacer(),
                Icon(Icons.arrow_forward_ios, color: Colors.grey[600], size: 16.sp),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          // Grid of properties (2x2 layout)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: 155 / 251, // Use exact aspect ratio
              ),
              itemCount: properties.length > 4 ? 4 : properties.length, // Show max 4 items
              itemBuilder: (context, index) {
                final property = properties[index];
                return _buildHighlyRatedPropertyCard(property);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlyRatedPropertyCard(Property property) {
    return Container(
      width: 155.w,
      height: 251.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section with fixed dimensions
          Container(
            width: 155.w,
            height: 148.h,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                  child: Container(
                    width: 155.w,
                    height: 148.h,
                    child: property.mainImageUrl != null
                        ? Image.network(
                            property.mainImageUrl!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: Colors.grey[300],
                                child: Icon(
                                  Icons.home,
                                  color: Colors.grey[500],
                                  size: 30.sp,
                                ),
                              );
                            },
                          )
                        : Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Colors.grey[300],
                            child: Icon(
                              Icons.home,
                              color: Colors.grey[500],
                              size: 30.sp,
                            ),
                          ),
                  ),
                ),
                // Heart icon
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: GestureDetector(
                    onTap: () {
                      // TODO: Toggle favorite
                    },
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        property.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: property.isFavorite ? AppColors.primary : Colors.grey[600],
                        size: 14.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Property details section - remaining height (251 - 148 = 103)
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating badge at the top
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: Colors.white, size: 10.sp),
                        SizedBox(width: 2.w),
                        Text(
                          '4.8', // Static rating since not provided by backend
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    property.title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  // Property type row (using static data since not available from backend)
                  Row(
                    children: [
                      Icon(Icons.home_outlined, color: Colors.grey[500], size: 12.sp),
                      SizedBox(width: 4.w),
                      Text(
                        property.hotelName?.isNotEmpty == true ? 'Hotel' : 'Apartment',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.grey[600],
                          fontSize: 10.sp,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(Icons.straighten, color: Colors.grey[500], size: 12.sp),
                      SizedBox(width: 2.w),
                      Text(
                        '140 M', // Static distance since not available from backend
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.grey[600],
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    '${property.pricePerNight.toStringAsFixed(0)} \$ / Night',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscoverSection(List<Governorate> governorates) {
    if (governorates.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.explore, color: Colors.orange, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                'Discover Your Ideal Stay',
                style: AppTextStyles.h4.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 16.sp,
                ),
              ),
              const Spacer(),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[600], size: 16.sp),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 120.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: governorates.length,
              itemBuilder: (context, index) {
                final governorate = governorates[index];
                return Container(
                  width: 120.w,
                  margin: EdgeInsets.only(right: 12.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Image.network(
                          _getLocationImageUrl(governorate.title),
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primary.withValues(alpha: 0.8),
                                    AppColors.primary.withValues(alpha: 0.6),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.location_city,
                                  color: Colors.white,
                                  size: 40.sp,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // Gradient overlay for text readability
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withValues(alpha: 0.5),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 12.h,
                        left: 12.w,
                        right: 12.w,
                        child: Text(
                          governorate.title,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
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

  Widget _buildHotelsOfTheWeek() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(Icons.hotel, color: Colors.orange[600], size: 16.sp),
              ),
              SizedBox(width: 8.w),
              Text(
                'Hotels Of The Week',
                style: AppTextStyles.h4.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 16.sp,
                ),
              ),
              const Spacer(),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[600], size: 16.sp),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildHostProfile(
                imageUrl: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
                name: 'Sara Mialli',
                rating: 4.9,
              ),
              _buildHostProfile(
                imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
                name: 'Ahmad Refai',
                rating: 4.8,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHostProfile({
    required String imageUrl,
    required String name,
    required double rating,
  }) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.2),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 28.r,
            backgroundColor: Colors.grey[200],
            backgroundImage: NetworkImage(imageUrl),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          name,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star, color: Colors.amber, size: 12.sp),
            SizedBox(width: 2.w),
            Text(
              rating.toString(),
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.grey[600],
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOnlyForYouSection(OnlyForYouSection onlyForYou) {
    return Container(
      margin: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(Icons.person, color: AppColors.primary, size: 16.sp),
              ),
              SizedBox(width: 8.w),
              Text(
                'Only For You',
                style: AppTextStyles.h4.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(width: 4.w),
              Icon(Icons.favorite, color: AppColors.primary, size: 16.sp),
              const Spacer(),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[600], size: 16.sp),
            ],
          ),
          SizedBox(height: 16.h),
          Column(
            children: [
              // First large card
              Container(
                width: double.infinity,
                height: 120.h,
                margin: EdgeInsets.only(bottom: 8.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  gradient: LinearGradient(
                    colors: [Colors.green[300]!, Colors.green[600]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.network(
                        onlyForYou.firstPhotoUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              gradient: LinearGradient(
                                colors: [Colors.green[300]!, Colors.green[600]!],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 12.h,
                      left: 12.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Only For You',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Exclusive Content',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Bottom row with two cards
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 120.h,
                      margin: EdgeInsets.only(right: 4.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: Colors.grey[400],
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: Image.network(
                              onlyForYou.secondPhotoUrl,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[400],
                                );
                              },
                            ),
                          ),
                          Positioned(
                            bottom: 12.h,
                            left: 12.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Special Offer',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Limited Time',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontSize: 9.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Container(
                      height: 120.h,
                      margin: EdgeInsets.only(left: 4.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: Colors.orange[300],
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: Image.network(
                              onlyForYou.thirdPhotoUrl,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.r),
                                    color: Colors.orange[300],
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.star, color: Colors.white, size: 40),
                                  ),
                                );
                              },
                            ),
                          ),
                          Positioned(
                            bottom: 12.h,
                            left: 12.w,
                            right: 12.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Premium Experience',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'VIP Access',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontSize: 9.sp,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 8.h,
                            right: 8.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: Colors.orange[600],
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                'VIP',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Colors.white,
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getLocationImageUrl(String locationName) {
    // Map of Syrian cities to appropriate Unsplash images
    const locationImages = {
      'Damascus': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=300&fit=crop',
      'Daraa': 'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=400&h=300&fit=crop',
      'Latakia': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=300&fit=crop',
      'Aleppo': 'https://images.unsplash.com/photo-1573047733774-3b2d3c3b3d0f?w=400&h=300&fit=crop',
      'Homs': 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400&h=300&fit=crop',
    };

    return locationImages[locationName] ??
           'https://images.unsplash.com/photo-1477959858617-67f85cf4f1df?w=400&h=300&fit=crop';
  }
}

class _AdvertisementBannerWidget extends StatefulWidget {
  final List<SpecialAdvertisement> ads;

  const _AdvertisementBannerWidget({required this.ads});

  @override
  State<_AdvertisementBannerWidget> createState() => _AdvertisementBannerWidgetState();
}

class _AdvertisementBannerWidgetState extends State<_AdvertisementBannerWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          Container(
            height: 140.h,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: widget.ads.length,
              itemBuilder: (context, index) {
                final ad = widget.ads[index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    image: ad.imageUrl.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(ad.imageUrl),
                            fit: BoxFit.cover,
                          )
                        : null,
                    gradient: ad.imageUrl.isEmpty
                        ? LinearGradient(
                            colors: [Colors.orange[400]!, Colors.orange[600]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                  ),
                  child: Stack(
                    children: [
                      // Overlay for better text readability
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withValues(alpha: 0.4),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16.w,
                        top: 16.h,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            'Special Advertisement Goes Here',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16.w,
                        bottom: 16.h,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ad.propertyTitle.isNotEmpty ? ad.propertyTitle : 'Featured Property',
                              style: AppTextStyles.h3.copyWith(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Discover amazing deals',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 12.h),
          // Page indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.ads.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 3.w),
                height: 6.h,
                width: _currentPage == index ? 24.w : 6.w,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? AppColors.primary
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(3.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
