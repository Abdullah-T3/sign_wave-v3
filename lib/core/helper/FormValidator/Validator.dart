class ValidatorHelper {
  static String? isNotEmpty(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }

  static String? isValidEmail(String? value) {
    final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    if (!emailRegex.hasMatch(value!)) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? isValidPassword(String? value) {

    if (value!.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }


  static String? isPasswordConfirmed(String? password, String? retypePassword) {
    if (retypePassword == null || retypePassword.isEmpty) {
      return 'Please confirm your password';
    }
    if (password != retypePassword) {
      return 'Passwords do not match';
    }
    return null;
  }


  static String? isValidPhone(String? value) {
    if (value == null || value.isEmpty) return null; // Let isNotEmpty handle this

    // Regular expression to match:
    // - Starts with 010, 011, 012, or 015
    // - Followed by 8 more digits (making total length 11)
    if (!RegExp(r"^(010|011|012|015)\d{8}$").hasMatch(value)) {
      return 'Enter a valid 11-digit phone number';
    }
    return null;
  }


  static String? Function(String?) combineValidators(List<String? Function(String?)> validators) {
    return (String? value) {
      for (var validator in validators) {
        final result = validator(value);
        if (result != null) return result; // Return first error found
      }
      return null;
    };
  }
}
