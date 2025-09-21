import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import 'add_property_wizard_screen.dart';

class RentOutSplashScreen extends StatelessWidget {
  const RentOutSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20.sp),
          onPressed: () => Navigator.pop(context),
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Home location SVG icon
                  SvgPicture.asset(
                    'assets/images/home-location.svg',
                    width: 120.w,
                    height: 120.h,
                  ),

                  SizedBox(height: 40.h),

                  // Main title
                  Text(
                    'Be A Host And Start Making Money !',
                    style: AppTextStyles.h3.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 16.h),

                  // Subtitle
                  Text(
                    'Here You Can Add Your Property To Start Renting',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.grey[600],
                      fontSize: 16.sp,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Start Making Money button
            Padding(
              padding: EdgeInsets.only(bottom: 40.h),
              child: SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddPropertyWizardScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Start Making Money',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
