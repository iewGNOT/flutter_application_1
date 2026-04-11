import '../error/app_failure.dart';

sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(AppFailure failure) onFailure,
  }) {
    return switch (this) {
      Success<T>(:final value) => onSuccess(value),
      Failure<T>(:final failure) => onFailure(failure),
    };
  }

  Result<R> map<R>(R Function(T value) mapper) {
    return switch (this) {
      Success<T>(:final value) => Success(mapper(value)),
      Failure<T>(:final failure) => Failure<R>(failure),
    };
  }

  T? get valueOrNull {
    return switch (this) {
      Success<T>(:final value) => value,
      Failure<T>() => null,
    };
  }

  AppFailure? get failureOrNull {
    return switch (this) {
      Success<T>() => null,
      Failure<T>(:final failure) => failure,
    };
  }
}

final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;
}

final class Failure<T> extends Result<T> {
  const Failure(this.failure);

  final AppFailure failure;
}

final class Unit {
  const Unit();
}

const unit = Unit();
