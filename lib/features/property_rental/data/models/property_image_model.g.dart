// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_image_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PropertyImageModel _$PropertyImageModelFromJson(Map<String, dynamic> json) =>
    PropertyImageModel(
      propertyId: json['propertyId'] as String,
      imagePath: json['image'] as String,
      order: (json['order'] as num).toInt(),
      isActive: json['isActive'] as bool,
      isPrimary: json['isPrimary'] as bool? ?? false,
    );

Map<String, dynamic> _$PropertyImageModelToJson(PropertyImageModel instance) =>
    <String, dynamic>{
      'propertyId': instance.propertyId,
      'image': instance.imagePath,
      'order': instance.order,
      'isActive': instance.isActive,
      'isPrimary': instance.isPrimary,
    };
