class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({required this.message, this.statusCode});

  @override
  String toString() => 'ServerException(message: $message, code: $statusCode)';
}

class NetworkException implements Exception {
  final String message;
  const NetworkException({this.message = 'No internet connection'});

  @override
  String toString() => 'NetworkException(message: $message)';
}

class UnauthorizedException implements Exception {
  final String message;
  const UnauthorizedException({
    this.message = 'Session expired or invalid credentials',
  });

  @override
  String toString() => 'UnauthorizedException(message: $message)';
}
