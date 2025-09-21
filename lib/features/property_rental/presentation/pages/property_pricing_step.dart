import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';

class PropertyPricingStep extends StatefulWidget {
  final Function(Map<String, dynamic>) onNext;
  final VoidCallback onPrevious;
  final Map<String, dynamic> initialData;

  const PropertyPricingStep({
    super.key,
    required this.onNext,
    required this.onPrevious,
    required this.initialData,
  });

  @override
  State<PropertyPricingStep> createState() => _PropertyPricingStepState();
}

class _PropertyPricingStepState extends State<PropertyPricingStep> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    if (widget.initialData['pricePerNight'] != null) {
      _priceController.text = widget.initialData['pricePerNight'].toString();
    } else {
      _priceController.text = '50'; // Default price
    }
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (_formKey.currentState!.validate()) {
      final pricePerNight = double.tryParse(_priceController.text) ?? 0.0;

      if (pricePerNight <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid price'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final data = {'pricePerNight': pricePerNight};

      widget.onNext(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Price section title
                  Text(
                    'Price - Per Night',
                    style: AppTextStyles.h4.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: 40.h),

                  // Price input field
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Price input
                      Expanded(
                        child: TextFormField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}'),
                            ),
                          ],
                          style: AppTextStyles.h2.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 48.sp,
                          ),
                          textAlign: TextAlign.center,
                          validator: (value) {
                            if (value?.isEmpty == true) {
                              return 'Price is required';
                            }
                            final price = double.tryParse(value!);
                            if (price == null || price <= 0) {
                              return 'Please enter a valid price';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: '50',
                            hintStyle: AppTextStyles.h2.copyWith(
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w600,
                              fontSize: 48.sp,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),

                      SizedBox(width: 8.w),

                      // Currency symbol
                      Text(
                        '\$',
                        style: AppTextStyles.h2.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 48.sp,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // Underline
                  Container(height: 2.h, width: 200.w, color: Colors.grey[300]),

                  SizedBox(height: 40.h),

                  // Helper text
                  Text(
                    'Set your nightly rate',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Colors.grey[600],
                      fontSize: 16.sp,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  Text(
                    'You can always change this later',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.grey[500],
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Next button
          _buildNextButton(),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return Container(
      width: double.infinity,
      height: 56.h,
      child: FloatingActionButton.extended(
        onPressed: _handleNext,
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.r),
        ),
        label: Icon(Icons.arrow_forward, color: Colors.white, size: 24.sp),
      ),
    );
  }
}
