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
        Row(
          children: [
            _buildCounterButton(
              icon: Icons.remove,
              onTap: value > minValue ? () => onChanged(value - 1) : null,
            ),
            SizedBox(width: 12.w),
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: Text(
                  value.toString(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            _buildCounterButton(
              icon: Icons.add,
              onTap: value < maxValue ? () => onChanged(value + 1) : null,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCounterButton({
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    final isEnabled = onTap != null;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: isEnabled ? AppColors.primary : Colors.grey[200],
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isEnabled ? AppColors.primary : Colors.grey[300]!,
          ),
        ),
        child: Icon(
          icon,
          color: isEnabled ? Colors.white : Colors.grey[400],
          size: 20.sp,
        ),
      ),
    );
  }
}
