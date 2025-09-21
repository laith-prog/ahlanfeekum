import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/property_image.dart';

part 'property_image_model.g.dart';

@JsonSerializable()
class PropertyImageModel {
  @JsonKey(name: 'propertyId')
  final String propertyId;

  @JsonKey(name: 'image')
  final String imagePath;

  @JsonKey(name: 'order')
  final int order;

  @JsonKey(name: 'isActive')
  final bool isActive;

  @JsonKey(name: 'isPrimary', defaultValue: false)
  final bool isPrimary;

  const PropertyImageModel({
    required this.propertyId,
    required this.imagePath,
    required this.order,
    required this.isActive,
    required this.isPrimary,
  });

  factory PropertyImageModel.fromJson(Map<String, dynamic> json) =>
      _$PropertyImageModelFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyImageModelToJson(this);

  factory PropertyImageModel.fromEntity(PropertyImage image) {
    return PropertyImageModel(
      propertyId: image.propertyId,
      imagePath: image.imagePath,
      order: image.order,
      isActive: image.isActive,
      isPrimary: image.isPrimary,
    );
  }

  PropertyImage toEntity() {
    return PropertyImage(
      propertyId: propertyId,
      imagePath: imagePath,
      order: order,
      isActive: isActive,
      isPrimary: isPrimary,
    );
  }
}
