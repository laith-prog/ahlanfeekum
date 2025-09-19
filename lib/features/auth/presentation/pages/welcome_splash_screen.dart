import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../widgets/custom_button.dart';
import 'auth_options_screen.dart';

class WelcomeSplashScreen extends StatelessWidget {
  const WelcomeSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الصورة الخلفية
          Positioned.fill(
            child: Image.asset(
              'assets/images/Background1.png',
              fit: BoxFit.cover,
     
              colorBlendMode: BlendMode.srcOver,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ),

          // محتوى الشاشة
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: 184.h),

                // Logo
                Center(
                  child: Image.asset(
                    'assets/icons/logo.png',
                    width: 198.w,
                    height: 108.w,
                  ),
                ),

                const Spacer(),

                // القسم الأبيض المنحني
                ClipPath(
                  clipper: TopCurveClipper(),
                  child: Container(
                    height: 293.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 54.h,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Ahlan Feekum',
                            style: AppTextStyles.h6.copyWith(
                              fontSize: 16.sp,
                              color: AppColors.textSecondary,
                         
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10.h),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Discover A Unique ',
                                  style: AppTextStyles.h2.copyWith(
                                    fontSize: 24.sp,
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Stay\nExperience',
                                  style: AppTextStyles.h2.copyWith(
                                    fontSize: 24.sp,
                                    color: const Color(0xFF4CAF50),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(
                                  text: ' In Syria',
                                  style: AppTextStyles.h2.copyWith(
                                    fontSize: 24.sp,
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 32.h),
                          CustomButton(borderRadius: 16.r,
                            text: 'get_started'.tr(),
                            onPressed: () {
                              context.push(const AuthOptionsScreen());
                            },
                            width: double.infinity,
                          ),
                        
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    final double curveHeight = size.height * 0.1; // 5% من ارتفاع الشاشة

    path.moveTo(0, curveHeight);

    path.cubicTo(
      size.width * 0.25,
      0,                 // control point أعلى
      size.width * 0.75,
      0,                 // control point أعلى
      size.width,
      curveHeight,       // نهاية القوس
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
