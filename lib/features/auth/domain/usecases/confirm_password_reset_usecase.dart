import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';

class ConfirmPasswordResetUseCase {
  final AuthRepository repository;

  ConfirmPasswordResetUseCase(this.repository);

  Future<Either<Failure, AuthResult>> call({
    required String emailOrPhone,
    required String securityCode,
    required String newPassword,
  }) async {
    return await repository.confirmPasswordReset(
      emailOrPhone: emailOrPhone,
      securityCode: securityCode,
      newPassword: newPassword,
    );
  }
}
