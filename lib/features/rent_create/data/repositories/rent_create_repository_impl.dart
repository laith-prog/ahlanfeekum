import '../../domain/entities/rent_create_entities.dart';
import '../../domain/repositories/rent_create_repository.dart';
import '../datasources/rent_create_remote_data_source.dart';
import '../models/create_property_request.dart';
import '../models/property_form_data.dart';

class RentCreateRepositoryImpl implements RentCreateRepository {
  final RentCreateRemoteDataSource _remoteDataSource;

  RentCreateRepositoryImpl(this._remoteDataSource);

  @override
  Future<PropertyCreationResult> createPropertyStepOne(PropertyFormData formData) async {
    try {
      final request = CreatePropertyStepOneRequest(
        propertyTitle: formData.propertyTitle!,
        hotelName: formData.propertyTitle, // Using property title as hotel name
        bedrooms: formData.bedrooms,
        bathrooms: formData.bathrooms,
        numberOfBed: formData.numberOfBeds,
        floor: formData.floor,
        maximumNumberOfGuest: formData.maximumNumberOfGuests,
        livingrooms: formData.livingRooms,
        propertyDescription: formData.propertyDescription ?? '',
        hourseRules: formData.houseRules ?? '',
        importantInformation: formData.importantInformation ?? '',
        address: formData.address ?? '',
        streetAndBuildingNumber: formData.streetAndBuildingNumber ?? '',
        landMark: formData.landMark ?? '',
        pricePerNight: formData.pricePerNight ?? 0,
        propertyTypeId: formData.propertyTypeId!,
        governorateId: formData.governorateId!,
        propertyFeatureIds: formData.propertyFeatureIds,
      );

      final response = await _remoteDataSource.createPropertyStepOne(request);
      
      return PropertyCreationResult(
        success: true,
        propertyId: response.id,
        message: 'Property step one created successfully',
      );
    } catch (e) {
      return PropertyCreationResult(
        success: false,
        message: 'Failed to create property: $e',
      );
    }
  }

  @override
  Future<PropertyCreationResult> createPropertyStepTwo(PropertyFormData formData) async {
    try {
      final request = CreatePropertyStepTwoRequest(
        id: formData.propertyId!,
        address: formData.address!,
        streetAndBuildingNumber: formData.streetAndBuildingNumber!,
        landMark: formData.landMark!,
        latitude: (formData.latitude ?? 0).toString(),
        longitude: (formData.longitude ?? 0).toString(),
      );

      final response = await _remoteDataSource.createPropertyStepTwo(request);
      
      return PropertyCreationResult(
        success: true,
        propertyId: response.id,
        message: 'Property step two completed successfully',
      );
    } catch (e) {
      return PropertyCreationResult(
        success: false,
        message: 'Failed to update property location: $e',
      );
    }
  }

  @override
  Future<PropertyCreationResult> addAvailability(PropertyFormData formData) async {
    try {
      final availability = formData.availableDates.map((date) {
        final dateString = date.toIso8601String().split('T')[0]; // YYYY-MM-DD format
        final isAvailable = formData.dateAvailability[date] ?? true;
        
        return PropertyAvailability(
          propertyId: formData.propertyId!,
          date: dateString,
          isAvailable: isAvailable,
          price: formData.pricePerNight ?? 0,
          note: '',
        );
      }).toList();

      final response = await _remoteDataSource.addAvailability(availability);
      
      return PropertyCreationResult(
        success: response.data ?? false,
        message: response.message,
      );
    } catch (e) {
      return PropertyCreationResult(
        success: false,
        message: 'Failed to add availability: $e',
      );
    }
  }

  @override
  Future<PropertyCreationResult> uploadImages(PropertyFormData formData) async {
    try {
      final List<String> uploadedUrls = [];
      
      for (int i = 0; i < formData.selectedImages.length; i++) {
        final image = formData.selectedImages[i];
        final url = await _remoteDataSource.uploadSingleMedia(
          formData.propertyId!,
          image,
          i,
        );
        uploadedUrls.add(url);
      }

      return PropertyCreationResult(
        success: true,
        message: 'Images uploaded successfully',
        data: uploadedUrls,
      );
    } catch (e) {
      return PropertyCreationResult(
        success: false,
        message: 'Failed to upload images: $e',
      );
    }
  }

  @override
  Future<PropertyCreationResult> setPrice(PropertyFormData formData) async {
    try {
      final request = SetPriceRequest(
        propertyId: formData.propertyId!,
        pricePerNight: formData.pricePerNight!,
      );

      final response = await _remoteDataSource.setPrice(request);
      
      return PropertyCreationResult(
        success: response.data ?? false,
        message: response.message,
      );
    } catch (e) {
      return PropertyCreationResult(
        success: false,
        message: 'Failed to set price: $e',
      );
    }
  }
}
