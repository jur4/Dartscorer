class ValidationUtils {
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 30;

  /// Validates username
  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Benutzername ist erforderlich';
    }

    final trimmed = value.trim();
    
    if (trimmed.length < minUsernameLength) {
      return 'Benutzername muss mindestens $minUsernameLength Zeichen lang sein';
    }

    if (trimmed.length > maxUsernameLength) {
      return 'Benutzername darf maximal $maxUsernameLength Zeichen lang sein';
    }

    // Check for valid characters (letters, numbers, underscore, hyphen)
    if (!RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(trimmed)) {
      return 'Benutzername darf nur Buchstaben, Zahlen, Unterstriche und Bindestriche enthalten';
    }

    return null;
  }

  /// Validates password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Passwort ist erforderlich';
    }

    if (value.length < minPasswordLength) {
      return 'Passwort muss mindestens $minPasswordLength Zeichen lang sein';
    }

    if (value.length > maxPasswordLength) {
      return 'Passwort darf maximal $maxPasswordLength Zeichen lang sein';
    }

    return null;
  }

  /// Validates password confirmation
  static String? validatePasswordConfirmation(String? value, String? originalPassword) {
    final passwordError = validatePassword(value);
    if (passwordError != null) {
      return passwordError;
    }

    if (value != originalPassword) {
      return 'Passwörter stimmen nicht überein';
    }

    return null;
  }

  /// Validates email
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'E-Mail ist erforderlich';
    }

    final trimmed = value.trim();
    
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(trimmed)) {
      return 'Bitte geben Sie eine gültige E-Mail-Adresse ein';
    }

    return null;
  }

  /// Validates player name
  static String? validatePlayerName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Spielername ist erforderlich';
    }

    final trimmed = value.trim();
    
    if (trimmed.length < 2) {
      return 'Spielername muss mindestens 2 Zeichen lang sein';
    }

    if (trimmed.length > 50) {
      return 'Spielername darf maximal 50 Zeichen lang sein';
    }

    // Allow letters, numbers, spaces, and common special characters
    if (!RegExp(r'^[a-zA-ZäöüßÄÖÜ0-9\s\-_\.]+$').hasMatch(trimmed)) {
      return 'Spielername enthält ungültige Zeichen';
    }

    return null;
  }

  /// Validates score input
  static String? validateScore(String? value, {int? maxValue, int? minValue}) {
    if (value == null || value.trim().isEmpty) {
      return 'Punktzahl ist erforderlich';
    }

    final intValue = int.tryParse(value.trim());
    if (intValue == null) {
      return 'Bitte geben Sie eine gültige Zahl ein';
    }

    if (minValue != null && intValue < minValue) {
      return 'Wert muss mindestens $minValue sein';
    }

    if (maxValue != null && intValue > maxValue) {
      return 'Wert darf maximal $maxValue sein';
    }

    return null;
  }

  /// Validates dart score (0-180)
  static String? validateDartScore(String? value) {
    return validateScore(value, minValue: 0, maxValue: 180);
  }

  /// Validates X01 starting score
  static String? validateX01StartScore(int? value) {
    if (value == null) {
      return 'Startwert ist erforderlich';
    }

    final validScores = [301, 501, 701, 1001];
    if (!validScores.contains(value)) {
      return 'Startwert muss einer der folgenden Werte sein: ${validScores.join(', ')}';
    }

    return null;
  }

  /// Validates set/leg count
  static String? validateSetLegCount(int? value, {required String fieldName}) {
    if (value == null || value < 0) {
      return '$fieldName muss eine positive Zahl sein';
    }

    if (value > 20) {
      return '$fieldName darf maximal 20 sein';
    }

    return null;
  }

  /// Validates required field
  static String? validateRequired(String? value, {required String fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName ist erforderlich';
    }
    return null;
  }

  /// Validates numeric input
  static String? validateNumeric(String? value, {
    required String fieldName,
    double? min,
    double? max,
    bool allowDecimals = false,
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName ist erforderlich';
    }

    final numValue = allowDecimals 
      ? double.tryParse(value.trim())
      : int.tryParse(value.trim())?.toDouble();

    if (numValue == null) {
      return 'Bitte geben Sie eine gültige Zahl für $fieldName ein';
    }

    if (min != null && numValue < min) {
      return '$fieldName muss mindestens $min sein';
    }

    if (max != null && numValue > max) {
      return '$fieldName darf maximal $max sein';
    }

    return null;
  }

  /// Combines multiple validators
  static String? validateWith(String? value, List<String? Function(String?)> validators) {
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) {
        return error;
      }
    }
    return null;
  }

  /// Validates form with multiple fields
  static Map<String, String> validateForm(Map<String, dynamic> data, Map<String, String? Function(dynamic)> validators) {
    final errors = <String, String>{};
    
    for (final entry in validators.entries) {
      final fieldName = entry.key;
      final validator = entry.value;
      final value = data[fieldName];
      
      final error = validator(value);
      if (error != null) {
        errors[fieldName] = error;
      }
    }
    
    return errors;
  }

  /// Checks if form is valid (no errors)
  static bool isFormValid(Map<String, String> errors) {
    return errors.isEmpty;
  }
}