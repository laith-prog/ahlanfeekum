import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/di/injection.dart';
import '../cubit/registration_cubit.dart';
import '../../../../theming/text_styles.dart';
import '../../../../theming/colors.dart';
import '../widgets/custom_button.dart';
import 'create_account_screen.dart';

class ChooseAccountScreen extends StatefulWidget {
  const ChooseAccountScreen({super.key});

  @override
  State<ChooseAccountScreen> createState() => _ChooseAccountScreenState();
}

class _ChooseAccountScreenState extends State<ChooseAccountScreen> {
  int _selectedRole = 2; // 1 = Host, 2 = Guest

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegistrationCubit>(
      create: (_) => getIt<RegistrationCubit>()..setRole(_selectedRole),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            backgroundColor: Colors.white,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.h),
                  Text(
                    'Choose Your Account',
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Select Your Account Type To Continue Your Journey',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Expanded(
                        child: _AccountCard(
                          title: 'Host',
                          subtitle: 'Rent Out Your Property',
                          svgPath: 'assets/images/host.svg',
                          selected: _selectedRole == 1,
                          onTap: () {
                            setState(() => _selectedRole = 1);
                            context.read<RegistrationCubit>().setRole(1);
                            _goNext(context);
                          },
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: _AccountCard(
                          title: 'Guest',
                          subtitle: 'Book Any Property To Stay',
                          svgPath: 'assets/images/Guest.svg',
                          selected: _selectedRole == 2,
                          onTap: () {
                            setState(() => _selectedRole = 2);
                            context.read<RegistrationCubit>().setRole(2);
                            _goNext(context);
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 350.h),
                  CustomButton(
                    text: 'Continue As Visitor',
                    backgroundColor: Colors.grey[100],
                    textColor: AppColors.textPrimary,
                    onPressed: () {
                      _goNext(context);
                    },
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _goNext(BuildContext context) {
    final cubit = context.read<RegistrationCubit>();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: const CreateAccountScreen(),
        ),
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String svgPath;
  final bool selected;
  final VoidCallback onTap;

  const _AccountCard({
    required this.title,
    required this.subtitle,
    required this.svgPath,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: selected ? const Color(0xFFED1C24) : Colors.grey.shade300,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(svgPath, width: 60.w, height: 60.w),
            SizedBox(height: 12.h),
            Text(
              title,
              style: AppTextStyles.h4.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 9.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
