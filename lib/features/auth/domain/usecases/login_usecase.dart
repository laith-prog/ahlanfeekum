import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, AuthResult>> call({
    required String phoneOrEmail,
    required String password,
  }) async {
    return await repository.login(
      phoneOrEmail: phoneOrEmail,
      password: password,
    );
  }
}
