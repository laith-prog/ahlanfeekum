class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'field_required';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'invalid_email';
    }

    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'field_required';
    }

    // Remove any non-digit characters
    final cleanPhone = value.replaceAll(RegExp(r'[^\d]'), '');

    // Check if it's a valid phone number (at least 10 digits)
    if (cleanPhone.length < 10) {
      return 'invalid_phone';
    }

    return null;
  }

  static String? validateEmailOrPhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'field_required';
    }

    // Check if it contains @ symbol (email)
    if (value.contains('@')) {
      return validateEmail(value);
    } else {
      return validatePhone(value);
    }
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'field_required';
    }

    if (value.length < 6) {
      return 'password_too_short';
    }

    // Enforce: at least one uppercase, one lowercase, and one non-alphanumeric
    final hasUpper = RegExp(r'[A-Z]').hasMatch(value);
    final hasLower = RegExp(r'[a-z]').hasMatch(value);
    final hasSpecial = RegExp(r'[^A-Za-z0-9]').hasMatch(value);

    if (!hasUpper || !hasLower || !hasSpecial) {
      return "Password must include at least one uppercase (A-Z), one lowercase (a-z), and one special character.";
    }

    return null;
  }

  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'field_required';
    }

    if (value != password) {
      return 'passwords_dont_match';
    }

    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'field_required';
    }

    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }

    return null;
  }

  static String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'field_required';
    }

    if (value.length != 4) {
      return 'invalid_code';
    }

    return null;
  }
}
