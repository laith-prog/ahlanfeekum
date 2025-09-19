import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String? profileImage;
  final bool isEmailVerified;
  final bool isPhoneVerified;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.profileImage,
    required this.isEmailVerified,
    required this.isPhoneVerified,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    phone,
    profileImage,
    isEmailVerified,
    isPhoneVerified,
  ];
}
