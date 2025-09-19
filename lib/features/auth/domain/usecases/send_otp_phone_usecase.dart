import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class SendOtpPhoneUseCase {
  final AuthRepository repository;
  SendOtpPhoneUseCase(this.repository);

  Future<Either<Failure, String>> call(String phone) {
    return repository.sendOtpPhone(phone: phone);
  }
}
