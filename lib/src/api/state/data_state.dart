


import 'package:brain_box/src/api/failure/failure.dart';

/// Abstract class to represent either a success or failure state for API responses
abstract class DataState<T> {
  final T? _data;
  final Failure? _failure;

  /// Private constructor to initialize either data or failure
  DataState._({T? data, Failure? failure}) : _data = data, _failure = failure;

  /// Getter to safely access data (throws if null, ensure `isSuccess` before calling)
  T get data => _data!;

  /// Getter to safely access failure (throws if null, ensure `isFailure` before calling)
  Failure get failure => _failure!;

  /// True if data is present
  bool get isSuccess => _data != null;

  /// True if failure is present
  bool get isFailure => _failure != null;

  /// Factory to create a success state
  factory DataState.success(T data) = DataSuccess<T>;

  /// Factory to create a failure state
  factory DataState.failure(Failure failure) = DataFailure<T>;
}

/// Represents a successful response state
class DataSuccess<T> extends DataState<T> {
  DataSuccess(T data) : super._(data: data);
}

/// Represents a failed response state
class DataFailure<T> extends DataState<T> {
  DataFailure(Failure failure) : super._(failure: failure);
}
