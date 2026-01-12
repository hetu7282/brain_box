// Abstract class representing a general failure with status code and message
abstract class Failure {
  final int statusCode;
  final String message;

  Failure(this.statusCode, this.message);

  // Factory constructor for no internet failure
  factory Failure.noInternet() =>
      Failure.failure(500, 'No internet, check your connection.');

  // Factory constructor that returns a specific failure subclass based on status code
  factory Failure.failure(int statusCode, [String? customMessage]) {
    switch (statusCode) {
      case 400:
        return BadRequestFailure(
          customMessage ?? 'Unauthorized: Authentication is required and has failed.',
        );
      case 401:
        return UnauthorizedFailure(
          customMessage ?? 'Unauthorized: Authentication is required and has failed.',
        );
      case 403:
        return ForbiddenFailure(
          customMessage ?? 'Forbidden: You do not have permission to access this resource.',
        );
      case 404:
        return NotFoundFailure(
          customMessage ?? 'Not Found: The requested resource could not be found.',
        );
      case 405:
        return MethodNotAllowedFailure(
          customMessage ?? 'Method Not Allowed: This method is not supported.',
        );
      case 408:
        return RequestTimeoutFailure(
          customMessage ?? 'Request Timeout: Server timed out waiting for the request.',
        );
      case 423:
        return LockedResourceFailure(
          customMessage ?? 'Locked: The resource is currently locked.',
        );
      case 500:
        return InternalServerErrorFailure(
          customMessage ?? 'Internal Server Error: Something went wrong.',
        );
      case 502:
        return BadGatewayFailure(
          customMessage ?? 'Bad Gateway: Received invalid response from upstream server.',
        );
      case 503:
        return ServiceUnavailableFailure(
          customMessage ?? 'Service Unavailable: The server is temporarily overloaded or down.',
        );
      case 504:
        return GatewayTimeoutFailure(
          customMessage ?? 'Gateway Timeout: The server didn’t receive a response in time.',
        );
      default:
        return InternalServerErrorFailure(
          customMessage ?? 'Unknown error occurred. Please try again later.',
        );
    }
  }

  @override
  String toString() => 'Failure(statusCode: $statusCode, message: $message)';
}

// Specific failure classes for different HTTP error codes

class BadRequestFailure extends Failure {
  BadRequestFailure(String customMessage) : super(400, customMessage);
}

class UnauthorizedFailure extends Failure {
  UnauthorizedFailure(String customMessage) : super(401, customMessage);
}

class ForbiddenFailure extends Failure {
  ForbiddenFailure(String customMessage) : super(403, customMessage);
}

class NotFoundFailure extends Failure {
  NotFoundFailure(String customMessage) : super(404, customMessage);
}

class MethodNotAllowedFailure extends Failure {
  MethodNotAllowedFailure(String customMessage) : super(405, customMessage);
}

class RequestTimeoutFailure extends Failure {
  RequestTimeoutFailure(String customMessage) : super(408, customMessage);
}

class LockedResourceFailure extends Failure {
  LockedResourceFailure(String customMessage) : super(423, customMessage);
}

class InternalServerErrorFailure extends Failure {
  InternalServerErrorFailure(String customMessage) : super(500, customMessage);
}

class BadGatewayFailure extends Failure {
  BadGatewayFailure(String customMessage) : super(502, customMessage);
}

class ServiceUnavailableFailure extends Failure {
  ServiceUnavailableFailure(String customMessage) : super(503, customMessage);
}

class GatewayTimeoutFailure extends Failure {
  GatewayTimeoutFailure(String customMessage) : super(504, customMessage);
}
