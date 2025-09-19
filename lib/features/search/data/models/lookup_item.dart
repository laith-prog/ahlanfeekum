import 'package:json_annotation/json_annotation.dart';

part 'lookup_item.g.dart';

@JsonSerializable()
class LookupItem {
  final String id;
  final String displayName;

  const LookupItem({
    required this.id,
    required this.displayName,
  });

  factory LookupItem.fromJson(Map<String, dynamic> json) =>
      _$LookupItemFromJson(json);

  Map<String, dynamic> toJson() => _$LookupItemToJson(this);
}

@JsonSerializable()
class LookupResponse {
  final List<LookupItem> items;
  final int totalCount;

  const LookupResponse({
    required this.items,
    required this.totalCount,
  });

  factory LookupResponse.fromJson(Map<String, dynamic> json) =>
      _$LookupResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LookupResponseToJson(this);
}

