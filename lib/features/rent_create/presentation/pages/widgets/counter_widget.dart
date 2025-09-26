import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../theming/colors.dart';
import '../../../../../theming/text_styles.dart';

class CounterWidget extends StatelessWidget {
  final String title;
  final int value;
  final ValueChanged<int> onChanged;
  final int minValue;
  final int maxValue;

  const CounterWidget({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.minValue = 1,
    this.maxValue = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.18)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value.toString(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildArrowButton(
                    icon: Icons.expand_more,
                    onTap: value > minValue ? () => onChanged(value - 1) : null,
                  ),
                  SizedBox(width: 12.w),
                  _buildArrowButton(
                    icon: Icons.expand_less,
                    onTap: value < maxValue ? () => onChanged(value + 1) : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildArrowButton({
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    final isEnabled = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32.w,
        height: 32.h,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: isEnabled ? 0.12 : 0.06),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(
          icon,
          color: isEnabled ? AppColors.primary : Colors.grey[400],
          size: 18.sp,
        ),
      ),
    );
  }
}
