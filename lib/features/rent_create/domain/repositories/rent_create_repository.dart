import '../entities/rent_create_entities.dart';
import '../../data/models/property_form_data.dart';

abstract class RentCreateRepository {
  Future<PropertyCreationResult> createPropertyStepOne(PropertyFormData formData);
  Future<PropertyCreationResult> createPropertyStepTwo(PropertyFormData formData);
  Future<PropertyCreationResult> addAvailability(PropertyFormData formData);
  Future<PropertyCreationResult> uploadImages(PropertyFormData formData);
  Future<PropertyCreationResult> setPrice(PropertyFormData formData);
}
