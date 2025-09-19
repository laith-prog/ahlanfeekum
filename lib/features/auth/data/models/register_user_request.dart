class RegisterUserRequest {
  final String? profilePhotoPath; // local file path, optional
  final String name;
  final String latitude;
  final String longitude;
  final int roleId; // 1 Host, 2 Guest
  final String address;
  final String phoneNumber;
  final bool isSuperHost;
  final String password;
  final String email;

  const RegisterUserRequest({
    this.profilePhotoPath,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.roleId,
    required this.address,
    required this.phoneNumber,
    required this.isSuperHost,
    required this.password,
    required this.email,
  });
}
