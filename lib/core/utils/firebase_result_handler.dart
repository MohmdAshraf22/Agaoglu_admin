abstract class Result<T> {
  const Result();

  factory Result.success(T data) = Success<T>;
  factory Result.error(Exception error) = Error<T>;
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Error<T> extends Result<T> {
  final Exception exception;
  const Error(this.exception);
}
