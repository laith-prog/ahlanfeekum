import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import '../../data/models/search_filter.dart';
import '../../domain/entities/search_entities.dart';
import '../../../rent_create/presentation/pages/map_picker_page.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';

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
  
  String? _selectedPropertyTypeId;
  int _selectedRooms = 1;
  int _selectedBathrooms = 1;
  int _selectedBedrooms = 1;
  final List<String> _selectedFeatures = [];
  DateTime? _checkIn;
  DateTime? _checkOut;
  double? _selectedLatitude;
  double? _selectedLongitude;

  @override
  void initState() {
    super.initState();
    print('🔧 FilterScreen initState called');
    print('🔧 Current filter: ${widget.currentFilter.toJson()}');
    
    _initializeFromCurrentFilter();
    
    // Load lookups if needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadLookupsIfNeeded();
    });
  }
  
  void _loadLookupsIfNeeded() async {
    if (!mounted) return;
    
    try {
      final bloc = context.read<SearchBloc>();
      if (bloc.isClosed) return;
      
      final state = bloc.state;
      
      // Load lookups if they're not available
      if (state is SearchInitial ||
          (state is SearchLoaded && state.propertyTypes.isEmpty) ||
          (state is LookupsLoaded && state.propertyTypes.isEmpty)) {
        bloc.add(const LoadLookupsEvent());
      }
    } catch (e) {
      print('Error loading lookups in filter screen: $e');
      // Continue without lookups - UI will show loading states
    }
  }

  void _openMapPicker() async {
    try {
      // Use default location (Damascus, Syria) if no location is selected
      final defaultLat = _selectedLatitude ?? 33.5138;
      final defaultLng = _selectedLongitude ?? 36.2765;
      
      print('🗺️ Opening map picker with coordinates: $defaultLat, $defaultLng');
      
      final result = await Navigator.of(context).push<Map<String, dynamic>>(
        MaterialPageRoute(
          builder: (context) => MapPickerPage(
            initialLat: defaultLat,
            initialLng: defaultLng,
          ),
        ),
      );

      if (result != null && mounted) {
        final lat = result['lat'] as double?;
        final lng = result['lng'] as double?;
        final address = result['address'] as String?;

        if (lat != null && lng != null) {
          setState(() {
            _selectedLatitude = lat;
            _selectedLongitude = lng;
            if (address != null && address.isNotEmpty) {
              _locationController.text = address;
            }
          });
          
          print('🗺️ Location selected: $lat, $lng');
          print('🗺️ Address: $address');
        }
      }
    } catch (e) {
      print('🚨 Error opening map picker: $e');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open map. Please try again.'),
            backgroundColor: AppColors.error,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _initializeFromCurrentFilter() {
    final filter = widget.currentFilter;
    
    _hotelNameController.text = filter.hotelName ?? '';
    _locationController.text = filter.address ?? '';
    _minPriceController.text = filter.pricePerNightMin?.toString() ?? '200';
    _maxPriceController.text = filter.pricePerNightMax?.toString() ?? '450';
    _selectedLatitude = filter.latitude;
    _selectedLongitude = filter.longitude;
    
    _selectedPropertyTypeId = filter.propertyTypeId;
    
    if (filter.checkInDate != null) {
      _checkIn = DateTime.fromMillisecondsSinceEpoch(filter.checkInDate!);
    }
    if (filter.checkOutDate != null) {
      _checkOut = DateTime.fromMillisecondsSinceEpoch(filter.checkOutDate!);
    }
    
    if (filter.bedroomsMin != null) {
      _selectedBedrooms = filter.bedroomsMin!;
    }
    if (filter.bathroomsMin != null) {
      _selectedBathrooms = filter.bathroomsMin!;
    }
    if (filter.livingroomsMin != null) {
      _selectedRooms = filter.livingroomsMin!;
    }
    
    if (filter.selectedFeatures != null) {
      _selectedFeatures.addAll(filter.selectedFeatures!);
    } else {
      // Default selected features to match mockup
      _selectedFeatures.addAll(['Kitchen', 'Parking']);
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
          if (state is LookupsLoaded || state is SearchLoaded) {
            final propertyTypes = state is LookupsLoaded 
                ? state.propertyTypes 
                : (state as SearchLoaded).propertyTypes;
            final propertyFeatures = state is LookupsLoaded 
                ? state.propertyFeatures 
                : (state as SearchLoaded).propertyFeatures;
            
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCategorySection(propertyTypes),
                        SizedBox(height: 24.h),
                        _buildDateSection(),
                        SizedBox(height: 24.h),
                        _buildHotelNameSection(),
                        SizedBox(height: 24.h),
                        _buildPriceSection(),
                        SizedBox(height: 24.h),
                        _buildLocationSection(),
                        SizedBox(height: 24.h),
                        _buildNumberSelector(
                          'Number Of Rooms',
                          _selectedRooms,
                          (value) => setState(() => _selectedRooms = value),
                        ),
                        SizedBox(height: 24.h),
                        _buildNumberSelector(
                          'Bedrooms',
                          _selectedBedrooms,
                          (value) => setState(() => _selectedBedrooms = value),
                        ),
                        SizedBox(height: 24.h),
                        _buildNumberSelector(
                          'Bathrooms',
                          _selectedBathrooms,
                          (value) => setState(() => _selectedBathrooms = value),
                        ),
                        SizedBox(height: 24.h),
                        _buildFeaturesSection(propertyFeatures),
                        SizedBox(height: 32.h),
                      ],
                    ),
                  ),
                ),
                _buildFilterButton(),
              ],
            );
          }
          
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildCategorySection(List<LookupItemEntity> propertyTypes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose A Category',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            if (propertyTypes.isNotEmpty) ...[
              Expanded(
                child: _buildCategoryCard(
                  propertyTypes.first.id,
                  propertyTypes.first.displayName,
                  Icons.home,
                ),
              ),
              if (propertyTypes.length > 1) ...[
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildCategoryCard(
                    propertyTypes[1].id,
                    propertyTypes[1].displayName,
                    Icons.apartment,
                  ),
                ),
              ],
              if (propertyTypes.length > 2) ...[
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildCategoryCard(
                    propertyTypes[2].id,
                    propertyTypes[2].displayName,
                    Icons.business,
                  ),
                ),
              ],
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryCard(String typeId, String title, IconData icon) {
    final isSelected = _selectedPropertyTypeId == typeId;
    return GestureDetector(
      onTap: () => setState(() => _selectedPropertyTypeId = typeId),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.green.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.green : AppColors.border,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.green : AppColors.textSecondary,
              size: 32.sp,
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected ? AppColors.green : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSection() {
    return Row(
      children: [
        Expanded(
          child: _buildDateField('Check in', _checkIn, () => _selectDate(true)),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildDateField('Check Out', _checkOut, () => _selectDate(false)),
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
    );
  }

  Widget _buildHotelNameSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hotel Name',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.border.withOpacity(0.3)),
          ),
          child: TextFormField(
            controller: _hotelNameController,
            decoration: InputDecoration(
              hintText: 'Royal Samirames',
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16.w),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Range / Night',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
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
                  controller: _minPriceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Start From',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    suffixText: '\$',
                    suffixStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16.w),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.inputBackground,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.border.withOpacity(0.3)),
                ),
                child: TextFormField(
                  controller: _maxPriceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'To',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    suffixText: '\$',
                    suffixStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16.w),
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
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        GestureDetector(
          onTap: _openMapPicker,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: (_selectedLatitude != null && _selectedLongitude != null)
                    ? AppColors.primary.withOpacity(0.5)
                    : AppColors.border.withOpacity(0.3),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: (_selectedLatitude != null && _selectedLongitude != null)
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    size: 20.sp,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _locationController.text.isEmpty 
                              ? 'Select location from map'
                              : _locationController.text,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: _locationController.text.isEmpty 
                                ? AppColors.textSecondary 
                                : AppColors.textPrimary,
                          ),
                        ),
                        if (_selectedLatitude != null && _selectedLongitude != null)
                          Text(
                            'Lat: ${_selectedLatitude!.toStringAsFixed(4)}, Lng: ${_selectedLongitude!.toStringAsFixed(4)}',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 12.sp,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (_selectedLatitude != null && _selectedLongitude != null)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedLatitude = null;
                          _selectedLongitude = null;
                          _locationController.clear();
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        child: Icon(
                          Icons.close,
                          color: AppColors.textSecondary,
                          size: 18.sp,
                        ),
                      ),
                    ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                    size: 20.sp,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            'The Closest',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNumberSelector(String title, int value, ValueChanged<int> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            _buildNumberOption('1 - 3', value >= 1 && value <= 3, () => onChanged(3)),
            SizedBox(width: 8.w),
            _buildNumberOption('3 - 6', value >= 4 && value <= 6, () => onChanged(6)),
            SizedBox(width: 8.w),
            _buildNumberOption('6 - 9', value >= 7 && value <= 9, () => onChanged(9)),
            SizedBox(width: 8.w),
            _buildNumberOption('9+', value > 9, () => onChanged(10)),
          ],
        ),
      ],
    );
  }

  Widget _buildNumberOption(String text, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.green.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: isSelected ? AppColors.green : AppColors.border,
            ),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isSelected ? AppColors.green : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesSection(List<LookupItemEntity> propertyFeatures) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'More Features',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          children: propertyFeatures
              .map((feature) => _buildFeatureChip(feature.id, feature.displayName))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildFeatureChip(String featureId, String featureName) {
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
        margin: EdgeInsets.only(right: 8.w, bottom: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.green.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? AppColors.green : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? AppColors.green : AppColors.textSecondary,
              size: 16.sp,
            ),
            SizedBox(width: 6.w),
            Text(
              featureName,
              style: AppTextStyles.bodySmall.copyWith(
                color: isSelected ? AppColors.green : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
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
              propertyTypeId: _selectedPropertyTypeId,
              checkInDate: _checkIn?.millisecondsSinceEpoch,
              checkOutDate: _checkOut?.millisecondsSinceEpoch,
              pricePerNightMin: int.tryParse(_minPriceController.text),
              pricePerNightMax: int.tryParse(_maxPriceController.text),
              address: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
              hotelName: _hotelNameController.text.trim().isEmpty ? null : _hotelNameController.text.trim(),
              bedroomsMin: _selectedBedrooms,
              bedroomsMax: _selectedBedrooms + 2,
              bathroomsMin: _selectedBathrooms,
              bathroomsMax: _selectedBathrooms + 1,
              livingroomsMin: _selectedRooms,
              livingroomsMax: _selectedRooms + 2,
              numberOfBedMin: _selectedBedrooms,
              numberOfBedMax: _selectedBedrooms + 2,
              latitude: _selectedLatitude,
              longitude: _selectedLongitude,
              maximumNumberOfGuestMin: 1,
              maximumNumberOfGuestMax: 10,
              selectedFeatures: _selectedFeatures.isEmpty ? null : _selectedFeatures,
            );

            // Update filter and trigger search
            context.read<SearchBloc>().add(UpdateFilterEvent(filter: filter));
            context.read<SearchBloc>().add(SearchPropertiesEvent(filter: filter));
            
            // Navigate to search results with the new filter
            Navigator.of(context).pushReplacementNamed(
              '/search-results',
              arguments: {'filter': filter},
            );
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

}