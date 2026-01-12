

// Custom exception class to wrap API failure details


import 'package:brain_box/src/api/failure/failure.dart';

class ApiException implements Exception {
  Failure failure;
  ApiException(this.failure);
}
