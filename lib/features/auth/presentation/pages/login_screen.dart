import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'otp_verification_screen.dart';
import '../../../navigation/presentation/pages/main_navigation_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailOrPhoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailOrPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginEvent(
          phoneOrEmail: _emailOrPhoneController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  void _handleForgotPassword() {
    final emailOrPhone = _emailOrPhoneController.text.trim();

    if (emailOrPhone.isEmpty) {
      context.showSnackBar(
        'Please enter your email or phone first',
        isError: true,
      );
      return;
    }

    context.read<AuthBloc>().add(
      PasswordResetRequestEvent(emailOrPhone: emailOrPhone),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.showSnackBar('login_success'.tr());
            // Navigate to home screen and clear all previous routes
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
              (route) => false,
            );
          } else if (state is AuthError) {
            context.showSnackBar(state.message.tr(), isError: true);
          } else if (state is OtpSent) {
            context.showSnackBar('verification_sent'.tr());
            context.push(
              OtpVerificationScreen(
                email: state.email,
                otpCode: state.otpCode,
                isForgotPassword: true, // This is for forgot password flow
              ),
            );
          } else if (state is PasswordResetRequested) {
            context.showSnackBar(
              'Password reset code sent to ${state.emailOrPhone}',
            );
            context.push(
              OtpVerificationScreen(
                email: state.emailOrPhone,
                otpCode:
                    '', // We don't get the code from password reset request
                isForgotPassword: true,
              ),
            );
          }
        },
        child: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/bulding.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Logo
            Positioned(
              top: 120.h,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  'assets/icons/logo.png',
                  width: 150.w,
                  height: 82.w,
                ),
              ),
            ),

            // Gray curved underlay (second layer)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipPath(
                clipper: LoginTopCurveClipper(),
                child: Container(height: 540.h, color: const Color(0xFFF2F3F6)),
              ),
            ),

            // Curved white section with form (top layer)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipPath(
                clipper: LoginTopCurveClipper(),
                child: Container(
                  height: 520.h,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(24.w, 60.h, 24.w, 40.h),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            'Login',
                            style: AppTextStyles.h2.copyWith(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),

                          SizedBox(height: 8.h),

                          // Subtitle
                          Text(
                            'Please Put Your Credentials To Login To Your Account',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: 14.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),

                          SizedBox(height: 40.h),

                          // Email or Phone Field
                          CustomTextField(
                            labelText: '',
                            hintText: 'Email Or Phone Number',
                            controller: _emailOrPhoneController,
                            keyboardType: TextInputType.emailAddress,
                            validator: Validators.validateEmailOrPhone,
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: AppColors.textSecondary,
                              size: 20.sp,
                            ),
                          ),

                          SizedBox(height: 24.h),

                          // Password Field
                          CustomTextField(
                            labelText: '',
                            hintText: 'Password',
                            controller: _passwordController,
                            obscureText: true,
                            validator: Validators.validatePassword,
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: AppColors.textSecondary,
                              size: 20.sp,
                            ),
                          ),

                          SizedBox(height: 16.h),

                          // Forgot Password
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              onPressed: _handleForgotPassword,
                              child: Text(
                                'Forgot Password ?',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontSize: 14.sp,
                                  color: AppColors.textSecondary,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 32.h),

                          // Login Button
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              return CustomButton(
                                text: 'Login',
                                onPressed: _handleLogin,
                                isLoading: state is AuthLoading,
                                width: double.infinity,
                                backgroundColor: const Color(0xFFED1C24),
                                textColor: Colors.white,
                              );
                            },
                          ),

                          SizedBox(height: 24.h),

                          // Sign Up Link
                          Center(
                            child: RichText(
                              text: TextSpan(
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontSize: 14.sp,
                                  color: AppColors.textSecondary,
                                ),
                                children: [
                                  const TextSpan(
                                    text: "Don't Have An Account, ",
                                  ),
                                  WidgetSpan(
                                    child: GestureDetector(
                                      onTap: () {
                                        // Navigate to sign up screen
                                      },
                                      child: Text(
                                        'Register',
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                              fontSize: 14.sp,
                                              color: const Color(0xFFED1C24),
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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

class LoginTopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // ارتفاع الانحناء يعتمد على ارتفاع الشاشة
    final double curveHeight = 0.08 * size.height; // 8% من ارتفاع الشاشة

    // البداية من أعلى يسار الشاشة
    path.moveTo(0, 0);

    // القوس للأعلى
    path.quadraticBezierTo(
      size.width / 2, // منتصف العرض
      curveHeight, // أعلى نقطة للقوس
      size.width, // نهاية القوس على اليمين
      0, // مستوى البداية
    );

    // إكمال المستطيل لتحت
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

@override
bool shouldReclip(CustomClipper<Path> oldClipper) => false;
