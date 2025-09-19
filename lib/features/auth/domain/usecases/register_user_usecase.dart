import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/register_user_request.dart';
import '../repositories/auth_repository.dart';

class RegisterUserUseCase {
  final AuthRepository repository;
  RegisterUserUseCase(this.repository);

  Future<Either<Failure, String>> call(RegisterUserRequest request) {
    return repository.registerUser(request);
  }
}
