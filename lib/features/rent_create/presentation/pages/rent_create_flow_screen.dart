import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../bloc/rent_create_bloc.dart';
import '../bloc/rent_create_event.dart';
import '../bloc/rent_create_state.dart';
import '../../domain/entities/rent_create_entities.dart';
import 'steps/property_details_step.dart';
import 'steps/photos_step.dart';
import 'steps/price_step.dart';
import 'steps/location_step.dart';
import 'steps/availability_step.dart';
import 'steps/review_step.dart';
import 'widgets/progress_step_indicator.dart';

class RentCreateFlowScreen extends StatefulWidget {
  const RentCreateFlowScreen({super.key});

  @override
  State<RentCreateFlowScreen> createState() => _RentCreateFlowScreenState();
}

class _RentCreateFlowScreenState extends State<RentCreateFlowScreen> {
  final PageController _pageController = PageController();
  DateTime? _lastNavigationTime;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RentCreateBloc, RentCreateState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
        if (state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage!),
              backgroundColor: Colors.green,
            ),
          );
        }

        // Auto-navigate to next step when images are uploaded (only this one)
        if (state.status == RentCreateStatus.imagesUploaded) {
          final now = DateTime.now();
          // Prevent rapid multiple navigations
          if (_lastNavigationTime == null ||
              now.difference(_lastNavigationTime!).inSeconds > 2) {
            _lastNavigationTime = now;
            print(
              '📱 Images uploaded successfully, navigating to next step...',
            );
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          } else {
            print('📱 Navigation throttled - too soon after last navigation');
          }
        }

        // Navigate to completion screen when property is submitted
        if (state.status == RentCreateStatus.propertySubmitted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const PropertyCreatedSuccessScreen(),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.close, color: AppColors.textPrimary),
            onPressed: () => _showExitDialog(context),
          ),
          title: Text(
            'Add Property',
            style: AppTextStyles.h4.copyWith(
              color: AppColors.textPrimary,
              fontSize: 18.sp,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            SizedBox(height: 30.h,),
            _buildStepIndicator(),
            Expanded(child: _buildStepContent()),
            SizedBox(height: 80.h), // Space for floating buttons
          ],
        ),
        floatingActionButton: _buildFloatingActionButtons(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _buildStepIndicator() {
    return BlocBuilder<RentCreateBloc, RentCreateState>(
      builder: (context, state) {
        return Column(
          children: [
            ProgressStepIndicator(steps: state.steps),
            SizedBox(height: 12.h),
          ],
        );
      },
    );
  }

  Widget _buildStepContent() {
    return BlocBuilder<RentCreateBloc, RentCreateState>(
      builder: (context, state) {
        return PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            context.read<RentCreateBloc>().add(NavigateToStepEvent(index));
          },
          children: [
            const PropertyDetailsStep(),
            const LocationStep(),
            const AvailabilityStep(),
            const PhotosStep(),
            const PriceStep(),
            const ReviewStep(),
          ],
        );
      },
    );
  }

  Widget _buildFloatingActionButtons() {
    return BlocBuilder<RentCreateBloc, RentCreateState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Previous button (white with arrow)
              if (state.canGoPrevious)
                FloatingActionButton(
                  onPressed: state.isLoading
                      ? null
                      : () {
                          context.read<RentCreateBloc>().add(
                            const PreviousStepEvent(),
                          );
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                  backgroundColor: Colors.white,
                  elevation: 4,
                  heroTag: "previous_btn",
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.textPrimary,
                    size: 20.sp,
                  ),
                ),
              
              // Continue button (red with arrow)
              FloatingActionButton(
                onPressed: state.canGoNext && !state.isLoading
                    ? () => _handleNextButton(context, state)
                    : null,
                backgroundColor: state.canGoNext && !state.isLoading 
                    ? AppColors.primary 
                    : Colors.grey[400],
                elevation: 4,
                heroTag: "continue_btn",
                child: state.isLoading
                    ? SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 20.sp,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }


  void _handleNextButton(BuildContext context, RentCreateState state) {
    final bloc = context.read<RentCreateBloc>();

    if (state.isLastStep) {
      // Submit the property
      bloc.add(const SubmitPropertyEvent());
    } else {
      // Move to next step
      switch (state.currentStep) {
        case PropertyCreationStep.propertyDetails:
          // Just move to next step (location) without API call
          bloc.add(const NextStepEvent());
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          return;
        case PropertyCreationStep.location:
          // Create property after both details and location are filled
          bloc.add(const CreatePropertyStepOneEvent());
          break;
        case PropertyCreationStep.availability:
          bloc.add(const AddAvailabilityEvent());
          break;
        case PropertyCreationStep.photos:
          bloc.add(const UploadImagesEvent());
          break;
        case PropertyCreationStep.price:
          bloc.add(const SetPriceEvent());
          break;
        case PropertyCreationStep.review:
          bloc.add(const SubmitPropertyEvent());
          break;
      }

      // Only navigate to next step if not on the last step
      if (!state.isLastStep) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!bloc.state.isLoading && bloc.state.errorMessage == null) {
            bloc.add(const NextStepEvent());
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        });
      }
    }
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Exit Property Creation?'),
        content: const Text(
          'Are you sure you want to exit? Your progress will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }
}

class PropertyCreatedSuccessScreen extends StatelessWidget {
  const PropertyCreatedSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120.w,
                height: 120.h,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                  size: 60.sp,
                ),
              ),
              SizedBox(height: 32.h),
              Text(
                'Property Created Successfully!',
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 24.sp,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              Text(
                'Your property has been submitted for review. You\'ll receive a notification once it\'s approved and live.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 16.sp,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 48.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil('/main', (route) => false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Back to Home',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
