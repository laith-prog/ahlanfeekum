import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_property_step_one_usecase.dart';
import '../../domain/usecases/update_property_location_usecase.dart';
import '../../domain/usecases/add_property_availability_usecase.dart';
import '../../domain/usecases/upload_property_images_usecase.dart';
import '../../domain/usecases/set_property_price_usecase.dart';
import 'property_rental_event.dart';
import 'property_rental_state.dart';

class PropertyRentalBloc
    extends Bloc<PropertyRentalEvent, PropertyRentalState> {
  final CreatePropertyStepOneUseCase createPropertyStepOneUseCase;
  final UpdatePropertyLocationUseCase updatePropertyLocationUseCase;
  final AddPropertyAvailabilityUseCase addPropertyAvailabilityUseCase;
  final UploadPropertyImagesUseCase uploadPropertyImagesUseCase;
  final SetPropertyPriceUseCase setPropertyPriceUseCase;

  String? _currentPropertyId;

  PropertyRentalBloc({
    required this.createPropertyStepOneUseCase,
    required this.updatePropertyLocationUseCase,
    required this.addPropertyAvailabilityUseCase,
    required this.uploadPropertyImagesUseCase,
    required this.setPropertyPriceUseCase,
  }) : super(const PropertyRentalInitial()) {
    on<CreatePropertyStepOneEvent>(_onCreatePropertyStepOne);
    on<UpdatePropertyLocationEvent>(_onUpdatePropertyLocation);
    on<AddPropertyAvailabilityEvent>(_onAddPropertyAvailability);
    on<UploadPropertyImagesEvent>(_onUploadPropertyImages);
    on<SetPropertyPriceEvent>(_onSetPropertyPrice);
    on<CompletePropertyCreationEvent>(_onCompletePropertyCreation);
    on<ResetPropertyRentalEvent>(_onResetPropertyRental);
  }

  Future<void> _onCreatePropertyStepOne(
    CreatePropertyStepOneEvent event,
    Emitter<PropertyRentalState> emit,
  ) async {
    emit(const PropertyRentalLoading(message: 'Creating property...'));

    final result = await createPropertyStepOneUseCase(event.property);

    await result.fold<Future<void>>(
      (failure) async {
        if (emit.isDone) return;
        emit(PropertyRentalError(message: failure.message));
      },
      (success) async {
        if (emit.isDone) return;
        _currentPropertyId = success.propertyId;
        emit(
          PropertyStepOneCompleted(result: success, property: event.property),
        );
      },
    );
  }

  Future<void> _onUpdatePropertyLocation(
    UpdatePropertyLocationEvent event,
    Emitter<PropertyRentalState> emit,
  ) async {
    emit(const PropertyRentalLoading(message: 'Updating location...'));

    final propertyId = event.propertyId.isNotEmpty
        ? event.propertyId
        : _currentPropertyId;

    if (propertyId == null) {
      emit(
        const PropertyRentalError(
          message: 'Property ID not found. Please restart the process.',
        ),
      );
      return;
    }

    final result = await updatePropertyLocationUseCase(
      propertyId: propertyId,
      address: event.address,
      streetAndBuildingNumber: event.streetAndBuildingNumber,
      landMark: event.landMark,
    );

    await result.fold<Future<void>>(
      (failure) async {
        if (emit.isDone) return;
        emit(PropertyRentalError(message: failure.message));
      },
      (success) async {
        if (emit.isDone) return;
        emit(PropertyLocationUpdated(result: success));
      },
    );
  }

  Future<void> _onAddPropertyAvailability(
    AddPropertyAvailabilityEvent event,
    Emitter<PropertyRentalState> emit,
  ) async {
    emit(const PropertyRentalLoading(message: 'Adding availability...'));

    final propertyId = event.propertyId.isNotEmpty
        ? event.propertyId
        : _currentPropertyId;

    if (propertyId == null) {
      emit(
        const PropertyRentalError(
          message: 'Property ID not found. Please restart the process.',
        ),
      );
      return;
    }

    final result = await addPropertyAvailabilityUseCase(
      propertyId: propertyId,
      availabilities: event.availabilities,
    );

    await result.fold<Future<void>>(
      (failure) async {
        if (emit.isDone) return;
        emit(PropertyRentalError(message: failure.message));
      },
      (success) async {
        if (emit.isDone) return;
        emit(PropertyAvailabilityAdded(result: success));
      },
    );
  }

  Future<void> _onUploadPropertyImages(
    UploadPropertyImagesEvent event,
    Emitter<PropertyRentalState> emit,
  ) async {
    emit(const PropertyRentalLoading(message: 'Uploading images...'));

    final propertyId = event.propertyId.isNotEmpty
        ? event.propertyId
        : _currentPropertyId;

    if (propertyId == null) {
      emit(
        const PropertyRentalError(
          message: 'Property ID not found. Please restart the process.',
        ),
      );
      return;
    }

    final result = await uploadPropertyImagesUseCase(
      propertyId: propertyId,
      images: event.images,
    );

    await result.fold<Future<void>>(
      (failure) async {
        if (emit.isDone) return;
        emit(PropertyRentalError(message: failure.message));
      },
      (success) async {
        if (emit.isDone) return;
        emit(PropertyImagesUploaded(result: success));
      },
    );
  }

  Future<void> _onSetPropertyPrice(
    SetPropertyPriceEvent event,
    Emitter<PropertyRentalState> emit,
  ) async {
    emit(const PropertyRentalLoading(message: 'Setting price...'));

    final propertyId = event.propertyId.isNotEmpty
        ? event.propertyId
        : _currentPropertyId;

    if (propertyId == null) {
      emit(
        const PropertyRentalError(
          message: 'Property ID not found. Please restart the process.',
        ),
      );
      return;
    }

    final result = await setPropertyPriceUseCase(
      propertyId: propertyId,
      pricePerNight: event.pricePerNight,
    );

    await result.fold<Future<void>>(
      (failure) async {
        if (emit.isDone) return;
        emit(PropertyRentalError(message: failure.message));
      },
      (success) async {
        if (emit.isDone) return;
        emit(PropertyPriceSet(result: success));
      },
    );
  }

  Future<void> _onCompletePropertyCreation(
    CompletePropertyCreationEvent event,
    Emitter<PropertyRentalState> emit,
  ) async {
    emit(
      const PropertyRentalLoading(message: 'Finalizing property creation...'),
    );

    try {
      // Step 1: Create property
      final step1Result = await createPropertyStepOneUseCase(event.property);

      await step1Result.fold<Future<void>>(
        (failure) async {
          if (emit.isDone) return;
          emit(
            PropertyRentalError(
              message: 'Failed to create property: ${failure.message}',
            ),
          );
        },
        (step1Success) async {
          if (emit.isDone) return;

          final propertyId = step1Success.propertyId;
          if (propertyId == null) {
            emit(
              const PropertyRentalError(
                message: 'Property creation failed: No property ID returned',
              ),
            );
            return;
          }

          _currentPropertyId = propertyId;

          // Step 2: Update location
          final step2Result = await updatePropertyLocationUseCase(
            propertyId: propertyId,
            address: event.property.address,
            streetAndBuildingNumber: event.property.streetAndBuildingNumber,
            landMark: event.property.landMark,
          );

          await step2Result.fold<Future<void>>(
            (failure) async {
              if (emit.isDone) return;
              emit(
                PropertyRentalError(
                  message: 'Failed to update location: ${failure.message}',
                ),
              );
            },
            (step2Success) async {
              if (emit.isDone) return;

              // Step 3: Add availability
              if (event.availabilities.isNotEmpty) {
                final step3Result = await addPropertyAvailabilityUseCase(
                  propertyId: propertyId,
                  availabilities: event.availabilities,
                );

                await step3Result.fold<Future<void>>(
                  (failure) async {
                    if (emit.isDone) return;
                    emit(
                      PropertyRentalError(
                        message:
                            'Failed to add availability: ${failure.message}',
                      ),
                    );
                  },
                  (step3Success) async {
                    if (emit.isDone) return;
                    await _uploadImagesAndSetPrice(propertyId, event, emit);
                  },
                );
              } else {
                await _uploadImagesAndSetPrice(propertyId, event, emit);
              }
            },
          );
        },
      );
    } catch (e) {
      if (emit.isDone) return;
      emit(PropertyRentalError(message: 'Unexpected error: $e'));
    }
  }

  Future<void> _uploadImagesAndSetPrice(
    String propertyId,
    CompletePropertyCreationEvent event,
    Emitter<PropertyRentalState> emit,
  ) async {
    // Step 4: Upload images
    if (event.images.isNotEmpty) {
      final step4Result = await uploadPropertyImagesUseCase(
        propertyId: propertyId,
        images: event.images,
      );

      await step4Result.fold<Future<void>>(
        (failure) async {
          if (emit.isDone) return;
          emit(
            PropertyRentalError(
              message: 'Failed to upload images: ${failure.message}',
            ),
          );
        },
        (step4Success) async {
          if (emit.isDone) return;
          await _setFinalPrice(propertyId, event, emit);
        },
      );
    } else {
      await _setFinalPrice(propertyId, event, emit);
    }
  }

  Future<void> _setFinalPrice(
    String propertyId,
    CompletePropertyCreationEvent event,
    Emitter<PropertyRentalState> emit,
  ) async {
    // Step 5: Set price
    final step5Result = await setPropertyPriceUseCase(
      propertyId: propertyId,
      pricePerNight: event.property.pricePerNight,
    );

    await step5Result.fold<Future<void>>(
      (failure) async {
        if (emit.isDone) return;
        emit(
          PropertyRentalError(
            message: 'Failed to set price: ${failure.message}',
          ),
        );
      },
      (step5Success) async {
        if (emit.isDone) return;
        emit(
          PropertyCreationCompleted(
            propertyId: propertyId,
            message: 'Property created successfully!',
          ),
        );
      },
    );
  }

  Future<void> _onResetPropertyRental(
    ResetPropertyRentalEvent event,
    Emitter<PropertyRentalState> emit,
  ) async {
    _currentPropertyId = null;
    emit(const PropertyRentalInitial());
  }

  String? get currentPropertyId => _currentPropertyId;
}
