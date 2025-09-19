import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import '../../domain/entities/search_entities.dart';
import 'filter_screen.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load initial search data if not already loaded
    final bloc = context.read<SearchBloc>();
    if (bloc.state is! SearchLoaded && bloc.state is! SearchLoading) {
      bloc.add(const LoadLookupsEvent());
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Results',
          style: AppTextStyles.h4.copyWith(color: AppColors.textPrimary),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SearchError) {
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
                    onPressed: () => context.read<SearchBloc>().add(const LoadLookupsEvent()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is SearchLoaded) {
            return Column(
              children: [
                _buildSearchHeader(state),
                _buildFilterBar(state),
                Expanded(
                  child: state.properties.isEmpty
                      ? _buildEmptyState()
                      : _buildPropertyGrid(state.properties),
                ),
              ],
            );
          }

          if (state is LookupsLoaded) {
            return const Center(
              child: Text('Start searching to see results'),
            );
          }

          return const Center(
            child: Text('Loading...'),
          );
        },
      ),
    );
  }

  Widget _buildSearchHeader(SearchLoaded state) {
    return Container(
      padding: EdgeInsets.all(16.w),
      color: Colors.grey[50],
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search properties...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                height: 44.h,
                width: 44.h,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(22.r),
                ),
                child: IconButton(
                  onPressed: () => _openFilterScreen(state),
                  icon: const Icon(Icons.tune, color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${state.properties.length} properties found',
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[600]),
              ),
              Row(
                children: [
                  Text(
                    'Sort by',
                    style: AppTextStyles.bodySmall.copyWith(color: Colors.grey[600]),
                  ),
                  SizedBox(width: 4.w),
                  DropdownButton<String>(
                    value: 'Price',
                    underline: const SizedBox(),
                    items: ['Price', 'Rating', 'Distance'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: AppTextStyles.bodySmall),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      // TODO: Implement sorting
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(SearchLoaded state) {
    return Container(
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip('All Properties', true),
          SizedBox(width: 8.w),
          _buildFilterChip('Hotels', false),
          SizedBox(width: 8.w),
          _buildFilterChip('Apartments', false),
          SizedBox(width: 8.w),
          _buildFilterChip('Houses', false),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          color: isSelected ? Colors.white : Colors.grey[600],
        ),
      ),
      selected: isSelected,
      onSelected: (bool value) {
        // TODO: Implement filter selection
      },
      backgroundColor: Colors.grey[200],
      selectedColor: AppColors.primary,
    );
  }

  Widget _buildPropertyGrid(List<PropertyEntity> properties) {
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.75,
      ),
      itemCount: properties.length,
      itemBuilder: (context, index) {
        final property = properties[index];
        return _buildPropertyCard(property);
      },
    );
  }

  Widget _buildPropertyCard(PropertyEntity property) {
    return Container(
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
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.r),
                      topRight: Radius.circular(12.r),
                    ),
                  ),
                  child: property.images.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.r),
                            topRight: Radius.circular(12.r),
                          ),
                          child: Image.network(
                            property.images.first,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Icon(
                                  Icons.image,
                                  color: Colors.grey[500],
                                  size: 40.sp,
                                ),
                              );
                            },
                          ),
                        )
                      : Center(
                          child: Icon(
                            Icons.image,
                            color: Colors.grey[500],
                            size: 40.sp,
                          ),
                        ),
                ),
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite_border,
                      color: Colors.grey[600],
                      size: 16.sp,
                    ),
                  ),
                ),
                if (property.rating > 0)
                  Positioned(
                    top: 8.h,
                    left: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
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
                            property.rating.toStringAsFixed(1),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white,
                              fontSize: 8.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    property.address?.isNotEmpty == true 
                        ? property.address! 
                        : property.cityName?.isNotEmpty == true 
                            ? property.cityName! 
                            : 'Location not specified',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.grey[600],
                      fontSize: 10.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${property.pricePerNight.toStringAsFixed(0)}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '/night',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.grey[500],
                          fontSize: 9.sp,
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
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64.sp, color: Colors.grey[400]),
          SizedBox(height: 16.h),
          Text(
            'No properties found',
            style: AppTextStyles.h4.copyWith(color: Colors.grey[600]),
          ),
          SizedBox(height: 8.h),
          Text(
            'Try adjusting your search criteria',
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[500]),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Back to Search'),
          ),
        ],
      ),
    );
  }

  void _openFilterScreen(SearchLoaded state) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: context.read<SearchBloc>(),
          child: FilterScreen(currentFilter: state.currentFilter),
        ),
      ),
    );
  }
}
