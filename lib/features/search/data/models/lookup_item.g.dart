// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lookup_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LookupItem _$LookupItemFromJson(Map<String, dynamic> json) => LookupItem(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
    );

Map<String, dynamic> _$LookupItemToJson(LookupItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
    };

LookupResponse _$LookupResponseFromJson(Map<String, dynamic> json) =>
    LookupResponse(
      items: (json['items'] as List<dynamic>)
          .map((e) => LookupItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['totalCount'] as num).toInt(),
    );

Map<String, dynamic> _$LookupResponseToJson(LookupResponse instance) =>
    <String, dynamic>{
      'items': instance.items,
      'totalCount': instance.totalCount,
    };
