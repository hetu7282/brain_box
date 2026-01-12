extension StringExtension on String {
  /// Converts the string to capitalize
  String toCapitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  /// Converts the string to uppercase
  String toUpperCaseString() {
    return toUpperCase();
  }

  /// Converts the string to lowercase
  String toLowerCaseString() {
    return toLowerCase();
  }

  /// Converts the string to camelCase format
  String toCamelCase() {
    if (isEmpty) return this;
    List<String> words = split(
      RegExp(r'[^a-zA-Z0-9]+'),
    ).where((word) => word.isNotEmpty).toList();
    String firstWord = words.first.toLowerCase();
    String restWords = words.skip(1).map((word) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join();
    return firstWord + restWords;
  }

  String maskEmail() {
    int atIndex = indexOf('@');
    if (atIndex == -1) return this;

    String localPart = substring(0, atIndex);
    String domainPart = substring(atIndex);

    String maskedLocal = localPart.length > 1
        ? localPart[0] + '*' * (localPart.length - 1)
        : localPart;

    return maskedLocal + domainPart;
  }
}

extension DoubleExtensions on double {
  String toCleanString({int fractionDigits = 2}) {
    if (this == toInt()) {
      return toInt().toString();
    } else {
      return toStringAsFixed(
        fractionDigits,
      ).replaceFirst(RegExp(r'\.?0+$'), '');
    }
  }
}
