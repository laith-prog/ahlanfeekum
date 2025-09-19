import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../theming/text_styles.dart';
import '../../../../theming/colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/phone_field.dart';
import '../cubit/registration_cubit.dart';
import 'secure_account_screen.dart';

class SetProfileScreen extends StatefulWidget {
  const SetProfileScreen({super.key});

  @override
  State<SetProfileScreen> createState() => _SetProfileScreenState();
}

class _SetProfileScreenState extends State<SetProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<RegistrationCubit>();
    nameController = TextEditingController(text: cubit.state.name);
    emailController = TextEditingController(text: cubit.state.email);
    addressController = TextEditingController(text: cubit.state.address);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _getImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _getImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1000,
        maxHeight: 1000,
      );

      if (image != null) {
        if (mounted) {
          context.read<RegistrationCubit>().setProfilePhoto(image.path);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Photo selected successfully!')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegistrationCubit>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),
            Row(
              children: [
                // Profile Photo Picker
                BlocBuilder<RegistrationCubit, RegistrationState>(
                  builder: (context, state) {
                    return GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 56.w,
                        height: 56.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade300),
                          image: state.profilePhotoPath != null
                              ? DecorationImage(
                                  image: FileImage(
                                    File(state.profilePhotoPath!),
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: Stack(
                          children: [
                            if (state.profilePhotoPath == null)
                              const Center(
                                child: Icon(
                                  Icons.person_outline,
                                  color: Colors.grey,
                                ),
                              ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 20.w,
                                height: 20.w,
                                decoration: BoxDecoration(
                                  color: state.profilePhotoPath == null
                                      ? const Color(0xFFED1C24)
                                      : Colors.green,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  state.profilePhotoPath == null
                                      ? Icons.add
                                      : Icons.check,
                                  color: Colors.white,
                                  size: 12.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Set Your Profile',
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Tap to add photo',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Text(
              'Complete Your Profile Details And Continue With Us.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 20.h),

            // Name
            CustomTextField(
              controller: nameController,
              labelText: 'Your Name',
              hintText: 'FullName',
              onChanged: cubit.setName,
            ),
            SizedBox(height: 14.h),

            // Conditionally show Email or Phone based on registration method
            BlocBuilder<RegistrationCubit, RegistrationState>(
              builder: (context, state) {
                final needsEmail =
                    state.registrationMethod == RegistrationMethod.phone;
                final needsPhone =
                    state.registrationMethod == RegistrationMethod.email;

                return Column(
                  children: [
                    // Always show email field
                    CustomTextField(
                      controller: emailController,
                      labelText: 'Email Address',
                      hintText: 'Enter Email',
                      keyboardType: TextInputType.emailAddress,
                      onChanged: cubit.setEmail,
                      readOnly:
                          !needsEmail, // Only editable if user registered with phone
                    ),
                    SizedBox(height: 14.h),

                    // Show phone field if user registered with email
                    if (needsPhone) ...[
                      PhoneField(
                        labelText: 'Phone Number',
                        hintText: 'Enter phone number',
                        readOnly: false,
                      ),
                      SizedBox(height: 14.h),
                    ],
                  ],
                );
              },
            ),

            // Address
            CustomTextField(
              controller: addressController,
              labelText: 'Address',
              hintText: 'Your Address',
              suffixIcon: const Icon(Icons.my_location_outlined),
              onChanged: cubit.setAddress,
            ),

            SizedBox(height: 40.h),

            CustomButton(
              text: 'Next',
              backgroundColor: const Color(0xFFED1C24),
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider<RegistrationCubit>.value(
                      value: context.read<RegistrationCubit>(),
                      child: const SecureAccountScreen(),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
