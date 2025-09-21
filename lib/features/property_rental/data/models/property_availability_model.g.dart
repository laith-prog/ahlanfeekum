// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_availability_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PropertyAvailabilityModel _$PropertyAvailabilityModelFromJson(
        Map<String, dynamic> json) =>
    PropertyAvailabilityModel(
      propertyId: json['propertyId'] as String,
      date: json['date'] as String,
      isAvailable: json['isAvailable'] as bool,
      price: (json['price'] as num).toDouble(),
      note: json['note'] as String,
    );

Map<String, dynamic> _$PropertyAvailabilityModelToJson(
        PropertyAvailabilityModel instance) =>
    <String, dynamic>{
      'propertyId': instance.propertyId,
      'date': instance.date,
      'isAvailable': instance.isAvailable,
      'price': instance.price,
      'note': instance.note,
    };
