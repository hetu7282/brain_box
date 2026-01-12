extension ApiImageExtension on String {
  String toApiImage() {
    return isEmpty ? '' : '${Endpoints.baseUrl}$this';
  }
}

class Endpoints {
  static const String baseUrl = 'http://13.203.6.92:6006'; // Testing server
  static const String webSocketUrl = 'ws://13.203.6.92:6006'; // Testing server

  // ****************************************** Auth ****************************************** //

  static const String login = '$baseUrl/api/v1/auth/login/';
  static const String register = '$baseUrl/api/v1/auth/register/customer/';
  static const String socialLogin = '$baseUrl/api/v1/auth/social-web-login/';
  static const String addReferral = '$baseUrl/api/v1/auth/referral/add/';
  static const String sendOtp = '$baseUrl/api/v1/auth/send-otp/';
  static const String verifyOtp = '$baseUrl/api/v1/auth/verify-otp/';
  static const String forgotPassword =
      '$baseUrl/api/v1/auth/forgot-password/reset/';
  static const String getUserProfile = '$baseUrl/api/v1/auth/customer-profile/';
  static const String updateProfile =
      '$baseUrl/api/v1/auth/update/customer-profile/';
  static const String changePassword = '$baseUrl/api/v1/auth/change-password/';
  static const String deleteAccount = '$baseUrl/api/v1/auth/delete-account/';

}
