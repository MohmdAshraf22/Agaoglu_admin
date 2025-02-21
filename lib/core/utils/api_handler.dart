abstract class Result<T> {
  const Result();

  factory Result.success(T data) = Success<T>;

  factory Result.error(String? error) = Error<T>;
}

class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);
}

class Error<T> extends Result<T> {
  final String? errorMessage;

  const Error(this.errorMessage);
}
