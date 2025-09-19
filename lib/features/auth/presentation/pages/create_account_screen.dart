import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../cubit/registration_cubit.dart';
import '../../../../theming/text_styles.dart';
import '../../../../theming/colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/phone_field.dart';
import 'otp_verification_screen.dart';
import '../../../../core/di/injection.dart';
import '../../domain/usecases/send_otp_phone_usecase.dart';
import '../../domain/usecases/send_otp_usecase.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Image.asset('assets/icons/logo.png', height: 64.h)),
              SizedBox(height: 12.h),
              Text(
                'Create Account',
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Type Your Phone Number To Continue',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 20.h),

              // Phone input with country code picker
              PhoneField(hintText: 'Phone Number'),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Text(
                        'or',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
              ),

              CustomButton(
                text: 'Continue With Email Address',
                backgroundColor: Colors.grey[100],
                textColor: AppColors.textPrimary,
                onPressed: () {
                  _showEmailDialog(context);
                },
              ),

              SizedBox(height: 40.h),
              CustomButton(
                text: 'Next',
                backgroundColor: const Color(0xFFED1C24),
                textColor: Colors.white,
                onPressed: () async {
                  final cubit = context.read<RegistrationCubit>();
                  final phone = cubit.state.phoneNumber.trim();
                  final countryCode = cubit.state.countryCode;
                  final fullPhoneNumber = '$countryCode$phone';

                  if (phone.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Enter phone number')),
                    );
                    return;
                  }
                  try {
                    // Set registration method to phone
                    cubit.setRegistrationMethod(RegistrationMethod.phone);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sending OTP...')),
                    );
                    final result = await getIt<SendOtpPhoneUseCase>()(
                      fullPhoneNumber,
                    );
                    result.fold(
                      (failure) => ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(failure.message))),
                      (ok) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => OtpVerificationScreen(
                              email: fullPhoneNumber,
                              otpCode: '',
                              isForgotPassword: false,
                              continueToProfile: true,
                              registrationCubit: cubit,
                            ),
                          ),
                        );
                      },
                    );
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to send OTP: $e')),
                      );
                    }
                  }
                },
              ),
              SizedBox(height: 16.h),
              Center(
                child: RichText(
                  text: TextSpan(
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    children: [
                      const TextSpan(text: 'Already Have An Account , '),
                      TextSpan(
                        text: 'Login',
                        style: const TextStyle(color: Color(0xFFED1C24)),
                        // navigation to login handled elsewhere if needed
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showEmailDialog(BuildContext context) {
    final controller = TextEditingController(
      text: context.read<RegistrationCubit>().state.email,
    );
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Enter Email'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(hintText: 'example@gmail.com'),
          onChanged: (v) => context.read<RegistrationCubit>().setEmail(v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final email = controller.text.trim();
              if (email.isEmpty) return;
              try {
                // Set registration method to email
                context.read<RegistrationCubit>().setRegistrationMethod(
                  RegistrationMethod.email,
                );

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Sending OTP...')));
                final result = await getIt<SendOtpUseCase>()(email: email);
                result.fold(
                  (failure) => ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(failure.message))),
                  (ok) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => OtpVerificationScreen(
                          email: email,
                          otpCode: '',
                          isForgotPassword: false,
                          continueToProfile: true,
                          registrationCubit: context.read<RegistrationCubit>(),
                        ),
                      ),
                    );
                  },
                );
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to send OTP: $e')),
                  );
                }
              }
            },
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }
}
