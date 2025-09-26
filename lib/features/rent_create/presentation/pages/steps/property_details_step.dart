import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../theming/colors.dart';
import '../../../../../theming/text_styles.dart';
import '../../../../search/presentation/bloc/search_bloc.dart';
import '../../../../search/presentation/bloc/search_state.dart';
import '../../bloc/rent_create_bloc.dart';
import '../../bloc/rent_create_event.dart';
import '../../bloc/rent_create_state.dart';
import '../widgets/counter_widget.dart';
import '../widgets/feature_chip_widget.dart';
import '../widgets/property_type_chip.dart';

class PropertyDetailsStep extends StatefulWidget {
  const PropertyDetailsStep({super.key});

  @override
  State<PropertyDetailsStep> createState() => _PropertyDetailsStepState();
}

class _PropertyDetailsStepState extends State<PropertyDetailsStep> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _houseRulesController = TextEditingController();
  final _importantInfoController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _houseRulesController.dispose();
    _importantInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RentCreateBloc, RentCreateState>(
      builder: (context, rentState) {
        // Update controllers when form data changes
        if (_titleController.text != (rentState.formData.propertyTitle ?? '')) {
          _titleController.text = rentState.formData.propertyTitle ?? '';
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Property Type'),
              SizedBox(height: 12.h),
              _buildPropertyTypeSelector(),

              SizedBox(height: 24.h),
              _buildSectionTitle('Property Title'),
              SizedBox(height: 12.h),
              _buildTextField(
                controller: _titleController,
                hintText: '130',
                onChanged: (value) {
                  context.read<RentCreateBloc>().add(
                    UpdatePropertyTitleEvent(value),
                  );
                },
              ),

              SizedBox(height: 24.h),
              _buildSectionTitle('Property Details'),
              SizedBox(height: 16.h),
              _buildPropertyCounters(rentState),

              SizedBox(height: 24.h),
              _buildSectionTitle('Property Description'),
              SizedBox(height: 12.h),
              _buildTextField(
                controller: _descriptionController,
                hintText: 'Type Here',
                maxLines: 4,
                onChanged: (value) {
                  context.read<RentCreateBloc>().add(
                    UpdatePropertyDescriptionEvent(value),
                  );
                },
              ),

              SizedBox(height: 24.h),
              _buildSectionTitle('More Features'),
              SizedBox(height: 12.h),
              _buildPropertyFeatures(),

              SizedBox(height: 24.h),
              _buildSectionTitle('Instructions'),
              SizedBox(height: 16.h),

              _buildSubSectionTitle('House Rules'),
              SizedBox(height: 8.h),
              _buildTextField(
                controller: _houseRulesController,
                hintText: 'Type Here',
                maxLines: 3,
                onChanged: (value) {
                  context.read<RentCreateBloc>().add(
                    UpdateHouseRulesEvent(value),
                  );
                },
              ),

              SizedBox(height: 16.h),
              _buildSubSectionTitle('Important Information'),
              SizedBox(height: 8.h),
              _buildTextField(
                controller: _importantInfoController,
                hintText: 'Type Here',
                maxLines: 3,
                onChanged: (value) {
                  context.read<RentCreateBloc>().add(
                    UpdateImportantInfoEvent(value),
                  );
                },
              ),

              SizedBox(height: 24.h),
              _buildGovernorateSelector(),

              SizedBox(height: 100.h), // Space for bottom navigation
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.h4.copyWith(
        color: AppColors.textPrimary,
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildSubSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textPrimary,
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    required Function(String) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: Colors.grey[400],
            fontSize: 14.sp,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: AppColors.primary, width: 1.5),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 18.w,
            vertical: maxLines > 1 ? 16.h : 14.h,
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyTypeSelector() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, searchState) {
        if (searchState is LookupsLoaded) {
          return BlocBuilder<RentCreateBloc, RentCreateState>(
            builder: (context, rentState) {
              return Wrap(
                spacing: 12.w,
                runSpacing: 12.h,
                children: searchState.propertyTypes.map((type) {
                  final isSelected =
                      type.id == rentState.formData.propertyTypeId;
                  return PropertyTypeChip(
                    label: type.displayName,
                    isSelected: isSelected,
                    onTap: () {
                      context.read<RentCreateBloc>().add(
                        UpdatePropertyTypeEvent(type.id, type.displayName),
                      );
                    },
                  );
                }).toList(),
              );
            },
          );
        }
        return SizedBox(
          height: 48.h,
          child: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget _buildPropertyCounters(RentCreateState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CounterWidget(
          title: 'Bedrooms',
          value: state.formData.bedrooms,
          minValue: 0,
          maxValue: 20,
          onChanged: (value) {
            context.read<RentCreateBloc>().add(UpdateBedroomsEvent(value));
          },
        ),
        SizedBox(height: 20.h),
        CounterWidget(
          title: 'Bathrooms',
          value: state.formData.bathrooms,
          minValue: 0,
          maxValue: 20,
          onChanged: (value) {
            context.read<RentCreateBloc>().add(UpdateBathroomsEvent(value));
          },
        ),
        SizedBox(height: 20.h),
        CounterWidget(
          title: 'Number Of Beds',
          value: state.formData.numberOfBeds,
          minValue: 0,
          maxValue: 20,
          onChanged: (value) {
            context.read<RentCreateBloc>().add(UpdateNumberOfBedsEvent(value));
          },
        ),
        SizedBox(height: 20.h),
        CounterWidget(
          title: 'Floor',
          value: state.formData.floor,
          minValue: 0,
          maxValue: 50,
          onChanged: (value) {
            context.read<RentCreateBloc>().add(UpdateFloorEvent(value));
          },
        ),
        SizedBox(height: 20.h),
        CounterWidget(
          title: 'Maximum Number Of Guests',
          value: state.formData.maximumNumberOfGuests,
          minValue: 0,
          maxValue: 50,
          onChanged: (value) {
            context.read<RentCreateBloc>().add(UpdateMaxGuestsEvent(value));
          },
        ),
        SizedBox(height: 20.h),
        CounterWidget(
          title: 'Living Rooms',
          value: state.formData.livingRooms,
          minValue: 0,
          maxValue: 20,
          onChanged: (value) {
            context.read<RentCreateBloc>().add(UpdateLivingRoomsEvent(value));
          },
        ),
      ],
    );
  }

  Widget _buildPropertyFeatures() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, searchState) {
        if (searchState is LookupsLoaded) {
          return BlocBuilder<RentCreateBloc, RentCreateState>(
            builder: (context, rentState) {
              return Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: searchState.propertyFeatures.map((feature) {
                  final isSelected = rentState.formData.propertyFeatureIds
                      .contains(feature.id);

                  return FeatureChipWidget(
                    label: feature.displayName,
                    isSelected: isSelected,
                    onTap: () {
                      final currentIds = List<String>.from(
                        rentState.formData.propertyFeatureIds,
                      );
                      final currentNames = List<String>.from(
                        rentState.formData.selectedFeatures,
                      );

                      if (isSelected) {
                        currentIds.remove(feature.id);
                        currentNames.remove(feature.displayName);
                      } else {
                        currentIds.add(feature.id);
                        currentNames.add(feature.displayName);
                      }

                      context.read<RentCreateBloc>().add(
                        UpdatePropertyFeaturesEvent(currentIds, currentNames),
                      );
                    },
                  );
                }).toList(),
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildGovernorateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Governorate'),
        SizedBox(height: 12.h),
        BlocBuilder<SearchBloc, SearchState>(
          builder: (context, searchState) {
            if (searchState is LookupsLoaded) {
              return BlocBuilder<RentCreateBloc, RentCreateState>(
                builder: (context, rentState) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.grey.withValues(alpha: 0.25),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: rentState.formData.governorateId,
                        icon: Icon(
                          Icons.expand_more,
                          color: AppColors.primary,
                          size: 18.sp,
                        ),
                        hint: Text(
                          'Select Governorate',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.grey[400],
                            fontSize: 14.sp,
                          ),
                        ),
                        items: searchState.governates.map((governorate) {
                          return DropdownMenuItem(
                            value: governorate.id,
                            child: Text(
                              governorate.displayName,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                                fontSize: 14.sp,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            final selectedGovernorate = searchState.governates
                                .firstWhere((gov) => gov.id == value);
                            context.read<RentCreateBloc>().add(
                              UpdateGovernorateEvent(
                                value,
                                selectedGovernorate.displayName,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ],
    );
  }
}
