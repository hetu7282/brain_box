import 'dart:async';
import 'dart:io';

import 'package:brain_box/src/api/api_introceptor.dart';
import 'package:brain_box/src/api/exception/api_exception.dart';
import 'package:brain_box/src/api/failure/failure.dart';
import 'package:brain_box/src/core/model/common_model.dart';
import 'package:dio/dio.dart';

class ApiClient {
  static final List<int> _validStatusCode = [400, 401, 403, 423, 404, 409];

  late Dio _dio;
  late ApiInterceptors _apiInterceptors;

  // Constructor to initialize Dio instance and setup interceptors.
  ApiClient() {
    _dio = Dio();
    _apiInterceptors = ApiInterceptors();
    _dio.options = BaseOptions(headers: {'Content-Type': 'application/json'});
    _dio.interceptors.add(_apiInterceptors.interceptorsWrapper);
  }

  // Method to make a GET request.
  Future<dynamic> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
    bool isCheck = true,
  }) async {
    // Call _request to handle the actual HTTP request and error handling.
    Response response = await _request(() async {
      Response response = await _dio.get(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    }, isCheck: isCheck);
    return response.data; // Return the data from the response.
  }

  // Method to make a POST request.
  Future<dynamic> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    bool isCheck = true,
  }) async {
    // Call _request to handle the actual HTTP request and error handling.
    Response response = await _request(() async {
      Response response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    }, isCheck: isCheck);
    return response.data; // Return the data from the response.
  }

  // Method to make a PUT request.
  Future<dynamic> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    bool isCheck = true,
  }) async {
    // Call _request to handle the actual HTTP request and error handling.
    Response response = await _request(() async {
      Response response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    }, isCheck: isCheck);
    return response.data; // Return the data from the response.
  }

  // Method to make a PATCH request.
  Future<dynamic> patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    bool isCheck = true,
  }) async {
    // Call _request to handle the actual HTTP request and error handling.
    Response response = await _request(() async {
      Response response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    }, isCheck: isCheck);
    return response.data; // Return the data from the response.
  }

  // Method to make a DELETE request.
  Future<dynamic> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool isCheck = true,
  }) async {
    // Call _request to handle the actual HTTP request and error handling.
    Response response = await _request(() async {
      Response response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    }, isCheck: isCheck);
    return response.data; // Return the data from the response.
  }

  // Helper method to handle the HTTP request and error handling.
  Future<Response> _request(
    Future<Response> Function() handler, {
    bool isCheck = true,
  }) async {
    try {
      // Execute the request handler.
      Response response = await handler();
      return response; // Return the response.
    } on DioException catch (e) {
      // Handle Dio exceptions (network errors, etc.).
      ApiException exception = _dioExceptionHandle(e, isCheck);
      throw exception; // Throw custom ApiException.
    } on TimeoutException {
      // Handle timeout error.
      throw ApiException(Failure.failure(408));
    } on SocketException {
      // Handle socket error (no network, etc.).
      throw ApiException(Failure.failure(500));
    } catch (e) {
      // Catch any other errors and throw a generic failure.
      throw ApiException(Failure.failure(500));
    }
  }

  // Method to handle Dio exceptions and map them to ApiException.
  ApiException _dioExceptionHandle(DioException exception, bool isCheck) {
    int statusCode = exception.response?.statusCode ?? 500;
    try {
      // Check if the status code is valid.
      if (!_validStatusCode.contains(statusCode)) {
        return ApiException(Failure.failure(500)); // Unknown error.
      }
      final data = exception.response?.data;
      if (data == null) {
        return ApiException(
          Failure.failure(500),
        ); // Unknown error with no data.
      }
      final result = CommonModel.fromMap(data); // Parse error data.
      return ApiException(
        Failure.failure(statusCode, result.message),
      ); // Return ApiException with message.
    } catch (e) {
      // Catch any other exceptions and return a generic failure.
      return ApiException(Failure.failure(500));
    }
  }
}
