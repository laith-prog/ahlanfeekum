// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_creation_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PropertyCreationResultModel _$PropertyCreationResultModelFromJson(
        Map<String, dynamic> json) =>
    PropertyCreationResultModel(
      success: json['success'] as bool,
      data: json['data'] == null
          ? null
          : PropertyDataModel.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$PropertyCreationResultModelToJson(
        PropertyCreationResultModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'message': instance.message,
    };

PropertyDataModel _$PropertyDataModelFromJson(Map<String, dynamic> json) =>
    PropertyDataModel(
      id: json['id'] as String,
    );

Map<String, dynamic> _$PropertyDataModelToJson(PropertyDataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
    };
