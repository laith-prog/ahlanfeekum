import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/property_creation_result.dart';

part 'property_creation_result_model.g.dart';

@JsonSerializable()
class PropertyCreationResultModel {
  @JsonKey(name: 'success')
  final bool success;

  @JsonKey(name: 'data')
  final PropertyDataModel? data;

  @JsonKey(name: 'message')
  final String? message;

  const PropertyCreationResultModel({
    required this.success,
    this.data,
    this.message,
  });

  factory PropertyCreationResultModel.fromJson(Map<String, dynamic> json) =>
      _$PropertyCreationResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyCreationResultModelToJson(this);

  PropertyCreationResult toEntity() {
    return PropertyCreationResult(
      success: success,
      propertyId: data?.id,
      message: message,
    );
  }
}

@JsonSerializable()
class PropertyDataModel {
  @JsonKey(name: 'id')
  final String id;

  const PropertyDataModel({required this.id});

  factory PropertyDataModel.fromJson(Map<String, dynamic> json) =>
      _$PropertyDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyDataModelToJson(this);
}
