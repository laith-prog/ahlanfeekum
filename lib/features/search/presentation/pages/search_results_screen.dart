import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import '../../domain/entities/search_entities.dart';
import '../../data/models/search_filter.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSort = 'Lowest Price';
  final ScrollController _scrollController = ScrollController();
  SearchFilter? _currentFilter;

  @override
  void initState() {
    super.initState();
    print(
      '🔍 SearchResultsScreen initState - Current bloc state: ${context.read<SearchBloc>().state.runtimeType}',
    );

    // Set up pagination scroll listener
    _scrollController.addListener(_onScroll);

    // Get filter from route arguments and trigger search directly
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      print('🔍 Route arguments: $args');

      final filter = args != null && args['filter'] != null
          ? args['filter'] as SearchFilter
          : const SearchFilter(); // Use default filter if none provided

      _currentFilter = filter;
      print('🔍 Using filter: ${filter.toJson()}');
      print('🔍 Triggering search properties directly...');

      // Always trigger search directly, no need for lookups
      context.read<SearchBloc>().add(SearchPropertiesEvent(filter: filter));
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Result',
          style: AppTextStyles.h4.copyWith(color: AppColors.textPrimary),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
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
                  Icon(
                    Icons.error_outline,
                    size: 64.sp,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Something went wrong',
                    style: AppTextStyles.h4.copyWith(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    state.message,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () => context.read<SearchBloc>().add(
                      const LoadLookupsEvent(),
                    ),
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
                Expanded(
                  child: state.properties.isEmpty
                      ? _buildEmptyState()
                      : _buildPropertyGrid(state.properties),
                ),
              ],
            );
          }

          if (state is LookupsLoaded) {
            return const Center(child: Text('Start searching to see results'));
          }

          return const Center(child: Text('Loading...'));
        },
      ),
    );
  }

  Widget _buildSearchHeader(SearchLoaded state) {
    return Container(
      padding: EdgeInsets.all(20.w),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.inputBackground,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.border.withOpacity(0.3)),
                  ),
                  child: TextFormField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search Something',
                      hintStyle: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.textSecondary,
                        size: 20.sp,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              GestureDetector(
                onTap: () async {
                  print('🔧 Filter button tapped from search results');
                  
                  if (!mounted) {
                    print('🔧 Widget not mounted');
                    return;
                  }
                  
                  try {
                    print('🔧 Navigating to filter with filter: ${state.currentFilter.toJson()}');
                    
                    await Navigator.of(context).pushNamed(
                      '/filter',
                      arguments: {'filter': state.currentFilter},
                    );
                    
                    print('🔧 Filter navigation completed');
                  } catch (e) {
                    print('🚨 Error navigating to filter: $e');
                    print('🚨 Stack trace: ${StackTrace.current}');
                    
                    // Fallback navigation
                    if (mounted) {
                      try {
                        await Navigator.of(context).pushNamed(
                          '/filter',
                          arguments: {'filter': const SearchFilter()},
                        );
                        print('🔧 Fallback filter navigation completed');
                      } catch (fallbackError) {
                        print('🚨 Fallback filter navigation failed: $fallbackError');
                      }
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Icon(
                    Icons.tune,
                    color: AppColors.textSecondary,
                    size: 20.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${state.totalCount} Result Founded',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () => _showSortBottomSheet(),
                child: Text(
                  'Sort By',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyGrid(List<PropertyEntity> properties) {
    // Sort properties based on selected sort option
    List<PropertyEntity> sortedProperties = List.from(properties);
    if (_selectedSort == 'Lowest Price') {
      sortedProperties.sort((a, b) => a.pricePerNight.compareTo(b.pricePerNight));
    } else if (_selectedSort == 'Highest Price') {
      sortedProperties.sort((a, b) => b.pricePerNight.compareTo(a.pricePerNight));
    }
    
    return GridView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 160.w,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 160.w / 260.h,
      ),
      itemCount: sortedProperties.length,
      itemBuilder: (context, index) {
        final property = sortedProperties[index];
        return _buildPropertyCard(property);
      },
    );
  }

  Widget _buildPropertyCard(PropertyEntity property) {
    return SizedBox(
      width: 160.w,
      height: 260.h,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fixed height image container
          SizedBox(
            width: 160.w,
            height: 150.h,
            child: Stack(
              children: [
                Container(
                  width: 160.w,
                  height: 150.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: property.mainImage != null 
                        ? Image.network(
                            _buildFullImageUrl(property.mainImage!),
                            width: 160.w,
                            height: 150.h,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/bulding.jpg',
                                width: 160.w,
                                height: 150.h,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 160.w,
                                    height: 120.h,
                                    color: Colors.grey[300],
                                    child: Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey[500],
                                    ),
                                  );
                                },
                              );
                            },
                          )
                        : Image.asset(
                            'assets/images/bulding.jpg',
                            width: 160.w,
                            height: 120.h,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 160.w,
                                height: 120.h,
                                color: Colors.grey[300],
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey[500],
                                ),
                              );
                            },
                          ),
                  ),
                ),
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Icon(
                      Icons.favorite_border,
                      color: AppColors.primary,
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Rating badge between image and title
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: AppColors.warning,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.white,
                          size: 10.sp,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          property.rating != null ? property.rating!.toStringAsFixed(1) : '0.0',
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Title
                  Flexible(
                    child: Text(
                      property.title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Price
                  Row(
                    children: [
                      Text(
                        '\$${property.pricePerNight.toStringAsFixed(0)}',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        ' /Night',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
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
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64.sp,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            'No Results Found',
            style: AppTextStyles.h4.copyWith(color: Colors.grey[600]),
          ),
          SizedBox(height: 8.h),
          Text(
            'Try adjusting your search filters',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Sort By',
              style: AppTextStyles.h4.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 24.h),
            _buildSortOption('Lowest Price'),
            _buildSortOption('Highest Price'),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String option) {
    final isSelected = _selectedSort == option;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSort = option;
        });
        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        child: Row(
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.green : AppColors.border,
                  width: 2,
                ),
                color: isSelected ? AppColors.green : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 12.sp,
                    )
                  : null,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                option,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      // User reached the end of the list, load more
      _loadMoreResults();
    }
  }

  void _loadMoreResults() async {
    if (!mounted) return;
    
    try {
      final bloc = context.read<SearchBloc>();
      if (bloc.isClosed) return;
      
      final state = bloc.state;
      
      if (state is SearchLoaded && !state.hasReachedMax && _currentFilter != null) {
        print('🔍 Loading more results...');
        
        // Create a new filter with updated skip count for pagination
        final nextPageFilter = _currentFilter!.copyWith(
          skipCount: state.properties.length,
        );
        
        // Add event to load more results
        bloc.add(LoadMorePropertiesEvent(filter: nextPageFilter));
      }
    } catch (e) {
      print('Error loading more results: $e');
      // Pagination will stop gracefully
    }
  }

  String _buildFullImageUrl(String relativePath) {
    const baseUrl = 'http://srv954186.hstgr.cloud:5000';
    if (relativePath.startsWith('/')) {
      return '$baseUrl$relativePath';
    }
    return '$baseUrl/$relativePath';
  }
}