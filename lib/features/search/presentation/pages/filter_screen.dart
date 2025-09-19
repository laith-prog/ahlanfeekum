import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import '../../data/models/search_filter.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';

enum PropertyType { hotels, apartments, houses }

class FilterScreen extends StatefulWidget {
  final SearchFilter currentFilter;

  const FilterScreen({
    super.key,
    required this.currentFilter,
  });

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final TextEditingController _hotelNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  
  PropertyType _selectedCategory = PropertyType.houses;
  int _selectedRooms = 1;
  int _selectedBathrooms = 1;
  final List<String> _selectedFeatures = [];
  DateTime? _checkIn;
  DateTime? _checkOut;

  @override
  void initState() {
    super.initState();
    _initializeFromCurrentFilter();
  }

  void _initializeFromCurrentFilter() {
    final filter = widget.currentFilter;
    
    _hotelNameController.text = filter.hotelName ?? '';
    _locationController.text = filter.address ?? '';
    _minPriceController.text = filter.pricePerNightMin?.toString() ?? '';
    _maxPriceController.text = filter.pricePerNightMax?.toString() ?? '';
    
    if (filter.checkInDate != null) {
      _checkIn = DateTime.fromMillisecondsSinceEpoch(filter.checkInDate!);
    }
    if (filter.checkOutDate != null) {
      _checkOut = DateTime.fromMillisecondsSinceEpoch(filter.checkOutDate!);
    }
    
    if (filter.bathroomsMin != null) {
      _selectedBathrooms = filter.bathroomsMin!;
    }
    if (filter.livingroomsMin != null) {
      _selectedRooms = filter.livingroomsMin!;
    }
    
    if (filter.selectedFeatures != null) {
      _selectedFeatures.addAll(filter.selectedFeatures!);
    }
  }

  @override
  void dispose() {
    _hotelNameController.dispose();
    _locationController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Filter Properties',
          style: AppTextStyles.h4.copyWith(color: AppColors.textPrimary),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          TextButton(
            onPressed: _clearAllFilters,
            child: Text(
              'Clear All',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPropertyCategorySection(),
                SizedBox(height: 24.h),
                _buildPriceRangeSection(),
                SizedBox(height: 24.h),
                _buildLocationSection(),
                SizedBox(height: 24.h),
                _buildDateSection(),
                SizedBox(height: 24.h),
                _buildRoomsBathroomsSection(),
                SizedBox(height: 24.h),
                if (state is LookupsLoaded || state is SearchLoaded)
                  _buildFeaturesSection(state),
                SizedBox(height: 32.h),
                _buildFilterButton(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPropertyCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Property Category',
          style: AppTextStyles.h5.copyWith(color: AppColors.textPrimary),
        ),
        SizedBox(height: 12.h),
        Row(
          children: PropertyType.values.map((type) {
            final isSelected = _selectedCategory == type;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedCategory = type),
                child: Container(
                  margin: EdgeInsets.only(
                    right: type != PropertyType.values.last ? 8.w : 0,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : Colors.grey[300]!,
                    ),
                  ),
                  child: Text(
                    _getPropertyTypeLabel(type),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isSelected ? Colors.white : Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPriceRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Range (per night)',
          style: AppTextStyles.h5.copyWith(color: AppColors.textPrimary),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _minPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Min Price',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Text('-', style: AppTextStyles.bodyMedium),
            SizedBox(width: 12.w),
            Expanded(
              child: TextFormField(
                controller: _maxPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Max Price',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: AppTextStyles.h5.copyWith(color: AppColors.textPrimary),
        ),
        SizedBox(height: 12.h),
        TextFormField(
          controller: _locationController,
          decoration: InputDecoration(
            labelText: 'Location',
            hintText: 'Enter city or area',
            prefixIcon: const Icon(Icons.location_on),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        TextFormField(
          controller: _hotelNameController,
          decoration: InputDecoration(
            labelText: 'Hotel Name (Optional)',
            hintText: 'Enter hotel name',
            prefixIcon: const Icon(Icons.hotel),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
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
          'Check-in & Check-out',
          style: AppTextStyles.h5.copyWith(color: AppColors.textPrimary),
        ),
        SizedBox(height: 12.h),
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

  Widget _buildRoomsBathroomsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rooms & Bathrooms',
          style: AppTextStyles.h5.copyWith(color: AppColors.textPrimary),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildCounterSection('Rooms', _selectedRooms, (value) {
                setState(() => _selectedRooms = value);
              }),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _buildCounterSection('Bathrooms', _selectedBathrooms, (value) {
                setState(() => _selectedBathrooms = value);
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCounterSection(String label, int value, Function(int) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[600]),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: value > 1 ? () => onChanged(value - 1) : null,
                icon: const Icon(Icons.remove),
                color: value > 1 ? AppColors.primary : Colors.grey[400],
              ),
              Text(
                value.toString(),
                style: AppTextStyles.h5.copyWith(color: AppColors.textPrimary),
              ),
              IconButton(
                onPressed: () => onChanged(value + 1),
                icon: const Icon(Icons.add),
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesSection(dynamic state) {
    final features = state is LookupsLoaded 
        ? state.propertyFeatures 
        : state is SearchLoaded 
            ? state.propertyFeatures 
            : <dynamic>[];

    if (features.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Property Features',
          style: AppTextStyles.h5.copyWith(color: AppColors.textPrimary),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: features.map<Widget>((feature) {
            final featureId = feature.id;
            final featureName = feature.displayName;
            final isSelected = _selectedFeatures.contains(featureId);
            
            return FilterChip(
              label: Text(
                featureName,
                style: AppTextStyles.bodySmall.copyWith(
                  color: isSelected ? Colors.white : Colors.grey[600],
                ),
              ),
              selected: isSelected,
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    _selectedFeatures.add(featureId);
                  } else {
                    _selectedFeatures.remove(featureId);
                  }
                });
              },
              backgroundColor: Colors.grey[200],
              selectedColor: AppColors.primary,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFilterButton() {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        onPressed: () {
          // Apply filters and navigate back
          final filter = SearchFilter(
            propertyTypeId: _getPropertyTypeId(_selectedCategory),
            checkInDate: _checkIn?.millisecondsSinceEpoch,
            checkOutDate: _checkOut?.millisecondsSinceEpoch,
            pricePerNightMin: double.tryParse(_minPriceController.text),
            pricePerNightMax: double.tryParse(_maxPriceController.text),
            address: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
            hotelName: _hotelNameController.text.trim().isEmpty ? null : _hotelNameController.text.trim(),
            bathroomsMin: _selectedBathrooms,
            bathroomsMax: _selectedBathrooms + 1,
            livingroomsMin: _selectedRooms,
            livingroomsMax: _selectedRooms + 2,
            selectedFeatures: _selectedFeatures.isEmpty ? null : _selectedFeatures,
          );

          // Update filter and trigger search
          context.read<SearchBloc>().add(UpdateFilterEvent(filter: filter));
          context.read<SearchBloc>().add(SearchPropertiesEvent(filter: filter));
          Navigator.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text(
          'Apply Filters',
          style: AppTextStyles.h5.copyWith(color: Colors.white),
        ),
      ),
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
          if (_checkOut != null && _checkOut!.isBefore(picked)) {
            _checkOut = picked.add(const Duration(days: 1));
          }
        } else {
          _checkOut = picked;
        }
      });
    }
  }

  void _clearAllFilters() {
    setState(() {
      _hotelNameController.clear();
      _locationController.clear();
      _minPriceController.clear();
      _maxPriceController.clear();
      _selectedCategory = PropertyType.houses;
      _selectedRooms = 1;
      _selectedBathrooms = 1;
      _selectedFeatures.clear();
      _checkIn = null;
      _checkOut = null;
    });
  }

  String _getPropertyTypeLabel(PropertyType type) {
    switch (type) {
      case PropertyType.hotels:
        return 'Hotels';
      case PropertyType.apartments:
        return 'Apartments';
      case PropertyType.houses:
        return 'Houses';
    }
  }

  String? _getPropertyTypeId(PropertyType type) {
    switch (type) {
      case PropertyType.hotels:
        return '1';
      case PropertyType.apartments:
        return '2';
      case PropertyType.houses:
        return '3';
    }
  }
}
