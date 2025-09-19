import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String email;
  final String? securityCode; // Add security code parameter

  const ChangePasswordScreen({
    super.key,
    required this.email,
    this.securityCode,
  });

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleChangePassword() {


    if (_formKey.currentState!.validate()) {
      if (_newPasswordController.text == _confirmPasswordController.text) {
        // Use the new confirm password reset API if we have a security code
        if (widget.securityCode != null) {
        
          context.read<AuthBloc>().add(
            ConfirmPasswordResetEvent(
              emailOrPhone: widget.email,
              securityCode: widget.securityCode!,
              newPassword: _newPasswordController.text,
            ),
          );
        } else {
      
          // Fallback to old change password event
          context.read<AuthBloc>().add(
            ChangePasswordEvent(
              email: widget.email,
              newPassword: _newPasswordController.text,
            ),
          );
        }
      } else {
        context.showSnackBar('Passwords do not match', isError: true);
      }
    } else {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is PasswordChanged) {
            context.showSnackBar('Password changed successfully');
            // Navigate to login screen
            context.pop();
            context.pop(); // Pop twice to go back to login
          } else if (state is AuthError) {
            context.showSnackBar(state.message, isError: true);
          }
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Form(
                key: _formKey,
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

                    // Password Icon
                    Center(
                      child: Container(
                        width: 120.w,
                        height: 120.w,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255), // Green background
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/images/password.png',
                            width: 60.w,
                            height: 60.w,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 32.h),

                    // Title
                    Center(
                      child: Text(
                        'Change Password',
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
                        'Put A Strong Password To Secure Your Account',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    SizedBox(height: 40.h),

                    // New Password Label
                    Text(
                      'New Password',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 16.sp,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    // New Password Field
                    CustomTextField(
                      controller: _newPasswordController,
                      hintText: 'Password',
                      obscureText: _obscureNewPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureNewPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureNewPassword = !_obscureNewPassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter new password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 24.h),

                    // Repeat Password Label
                    Text(
                      'Repeat New Password',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 16.sp,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    // Confirm Password Field
                    CustomTextField(
                      controller: _confirmPasswordController,
                      hintText: 'Repeat Password',
                      obscureText: _obscureConfirmPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 60.h),

                    // Change Button
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return CustomButton(
                          text: 'Change',
                          onPressed: _handleChangePassword,
                          isLoading: state is AuthLoading,
                          width: double.infinity,
                          backgroundColor: const Color(
                            0xFFED1C24,
                          ), // Red button
                        );
                      },
                    ),

                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
