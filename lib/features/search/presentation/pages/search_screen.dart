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
    // Load lookups when screen opens
    context.read<SearchBloc>().add(const LoadLookupsEvent());
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
                      _buildSearchCard(),
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

  Widget _buildSearchCard() {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLocationField(),
          SizedBox(height: 20.h),
          _buildDateSection(),
          SizedBox(height: 20.h),
          _buildGuestsSection(),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(child: SizedBox()),
              _buildFilterButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _locationController,
          decoration: InputDecoration(
            labelText: 'Where To?',
            labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            hintText: 'Enter destination',
            hintStyle: AppTextStyles.inputHint,
            prefixIcon: Icon(Icons.location_on_outlined, color: AppColors.primary),
            filled: true,
            fillColor: AppColors.inputBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.primary),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          ),
        ),
      ],
    );
  }

  Widget _buildDateSection() {
    return Row(
      children: [
        Expanded(child: _buildDateField('Check In', _checkIn, true)),
        SizedBox(width: 16.w),
        Expanded(child: _buildDateField('Check Out', _checkOut, false)),
      ],
    );
  }

  Widget _buildDateField(String label, DateTime? date, bool isCheckIn) {
    return GestureDetector(
      onTap: () => _selectDate(isCheckIn),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.inputBackground,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.transparent),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_outlined, color: AppColors.primary, size: 20.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    date != null
                        ? '${date.day}/${date.month}/${date.year}'
                        : '1/Sep/2024',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
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

  Widget _buildGuestsSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.transparent),
      ),
      child: Row(
        children: [
          Icon(Icons.person_outline, color: AppColors.primary, size: 20.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Guests',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
                SizedBox(height: 2.h),
                Text(
                  '$_guests Guests',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: _guests > 1 ? () => setState(() => _guests--) : null,
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: _guests > 1 ? AppColors.primary.withOpacity(0.1) : Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.remove,
                    color: _guests > 1 ? AppColors.primary : Colors.grey[400],
                    size: 16.sp,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: () => setState(() => _guests++),
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    color: AppColors.primary,
                    size: 16.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton() {
    return GestureDetector(
      onTap: _openFilterScreen,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.tune, color: AppColors.textSecondary, size: 20.sp),
            SizedBox(width: 4.w),
            Text(
              'Filter',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
          ],
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
          style: AppTextStyles.h5.copyWith(color: AppColors.textPrimary),
        ),
        SizedBox(height: 16.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recentSearches.length.clamp(0, 3), // Limit to 3 recent searches
          itemBuilder: (context, index) {
            final search = recentSearches[index];
            return Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.border.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.history,
                      color: AppColors.primary,
                      size: 16.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          search.location ?? 'Damascus, Kafr Sosa',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          '${search.checkIn != null ? "Sep ${search.checkIn!.day}" : "Sep 2"} - ${search.checkOut != null ? "Sep ${search.checkOut!.day}" : "Sep 4"}, ${search.guests ?? 2} Guests',
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _removeRecentSearch(index),
                    child: Icon(
                      Icons.close,
                      color: AppColors.error,
                      size: 20.sp,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
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


  void _openFilterScreen() {
    final bloc = context.read<SearchBloc>();
    final currentState = bloc.state;
    
    SearchFilter currentFilter = const SearchFilter();
    
    if (currentState is LookupsLoaded) {
      currentFilter = currentState.currentFilter;
    } else if (currentState is SearchLoaded) {
      currentFilter = currentState.currentFilter;
    }
    
    Navigator.of(context).pushNamed(
      '/filter',
      arguments: {'filter': currentFilter},
    );
  }

  void _removeRecentSearch(int index) {
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
      address: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
      checkInDate: _checkIn?.millisecondsSinceEpoch,
      checkOutDate: _checkOut?.millisecondsSinceEpoch,
    );
    
    Navigator.of(context).pushNamed(
      '/search-results',
      arguments: {'filter': filter},
    );
  }
}
