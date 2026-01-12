

import 'package:brain_box/src/core/utils/enums.dart';

/// Extension methods for `FormzStatus` to check different states.
extension FormzStatusExtension on FormzStatus {
  bool get isPure => this == FormzStatus.pure; // Checks if the status is pure.
  bool get isLoading =>
      this == FormzStatus.loading; // Checks if the status is loading.
  bool get isPureLoading => (this == FormzStatus.pure) || (this == FormzStatus.loading); // Checks if the status is pure.
  bool get isSuccess =>
      this == FormzStatus.success; // Checks if the status is success.
  bool get isFailed =>
      this == FormzStatus.failed; // Checks if the status is failed.
}
