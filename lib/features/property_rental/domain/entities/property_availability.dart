import 'package:equatable/equatable.dart';

class PropertyAvailability extends Equatable {
  final String propertyId;
  final String date;
  final bool isAvailable;
  final double price;
  final String note;

  const PropertyAvailability({
    required this.propertyId,
    required this.date,
    required this.isAvailable,
    required this.price,
    required this.note,
  });

  @override
  List<Object?> get props => [propertyId, date, isAvailable, price, note];

  PropertyAvailability copyWith({
    String? propertyId,
    String? date,
    bool? isAvailable,
    double? price,
    String? note,
  }) {
    return PropertyAvailability(
      propertyId: propertyId ?? this.propertyId,
      date: date ?? this.date,
      isAvailable: isAvailable ?? this.isAvailable,
      price: price ?? this.price,
      note: note ?? this.note,
    );
  }
}
