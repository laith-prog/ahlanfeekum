import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import '../../data/models/search_filter.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _locationController = TextEditingController();
  DateTime? _checkIn;
  DateTime? _checkOut;
  int _guests = 1;

  @override
  void initState() {
    super.initState();
    // Don't load lookups automatically - only when needed
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search',
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
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSearchForm(),
                      SizedBox(height: 32.h),
                      if (state is LookupsLoaded && state.recentSearches.isNotEmpty)
                        _buildRecentSearches(state.recentSearches),
                    ],
                  ),
                ),
              ),
              _buildSearchButton(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchForm() {
    return Column(
      children: [
        _buildLocationField(),
        SizedBox(height: 16.h),
        _buildDateSection(),
        SizedBox(height: 16.h),
        _buildGuestsField(),
        SizedBox(height: 20.h),
        _buildFilterButton(),
      ],
    );
  }

  Widget _buildLocationField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border.withOpacity(0.3)),
      ),
      child: TextFormField(
        controller: _locationController,
        decoration: InputDecoration(
          hintText: 'Where To?',
          hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          prefixIcon: Icon(
            Icons.location_on_outlined,
            color: AppColors.green,
            size: 20.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        ),
      ),
    );
  }

  Widget _buildDateSection() {
    return Row(
      children: [
        Expanded(
          child: _buildDateField(
            'Check In',
            _checkIn,
            () => _selectDate(true),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildDateField(
            'Check Out',
            _checkOut,
            () => _selectDate(false),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(String label, DateTime? date, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.inputBackground,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.border.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              color: AppColors.green,
              size: 18.sp,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    date != null
                        ? '${date.day}/${date.month}/${date.year}'
                        : '1/Sep/2024',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestsField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border.withOpacity(0.3)),
      ),
      child: TextFormField(
        readOnly: true,
        decoration: InputDecoration(
          hintText: '$_guests Guest${_guests > 1 ? 's' : ''}',
          hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
          prefixIcon: Icon(
            Icons.person_outline,
            color: AppColors.green,
            size: 20.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        ),
        onTap: () => _showGuestSelector(),
      ),
    );
  }

  Widget _buildFilterButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: _openFilterScreen,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.tune,
                color: AppColors.textSecondary,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Filter',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52.h,
        child: ElevatedButton(
          onPressed: _onSearchButtonPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search, color: Colors.white, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                'Search',
                style: AppTextStyles.buttonText.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentSearches(List<RecentSearch> recentSearches) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Search',
          style: AppTextStyles.h4.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16.h),
        ...recentSearches.take(3).map((search) => _buildRecentSearchItem(search)).toList(),
      ],
    );
  }

  Widget _buildRecentSearchItem(RecentSearch search) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Icon(
            Icons.history,
            color: AppColors.textSecondary,
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatRecentSearchTitle(search),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _formatRecentSearchSubtitle(search),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _removeRecentSearch(search),
            child: Icon(
              Icons.close,
              color: AppColors.primary,
              size: 18.sp,
            ),
          ),
        ],
      ),
    );
  }

  String _formatRecentSearchTitle(RecentSearch search) {
    if (search.location != null && search.location!.isNotEmpty) {
      return search.location!;
    }
    return 'Search';
  }

  String _formatRecentSearchSubtitle(RecentSearch search) {
    List<String> parts = [];
    
    if (search.checkIn != null && search.checkOut != null) {
      final checkInStr = '${search.checkIn!.day}/${search.checkIn!.month}/${search.checkIn!.year}';
      final checkOutStr = '${search.checkOut!.day}/${search.checkOut!.month}/${search.checkOut!.year}';
      parts.add('$checkInStr - $checkOutStr');
    }
    
    if (search.guests != null && search.guests! > 0) {
      parts.add('${search.guests} Guest${search.guests! > 1 ? 's' : ''}');
    }
    
    return parts.join(', ');
  }

  Future<void> _selectDate(bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn ? _checkIn ?? DateTime.now() : _checkOut ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkIn = picked;
          // Adjust check-out if it's before check-in
          if (_checkOut != null && _checkOut!.isBefore(picked)) {
            _checkOut = picked.add(const Duration(days: 1));
          }
        } else {
          _checkOut = picked;
        }
      });
    }
  }

  Future<void> _showGuestSelector() async {
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
              'Guests',
              style: AppTextStyles.h4.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Number of Guests',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (_guests > 1) {
                          setState(() => _guests = _guests - 1);
                        }
                      },
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: _guests > 1 ? AppColors.primary : AppColors.border,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.remove,
                          color: _guests > 1 ? Colors.white : AppColors.textSecondary,
                          size: 20.sp,
                        ),
                      ),
                    ),
                    Container(
                      width: 60.w,
                      child: Text(
                        '$_guests',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.h4.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_guests < 10) {
                          setState(() => _guests = _guests + 1);
                        }
                      },
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: _guests < 10 ? AppColors.primary : AppColors.border,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.add,
                          color: _guests < 10 ? Colors.white : AppColors.textSecondary,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  void _openFilterScreen() async {
    print('🔧 _openFilterScreen called');
    
    if (!mounted) {
      print('🔧 Widget not mounted, returning');
      return;
    }
    
    try {
      final bloc = context.read<SearchBloc>();
      print('🔧 SearchBloc obtained, isClosed: ${bloc.isClosed}');
      
      if (bloc.isClosed) {
        print('🔧 BLoC is closed, returning');
        return;
      }
      
      final currentState = bloc.state;
      print('🔧 Current BLoC state: ${currentState.runtimeType}');
      
      SearchFilter currentFilter = const SearchFilter();
      
      // Extract current filter from state
      if (currentState is LookupsLoaded) {
        currentFilter = currentState.currentFilter;
        print('🔧 Using filter from LookupsLoaded state');
      } else if (currentState is SearchLoaded) {
        currentFilter = currentState.currentFilter;
        print('🔧 Using filter from SearchLoaded state');
      } else {
        print('🔧 Using default filter');
      }
      
      print('🔧 Navigating to filter screen with filter: ${currentFilter.toJson()}');
      
      // Navigate immediately
      if (mounted) {
        await Navigator.of(context).pushNamed(
          '/filter',
          arguments: {'filter': currentFilter},
        );
        print('🔧 Navigation completed successfully');
      }
    } catch (e) {
      print('🚨 Error opening filter screen: $e');
      print('🚨 Stack trace: ${StackTrace.current}');
      
      // Fallback: navigate with default filter
      if (mounted) {
        try {
          await Navigator.of(context).pushNamed(
            '/filter',
            arguments: {'filter': const SearchFilter()},
          );
          print('🔧 Fallback navigation completed');
        } catch (fallbackError) {
          print('🚨 Fallback navigation also failed: $fallbackError');
        }
      }
    }
  }

  void _removeRecentSearch(RecentSearch search) {
    // TODO: Implement remove recent search functionality
    // This would require adding a new event to the bloc
  }

  void _onSearchButtonPressed() {
    // Save to recent searches
    final recentSearch = RecentSearch(
      location: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
      checkIn: _checkIn,
      checkOut: _checkOut,
      guests: _guests,
      timestamp: DateTime.now(),
    );
    
    context.read<SearchBloc>().add(SaveRecentSearchEvent(
      location: recentSearch.location,
      checkIn: recentSearch.checkIn,
      checkOut: recentSearch.checkOut,
      guests: recentSearch.guests,
    ));

    // Create search filter and navigate to results
    final filter = SearchFilter(
      filterText: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
      address: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
      checkInDate: _checkIn?.millisecondsSinceEpoch,
      checkOutDate: _checkOut?.millisecondsSinceEpoch,
      maximumNumberOfGuestMin: _guests,
      maximumNumberOfGuestMax: _guests + 2,
      pricePerNightMin: 50, // Default minimum price
      pricePerNightMax: 1000, // Default maximum price
    );
    
    print('🔍 Navigating to search results with filter: ${filter.toJson()}');
    Navigator.of(context).pushNamed(
      '/search-results',
      arguments: {'filter': filter},
    );
  }
}