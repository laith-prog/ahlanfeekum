import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final Widget? icon;
  final double? borderRadius;
  final TextStyle? textStyle;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.icon,
    this.borderRadius,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final buttonHeight = height ?? 56.h;

    return SizedBox(
      width: width,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: textColor ?? Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
            side: borderColor != null
                ? BorderSide(color: borderColor!, width: 1.5)
                : BorderSide.none,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 24.w,
            vertical: 0, // ارتفاع الزر يحدد المساحة
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20.w,
                height: 20.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(textColor ?? Colors.white),
                ),
              )
            : (text.isEmpty
                ? Center(child: icon) // إذا النص فارغ، أيقونة في المنتصف
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[icon!, SizedBox(width: 8.w)],
                      Expanded(
                        child: Text(
                          text,
                          textAlign: TextAlign.center,
                          style: textStyle ??
                              AppTextStyles.buttonText.copyWith(
                                fontSize: 16.sp,
                                color: textColor ?? Colors.white,
                              ),
                        ),
                      ),
                    ],
                  )),
      ),
    );
  }
}
