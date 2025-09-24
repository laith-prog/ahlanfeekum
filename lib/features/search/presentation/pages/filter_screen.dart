import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import '../../data/models/search_filter.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';

enum PropertyType { houses, hotels, motel }

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
          'Filter By',
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
                      _buildPropertyCategorySection(),
                      SizedBox(height: 24.h),
                      _buildDateSection(),
                      SizedBox(height: 24.h),
                      _buildHotelNameSection(),
                      SizedBox(height: 24.h),
                      _buildPriceRangeSection(),
                      SizedBox(height: 24.h),
                      _buildLocationSection(),
                      SizedBox(height: 24.h),
                      _buildRoomsBathroomsSection(),
                      SizedBox(height: 24.h),
                      if (state is LookupsLoaded || state is SearchLoaded)
                        _buildFeaturesSection(state),
                      SizedBox(height: 100.h), // Space for button
                    ],
                  ),
                ),
              ),
              _buildFilterButton(),
            ],
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
          'Choose A Category',
          style: AppTextStyles.h6.copyWith(color: AppColors.textPrimary),
        ),
        SizedBox(height: 16.h),
        Row(
          children: PropertyType.values.take(3).map((type) {
            final isSelected = _selectedCategory == type;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedCategory = type),
                child: Container(
                  margin: EdgeInsets.only(
                    right: type != PropertyType.values.take(3).last ? 12.w : 0,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : Colors.grey[300]!,
                      width: isSelected ? 2.0 : 1.0,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 48.w,
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.grey[100],
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          _getPropertyTypeIcon(type),
                          color: isSelected ? AppColors.primary : Colors.grey[600],
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        _getPropertyTypeLabel(type),
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isSelected ? AppColors.primary : Colors.grey[600],
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildHotelNameSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hotel Name',
          style: AppTextStyles.h6.copyWith(color: AppColors.textPrimary),
        ),
        SizedBox(height: 12.h),
        TextFormField(
          controller: _hotelNameController,
          decoration: InputDecoration(
            hintText: 'Royal Samirames',
            hintStyle: AppTextStyles.inputHint,
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
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Range / Night',
          style: AppTextStyles.h6.copyWith(color: AppColors.textPrimary),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _minPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Start From',
                  hintStyle: AppTextStyles.inputHint,
                  suffixText: '\$',
                  suffixStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
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
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: TextFormField(
                controller: _maxPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'To',
                  hintStyle: AppTextStyles.inputHint,
                  suffixText: '\$',
                  suffixStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
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
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
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
          style: AppTextStyles.h6.copyWith(color: AppColors.textPrimary),
        ),
        SizedBox(height: 12.h),
        TextFormField(
          controller: _locationController,
          decoration: InputDecoration(
            hintText: 'Damascus, Kafr Sosa',
            hintStyle: AppTextStyles.inputHint,
            suffixIcon: Icon(Icons.location_on_outlined, color: AppColors.primary),
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
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            'The Closest',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
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
          'Number Of Rooms',
          style: AppTextStyles.h6.copyWith(color: AppColors.textPrimary),
        ),
        SizedBox(height: 12.h),
        _buildNumberSelector([1, 2, 3], [
          '1 - 3',
          '3 - 6',
          '6-9',
          '9+',
        ], _selectedRooms, (value) => setState(() => _selectedRooms = value)),
        SizedBox(height: 20.h),
        Text(
          'Bathrooms',
          style: AppTextStyles.h6.copyWith(color: AppColors.textPrimary),
        ),
        SizedBox(height: 12.h),
        _buildNumberSelector([1, 2, 3], [
          '1 - 3',
          '3 - 5',
          '+5',
        ], _selectedBathrooms, (value) => setState(() => _selectedBathrooms = value)),
      ],
    );
  }

  Widget _buildNumberSelector(List<int> values, List<String> labels, int selectedValue, Function(int) onChanged) {
    return Wrap(
      spacing: 12.w,
      children: values.asMap().entries.map((entry) {
        final index = entry.key;
        final value = entry.value;
        final isSelected = selectedValue == value;
        final label = index < labels.length ? labels[index] : value.toString();
        
        return GestureDetector(
          onTap: () => onChanged(value),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected) 
                  Container(
                    margin: EdgeInsets.only(right: 6.w),
                    width: 16.w,
                    height: 16.h,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check, color: AppColors.primary, size: 12.sp),
                  ),
                Text(
                  label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }


  Widget _buildFeaturesSection(dynamic state) {
    // Mock features for the design - in real app this would come from state
    final mockFeatures = [
      {'id': '1', 'name': 'Solar Energy'},
      {'id': '2', 'name': 'WIFI'},
      {'id': '3', 'name': 'Kitchen'},
      {'id': '4', 'name': 'Amber'},
      {'id': '5', 'name': 'Hot Water'},
      {'id': '6', 'name': 'Garden'},
      {'id': '7', 'name': 'Balcony'},
      {'id': '8', 'name': 'BBQ Grill'},
      {'id': '9', 'name': 'Refrigerator'},
      {'id': '10', 'name': 'Oven'},
      {'id': '11', 'name': 'TV'},
      {'id': '12', 'name': 'Washing Machine'},
      {'id': '13', 'name': 'AC'},
      {'id': '14', 'name': 'Parking'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'More Features',
          style: AppTextStyles.h6.copyWith(color: AppColors.textPrimary),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: mockFeatures.map<Widget>((feature) {
            final featureId = feature['id']!;
            final featureName = feature['name']!;
            final isSelected = _selectedFeatures.contains(featureId);
            
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedFeatures.remove(featureId);
                  } else {
                    _selectedFeatures.add(featureId);
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected) 
                      Container(
                        margin: EdgeInsets.only(right: 6.w),
                        width: 14.w,
                        height: 14.h,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.check, color: AppColors.primary, size: 10.sp),
                      ),
                    Text(
                      featureName,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFilterButton() {
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
            elevation: 0,
          ),
          child: Text(
            'Filter (23 Result)',
            style: AppTextStyles.buttonText.copyWith(color: Colors.white),
          ),
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


  String _getPropertyTypeLabel(PropertyType type) {
    switch (type) {
      case PropertyType.houses:
        return 'Houses';
      case PropertyType.hotels:
        return 'Hotels';
      case PropertyType.motel:
        return 'Motel';
    }
  }

  IconData _getPropertyTypeIcon(PropertyType type) {
    switch (type) {
      case PropertyType.houses:
        return Icons.home_outlined;
      case PropertyType.hotels:
        return Icons.hotel_outlined;
      case PropertyType.motel:
        return Icons.apartment_outlined;
    }
  }

  String? _getPropertyTypeId(PropertyType type) {
    switch (type) {
      case PropertyType.houses:
        return '3';
      case PropertyType.hotels:
        return '1';
      case PropertyType.motel:
        return '2';
    }
  }
}

