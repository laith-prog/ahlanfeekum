// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:ahlanfeekum/features/auth/presentation/pages/welcome_splash_screen.dart';
import 'package:ahlanfeekum/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ahlanfeekum/features/auth/presentation/bloc/auth_state.dart';
import 'package:ahlanfeekum/features/auth/presentation/bloc/auth_event.dart';

class InitialSplashScreen extends StatefulWidget {
  const InitialSplashScreen({super.key});

  @override
  State<InitialSplashScreen> createState() => _InitialSplashScreenState();
}

class _InitialSplashScreenState extends State<InitialSplashScreen> {
  @override
  void initState() {
    super.initState();
    // Ask AuthBloc to check persisted auth status
    context.read<AuthBloc>().add(const CheckAuthStatusEvent());
  }

  void _goTo(BuildContext context, Widget page) {
    if (!mounted) return;
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          current is AuthAuthenticated ||
          current is AuthUnauthenticated ||
          current is AuthError,
      listener: (context, state) async {
        // Keep a short splash delay
        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return;
        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(context, '/main-navigation');
        } else {
          _goTo(context, const WelcomeSplashScreen());
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo from assets
              Image.asset('assets/icons/logo.png', width: 198.w, height: 108.w),
            ],
          ),
        ),
      ),
    );
  }
}
