import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<Either<Failure, AuthResult>> call({
    required String email,
    required String otp,
  }) async {
    return await repository.verifyOtp(email: email, otp: otp);
  }
}
