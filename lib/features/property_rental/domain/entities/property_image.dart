import 'package:equatable/equatable.dart';

class PropertyImage extends Equatable {
  final String propertyId;
  final String imagePath;
  final int order;
  final bool isActive;
  final bool isPrimary;

  const PropertyImage({
    required this.propertyId,
    required this.imagePath,
    required this.order,
    required this.isActive,
    required this.isPrimary,
  });

  @override
  List<Object?> get props => [
    propertyId,
    imagePath,
    order,
    isActive,
    isPrimary,
  ];

  PropertyImage copyWith({
    String? propertyId,
    String? imagePath,
    int? order,
    bool? isActive,
    bool? isPrimary,
  }) {
    return PropertyImage(
      propertyId: propertyId ?? this.propertyId,
      imagePath: imagePath ?? this.imagePath,
      order: order ?? this.order,
      isActive: isActive ?? this.isActive,
      isPrimary: isPrimary ?? this.isPrimary,
    );
  }
}
