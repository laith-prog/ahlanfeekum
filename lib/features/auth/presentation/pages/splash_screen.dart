import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../widgets/custom_button.dart';
import 'auth_options_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                const Spacer(flex: 2),

                // App Logo/Icon
                Container(
                  width: 120.w,
                  height: 120.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(30.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.waving_hand,
                    size: 60.sp,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: 40.h),

                // App Name
                Text(
                  'app_name'.tr(),
                  style: AppTextStyles.h1.copyWith(
                    fontSize: 32.sp,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 16.h),

                // Welcome Message
                Text(
                  'welcome'.tr(),
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontSize: 16.sp,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),

                const Spacer(flex: 3),

                // Get Started Button
                CustomButton(
                  text: 'get_started'.tr(),
                  onPressed: () {
                    context.push(const AuthOptionsScreen());
                  },
                  width: double.infinity,
                ),

                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
