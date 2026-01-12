// validators/regex_patterns.dart

// Regular expression for validating email addresses
final RegExp emailRegExp = RegExp(
  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
);

// Regular expression for validating usernames (letters, numbers, and underscores, between 3 and 16 characters)
final RegExp usernameRegExp = RegExp(r'^[a-zA-Z0-9_]{3,16}$');

final RegExp firstNameRegExp = RegExp(
  r'^[a-zA-Z]+$', // Only letters are allowed for first name
);
