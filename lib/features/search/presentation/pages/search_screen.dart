import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import '../../data/models/search_filter.dart';
import 'search_results_screen.dart';
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
          'Search Properties',
          style: AppTextStyles.h4.copyWith(color: AppColors.textPrimary),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLocationField(),
                SizedBox(height: 16.h),
                _buildDateSection(),
                SizedBox(height: 16.h),
                _buildGuestsSection(),
                SizedBox(height: 32.h),
                _buildSearchButton(),
                SizedBox(height: 24.h),
                if (state is LookupsLoaded && state.recentSearches.isNotEmpty)
                  _buildRecentSearches(state.recentSearches),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLocationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Where are you going?',
          style: AppTextStyles.h5.copyWith(color: AppColors.textPrimary),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: _locationController,
          decoration: InputDecoration(
            hintText: 'Enter destination',
            prefixIcon: const Icon(Icons.location_on, color: AppColors.primary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'When are you traveling?',
          style: AppTextStyles.h5.copyWith(color: AppColors.textPrimary),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(child: _buildDateField('Check-in', _checkIn, true)),
            SizedBox(width: 12.w),
            Expanded(child: _buildDateField('Check-out', _checkOut, false)),
          ],
        ),
      ],
    );
  }

  Widget _buildDateField(String label, DateTime? date, bool isCheckIn) {
    return GestureDetector(
      onTap: () => _selectDate(isCheckIn),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(color: Colors.grey[600]),
            ),
            SizedBox(height: 4.h),
            Text(
              date != null
                  ? '${date.day}/${date.month}/${date.year}'
                  : 'Select date',
              style: AppTextStyles.bodyMedium.copyWith(
                color: date != null ? AppColors.textPrimary : Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How many guests?',
          style: AppTextStyles.h5.copyWith(color: AppColors.textPrimary),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$_guests guests',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: _guests > 1 ? () => setState(() => _guests--) : null,
                    icon: const Icon(Icons.remove_circle_outline),
                    color: _guests > 1 ? AppColors.primary : Colors.grey[400],
                  ),
                  IconButton(
                    onPressed: () => setState(() => _guests++),
                    icon: const Icon(Icons.add_circle_outline),
                    color: AppColors.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchButton() {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        onPressed: _onSearchButtonPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text(
          'Search Properties',
          style: AppTextStyles.h5.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildRecentSearches(List<RecentSearch> recentSearches) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Searches',
          style: AppTextStyles.h5.copyWith(color: AppColors.textPrimary),
        ),
        SizedBox(height: 12.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recentSearches.length,
          itemBuilder: (context, index) {
            final search = recentSearches[index];
            return Card(
              margin: EdgeInsets.only(bottom: 8.h),
              child: ListTile(
                leading: const Icon(Icons.history, color: AppColors.primary),
                title: Text(
                  search.location ?? 'Any location',
                  style: AppTextStyles.bodyMedium,
                ),
                subtitle: Text(
                  '${search.guests ?? 1} guests • ${search.checkIn != null ? "${search.checkIn!.day}/${search.checkIn!.month}" : "Anytime"}',
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.grey[600]),
                ),
                onTap: () => _useRecentSearch(search),
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

  void _useRecentSearch(RecentSearch search) {
    setState(() {
      _locationController.text = search.location ?? '';
      _checkIn = search.checkIn;
      _checkOut = search.checkOut;
      _guests = search.guests ?? 1;
    });
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
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: context.read<SearchBloc>()..add(SearchPropertiesEvent(filter: filter)),
          child: const SearchResultsScreen(),
        ),
      ),
    );
  }
}
