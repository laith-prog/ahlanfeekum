import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../widgets/custom_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'login_screen.dart';
import 'choose_account_screen.dart';

class AuthOptionsScreen extends StatelessWidget {
  const AuthOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Navigate to home screen
            context.showSnackBar('login_success'.tr());
          } else if (state is AuthError) {
            context.showSnackBar(state.message.tr(), isError: true);
          }
        },
        child: Stack(
          children: [
            // Background image

            // Background image
            Positioned.fill(
              child: Image.asset('assets/images/DarkBG.png', fit: BoxFit.cover),
            ),

            // Rectangle at top
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 24.h),
                child: Image.asset(
                  'assets/icons/Rectangle.png',
                  width: 60.w,
                  height: 6.h,
                ),
              ),
            ),

            // Logo above modal
          Align(
  alignment: Alignment(0, -0.4), // طلّع اللوجو شوي لفوق
  child: Image.asset(
    'assets/icons/logo.png',
    width: 180.w, // كبّر الحجم مثل ما بالصورة
    fit: BoxFit.contain,
    errorBuilder: (context, error, stackTrace) =>
        Icon(Icons.business, size: 100.w, color: Colors.grey),
  ),
),

            // Modal dialog
            Align(
              alignment: Alignment(0, 0.8),
              child: _buildAuthModal(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthModal(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Star icon in circle
          Positioned(
            top: -16,
            left: 16,
            child: Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  'assets/icons/start.png',
                  width: 44.w,
                  height: 45.w,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.star, size: 32.w, color: Colors.amber[900]),
                ),
              ),
            ),
          ),

          // Close button
          Positioned(
            top: 16,
            right: 16,
            child: GestureDetector(
              onTap: () => context.pop(),
              child: Icon(Icons.close, size: 24.sp, color: Colors.grey),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 48.h, 24.w, 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  'Get Started',
                  style: AppTextStyles.h3.copyWith(
                    fontSize: 20.sp,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),

                SizedBox(height: 8.h),

                // Subtitle
                Text(
                  'Get Started And Begin Your Journey In Our Fabulous Renting App',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 12.sp,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),

                SizedBox(height: 24.h),

                // Register Button
                CustomButton(
                  text: 'Register',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ChooseAccountScreen(),
                      ),
                    );
                  },
                  width: double.infinity,
                  backgroundColor: const Color(0xFFED1C24),
                  textColor: Colors.white,
                ),

                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        height: 48.h,
                        text: 'Login',
                        textStyle: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Lato',
                          color: AppColors.textPrimary,
                        ),
                        onPressed: () {
                          context.push(const LoginScreen());
                        },
                        backgroundColor: Colors.grey[100],
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return CustomButton(
                            height: 48.h,
                            text: '', // لا نص لأن فيه صورة فقط
                            icon: state is AuthLoading
                                ? SizedBox(
                                    width: 20.w,
                                    height: 20.w,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.black,
                                      ),
                                    ),
                                  )
                                : Image.asset(
                                    'assets/icons/google.png',
                                    width: 24.w,
                                    height: 24.w,
                                  ),
                            onPressed: () {
                              context.read<AuthBloc>().add(
                                const GoogleSignInEvent(),
                              );
                            },
                            backgroundColor: Colors.grey[100],
                          );
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                // Terms text
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 10.sp,
                        color: AppColors.textSecondary,
                      ),
                      children: [
                        const TextSpan(
                          text: 'By Continuing, You Agree To Ahlan Feekm ',
                        ),
                        TextSpan(
                          text: 'Terms Of Use',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Handle terms of use tap
                            },
                        ),
                      ],
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
