/// Formats the provided email by partially masking the username.
String formatEmail(String email) {
  final RegExp emailRegExp = RegExp(r'^(.+?)(@.+)$');
  if (emailRegExp.hasMatch(email)) {
    final match = emailRegExp.firstMatch(email);
    final username = match?.group(1) ?? '';
    final domain = match?.group(2) ?? '';
    String formattedUsername =
        username.length > 2
            ? username.substring(0, 2) + '*' * (username.length - 2)
            : username;
    return formattedUsername + domain;
  }
  return email;
}
