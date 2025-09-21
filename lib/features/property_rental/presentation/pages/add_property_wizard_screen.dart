import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../../../../core/di/injection.dart';
import '../bloc/property_rental_bloc.dart';
import '../bloc/property_rental_state.dart';
import 'property_details_step.dart';
import 'property_location_step.dart';
import 'property_availability_step.dart';
import 'property_photos_step.dart';
import 'property_pricing_step.dart';
import 'property_summary_step.dart';

class AddPropertyWizardScreen extends StatefulWidget {
  const AddPropertyWizardScreen({super.key});

  @override
  State<AddPropertyWizardScreen> createState() =>
      _AddPropertyWizardScreenState();
}

class _AddPropertyWizardScreenState extends State<AddPropertyWizardScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Data storage for the wizard steps
  Map<String, dynamic> propertyData = {};

  final List<String> _stepTitles = [
    'Property Details',
    'Location',
    'Available In',
    'Photos',
    'Price',
    'Review',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep([Map<String, dynamic>? stepData]) {
    if (stepData != null) {
      propertyData.addAll(stepData);
    }

    if (_currentStep < _stepTitles.length - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PropertyRentalBloc>(),
      child: BlocListener<PropertyRentalBloc, PropertyRentalState>(
        listener: (context, state) {
          if (state is PropertyRentalError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is PropertyCreationCompleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            // Navigate back to home or show success screen
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        },
        child: _buildWizardScreen(context),
      ),
    );
  }

  Widget _buildWizardScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20.sp),
          onPressed: _currentStep == 0
              ? () => Navigator.pop(context)
              : _previousStep,
        ),
        title: Text(
          'Add Property',
          style: AppTextStyles.h4.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Progress indicator
          _buildProgressIndicator(),

          // Step content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                PropertyDetailsStep(
                  onNext: _nextStep,
                  initialData: propertyData,
                ),
                PropertyLocationStep(
                  onNext: _nextStep,
                  onPrevious: _previousStep,
                  initialData: propertyData,
                ),
                PropertyAvailabilityStep(
                  onNext: _nextStep,
                  onPrevious: _previousStep,
                  initialData: propertyData,
                ),
                PropertyPhotosStep(
                  onNext: _nextStep,
                  onPrevious: _previousStep,
                  initialData: propertyData,
                ),
                PropertyPricingStep(
                  onNext: _nextStep,
                  onPrevious: _previousStep,
                  initialData: propertyData,
                ),
                PropertySummaryStep(
                  onPrevious: _previousStep,
                  propertyData: propertyData,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        children: [
          // Step title and number
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 24.w,
                height: 24.h,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${_currentStep + 1}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                _stepTitles[_currentStep],
                style: AppTextStyles.h5.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Progress bar
          LinearProgressIndicator(
            value: (_currentStep + 1) / _stepTitles.length,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 4.h,
          ),
        ],
      ),
    );
  }
}
