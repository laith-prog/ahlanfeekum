import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/property_availability.dart';

part 'property_availability_model.g.dart';

@JsonSerializable()
class PropertyAvailabilityModel {
  @JsonKey(name: 'propertyId')
  final String propertyId;

  @JsonKey(name: 'date')
  final String date;

  @JsonKey(name: 'isAvailable')
  final bool isAvailable;

  @JsonKey(name: 'price')
  final double price;

  @JsonKey(name: 'note')
  final String note;

  const PropertyAvailabilityModel({
    required this.propertyId,
    required this.date,
    required this.isAvailable,
    required this.price,
    required this.note,
  });

  factory PropertyAvailabilityModel.fromJson(Map<String, dynamic> json) =>
      _$PropertyAvailabilityModelFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyAvailabilityModelToJson(this);

  factory PropertyAvailabilityModel.fromEntity(
    PropertyAvailability availability,
  ) {
    return PropertyAvailabilityModel(
      propertyId: availability.propertyId,
      date: availability.date,
      isAvailable: availability.isAvailable,
      price: availability.price,
      note: availability.note,
    );
  }

  PropertyAvailability toEntity() {
    return PropertyAvailability(
      propertyId: propertyId,
      date: date,
      isAvailable: isAvailable,
      price: price,
      note: note,
    );
  }
}
