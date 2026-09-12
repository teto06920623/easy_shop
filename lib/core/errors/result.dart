import 'package:easy_shop/core/errors/failures.dart';

sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Err<T> extends Result<T> {
  final Failure failure;
  const Err(this.failure);
}
