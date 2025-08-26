class ServerException implements Exception {
  ServerException({required this.message, this.statusCode});
  final String message;
  final int? statusCode;

  @override
  String toString() => 'ServerException(statusCode: ${statusCode?.toString() ?? 'null'}, message: $message)';
}

class NetworkException implements Exception {
  NetworkException({required this.message});
  final String message;

  @override
  String toString() => 'NetworkException(message: $message)';
}
