import 'package:dio/dio.dart';

import 'package:the_movie_app/core/config/api_config.dart';
import 'package:the_movie_app/core/error/exceptions.dart';

class DioClient {
  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.tmdbBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        queryParameters: <String, dynamic>{
          'api_key': ApiConfig.tmdbApiKey,
        },
        headers: <String, dynamic>{
          'Accept': 'application/json',
        },
      ),
    );
  }

  late final Dio _dio;

  Dio get dio => _dio;

  Never throwAsServerException(DioException error) {
    final status = error.response?.statusCode;
    final message = error.response?.data is Map<String, dynamic> ? (error.response?.data as Map<String, dynamic>)['status_message']?.toString() ?? error.message ?? 'Unknown server error' : (error.message ?? 'Unknown server error');
    throw ServerException(message: message, statusCode: status);
  }
}
