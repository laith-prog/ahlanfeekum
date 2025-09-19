import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';

import '../../../../core/utils/extensions.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../widgets/custom_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'change_password_screen.dart';
import '../../../navigation/presentation/pages/main_navigation_screen.dart';
import 'set_profile_screen.dart';
import '../cubit/registration_cubit.dart';
import '../../../../core/di/injection.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  final String otpCode;
  final bool isForgotPassword; // true = forgot password flow, false = login OTP
  final bool continueToProfile; // registration flow control
  final RegistrationCubit? registrationCubit; // For registration flow

  const OtpVerificationScreen({
    super.key,
    required this.email,
    required this.otpCode,
    this.isForgotPassword = false,
    this.continueToProfile = false,
    this.registrationCubit,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpController = TextEditingController();
  Timer? _timer;
  int _remainingTime = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _remainingTime = 60;
    _canResend = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  void _handleVerifyOtp() {
    if (_otpController.text.length == 4) {
      if (widget.isForgotPassword) {
        // For forgot password, we don't verify OTP here - just navigate to change password
        // The actual verification happens when confirming password reset
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChangePasswordScreen(
              email: widget.email,
              securityCode: _otpController.text,
            ),
          ),
        );
      } else {
        context.read<AuthBloc>().add(
          VerifyOtpEvent(email: widget.email, otp: _otpController.text),
        );
      }
    } else {
      context.showSnackBar(
        'Please enter the complete 4-digit OTP',
        isError: true,
      );
    }
  }

  void _handleResendOtp() {
    if (_canResend) {
      context.read<AuthBloc>().add(SendOtpEvent(email: widget.email));
      _startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56.w,
      height: 56.w,
      textStyle: AppTextStyles.h4.copyWith(
        fontSize: 20.sp,
        color: AppColors.textPrimary,
      ),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12.r),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.primary, width: 2),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: AppColors.primary.withValues(alpha: 0.1),
        border: Border.all(color: AppColors.primary),
      ),
    );

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is OtpVerified || state is AuthAuthenticated) {
            context.showSnackBar('verification_success'.tr());
            if (widget.continueToProfile) {
              // Registration flow - go directly to profile setup
              // Missing field will be handled within SetProfileScreen
              final cubit =
                  widget.registrationCubit ?? getIt<RegistrationCubit>();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider<RegistrationCubit>.value(
                    value: cubit,
                    child: const SetProfileScreen(),
                  ),
                ),
              );
            } else if (!widget.isForgotPassword) {
              // Normal login flow - navigate to home and clear all previous routes
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
                (route) => false,
              );
            }
            // For forgot password, navigation is handled in _handleVerifyOtp
          } else if (state is AuthError) {
            context.showSnackBar(state.message.tr(), isError: true);
          } else if (state is OtpSent) {
            context.showSnackBar('verification_sent'.tr());
          }
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white, // White background to match image
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),

                  // Back Button
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 24.sp,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  SizedBox(height: 40.h),

                  // Email Shield Icon
                  Center(
                    child: Container(
                      width: 120.w,
                      height: 120.w,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255), 
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/images/security_5797697 1.svg',
                          width: 107.w,
                          height: 100.w,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // Title
                  Center(
                    child: Text(
                      'Verify Through Email',
                      style: AppTextStyles.h2.copyWith(
                        fontSize: 24.sp,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Subtitle
                  Center(
                    child: Text(
                      'We Sent A 4 - Digit Code To ${widget.email.replaceAll(RegExp(r'(?<=.{3}).(?=.*@)'), '*')} , Please Check Your Mail Inbox.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: 40.h),

                  // OTP Input
                  Center(
                    child: Pinput(
                      controller: _otpController,
                      length: 4, // Changed to 4 digits
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      submittedPinTheme: submittedPinTheme,
                      showCursor: true,
                      onCompleted: (pin) => _handleVerifyOtp(),
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // Timer and Resend
                  Center(
                    child: Column(
                      children: [
                        if (!_canResend) ...[
                          Text(
                            '${_remainingTime}s left',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: 14.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ] else ...[
                          TextButton(
                            onPressed: _handleResendOtp,
                            child: Text(
                              'Resend',
                              style: AppTextStyles.linkText.copyWith(
                                fontSize: 16.sp,
                                color: const Color(0xFFED1C24), // Red color
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // Verify Button
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return CustomButton(
                        text: 'Verify',
                        onPressed: _handleVerifyOtp,
                        isLoading: state is AuthLoading,
                        width: double.infinity,
                        backgroundColor: const Color(0xFFED1C24), // Red button
                      );
                    },
                  ),

                  SizedBox(height: 40.h),

                  // Debug info (remove in production)
                  if (widget.otpCode.isNotEmpty) ...[
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: AppColors.info.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: AppColors.info.withValues(alpha: 0.3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
