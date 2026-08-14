import 'package:freezed_annotation/freezed_annotation.dart';

import '../errors/failure.dart';

part 'api_result.freezed.dart';

@freezed
sealed class ApiResult<T> with _$ApiResult<T> {
  const factory ApiResult.success(T data) = Success<T>;
  const factory ApiResult.failure(Failure failure) = FailureResult<T>;

  const ApiResult._();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is FailureResult<T>;

  T? get dataOrNull => switch (this) {
        Success<T>(data: final d) => d,
        FailureResult<T>() => null,
      };

  Failure? get failureOrNull => switch (this) {
        Success<T>() => null,
        FailureResult<T>(failure: final f) => f,
      };

  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) =>
      switch (this) {
        Success<T>(data: final d) => success(d),
        FailureResult<T>(failure: final f) => failure(f),
      };
}
