import '../entities/rent_create_entities.dart';
import '../repositories/rent_create_repository.dart';
import '../../data/models/property_form_data.dart';

class CreatePropertyStepOneUseCase {
  final RentCreateRepository _repository;

  CreatePropertyStepOneUseCase(this._repository);

  Future<PropertyCreationResult> call(PropertyFormData formData) async {
    return await _repository.createPropertyStepOne(formData);
  }
}

class CreatePropertyStepTwoUseCase {
  final RentCreateRepository _repository;

  CreatePropertyStepTwoUseCase(this._repository);

  Future<PropertyCreationResult> call(PropertyFormData formData) async {
    return await _repository.createPropertyStepTwo(formData);
  }
}

class AddAvailabilityUseCase {
  final RentCreateRepository _repository;

  AddAvailabilityUseCase(this._repository);

  Future<PropertyCreationResult> call(PropertyFormData formData) async {
    return await _repository.addAvailability(formData);
  }
}

class UploadImagesUseCase {
  final RentCreateRepository _repository;

  UploadImagesUseCase(this._repository);

  Future<PropertyCreationResult> call(PropertyFormData formData) async {
    return await _repository.uploadImages(formData);
  }
}

class SetPriceUseCase {
  final RentCreateRepository _repository;

  SetPriceUseCase(this._repository);

  Future<PropertyCreationResult> call(PropertyFormData formData) async {
    return await _repository.setPrice(formData);
  }
}
