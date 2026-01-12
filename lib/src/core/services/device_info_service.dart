import 'package:device_info_plus/device_info_plus.dart'; // Import DeviceInfoPlugin package
import 'dart:io'; // Import platform to check for Android devices

/// Service to fetch device information, specifically for Android SDK version.
class DeviceInfoService {
  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin(); // Instance of DeviceInfoPlugin to fetch device info

  /// Returns the SDK version of the Android device.
  /// Throws an exception if not an Android device.
  static Future<int> getSdk() async {
    if (!Platform.isAndroid) { // Check if the platform is Android
      throw Exception('This function is only supported on Android devices.'); // Throw exception if not Android
    }
    AndroidDeviceInfo androidDeviceInfo = await _deviceInfoPlugin.androidInfo; // Fetch Android device info
    return androidDeviceInfo.version.sdkInt; // Return SDK version of Android
  }
}
